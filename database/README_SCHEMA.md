# Database schema (integrated with device backend)

When integrating with the device backend, use the **integrated schema** provided by the other developer:

- **File:** `zkteco_new_20260212.sql`
- **User creation:** `tbl_usuarios` (not PRY_Usuarios)
- **Invitations & access (QR):** `tbl_acceso` (not PRY_Acceso; PRY_Invitacion is merged into tbl_acceso)

## Same dump for you and the other developer (MariaDB vs AWS RDS)

This repo is used in two environments: **your local MariaDB** and the **other developer’s AWS RDS** (often MySQL 5.7 or 8.0). Versions differ, so the dump in the repo is kept **compatibility-friendly** so **one file works in both**:

- **Collation:** `utf8mb4_general_ci` instead of MySQL‑8‑only `utf8mb4_0900_ai_ci` → works on MariaDB and on RDS (5.7/8.0).
- **Procedures:** No `DEFINER` → they run as the user that imports/connects, so no need for an `admin` user on RDS or locally.
- **Procedure parameter:** `ppass` instead of `pcontraseña` → avoids encoding issues across tools and versions.

**Result:** You and the other developer can both use **the same** `zkteco_new_20260212.sql`: import it on your MariaDB and on AWS RDS without changing DB versions or maintaining two dumps. The application code (tbl_usuarios, tbl_acceso, procedures) is identical in both environments.

## Setup

1. Create/use a MySQL database (e.g. `zkteco` or `zkteco_new`).
2. Import the dump:
   ```bash
   mysql -u user -p your_database < database/zkteco_new_20260212.sql
   ```
3. In `.env`, set the database name:
   ```
   DB_DABS=zkteco
   ```
   (or the name you used in step 1)

## Table mapping

| Old (setup.js)   | Integrated (zkteco_new_20260212.sql) |
|------------------|--------------------------------------|
| PRY_Usuarios     | tbl_usuarios                         |
| PRY_Acceso       | tbl_acceso                           |
| PRY_Invitacion   | (merged into tbl_acceso; Payload.isInvitation = true) |

Stored procedures (`spPRY_*`) in the integrated dump already reference `tbl_usuarios` and `tbl_acceso`.

## tbl_acceso: two kinds of rows (why “invitation history” is empty for some users)

**tbl_acceso** holds two different things, distinguished by **Payload**:

1. **User’s own access/QR** (from **Crear Usuario**):  
   - **IDUsuario** = the **created user’s RUT** (the person who can log in and use the QR).  
   - **Payload** looks like: `{"codigo":"...","fechaInicio":"...","fechaFin":"...","sala":1,"isCard":false,"roleId":2,"leaseStart":"...","leaseEnd":"..."}`  
   - **No** `isInvitation` (or false).  
   - These rows are **not** invitation history; they are the access window for that user.

2. **Invitation** (from **Invitar / Visita**):  
   - **IDUsuario** = the **creator’s RUT** (the logged-in user who created the invitation).  
   - **Payload** has **`isInvitation: true`** and invitation fields: `nombreInvitado`, `rutInvitado`, `correoInvitado`, `fechaInicio`, `fechaFin`, `motivo`, `qrCode`, etc.  
   - **Invitation history** = list of these rows for a given user (creator).

So the payload you showed is type (1). It is stored for the **new user’s RUT**, and it does **not** have `isInvitation: true`, so it will **never** appear in “Mis Invitaciones” for anyone. To see invitation history, create an **invitation** from the **Invitar** (Visita) flow; those rows have `Payload.isInvitation = true` and `IDUsuario` = creator RUT.

**API:** `GET /invitations?userId=<creator RUT>` returns only rows where `Payload.isInvitation === true` and `IDUsuario` matches the normalized creator RUT. To verify in the DB:

```sql
SELECT IDAcceso, IDUsuario, Payload FROM tbl_acceso
WHERE REPLACE(REPLACE(IFNULL(IDUsuario,''), '.', ''), ' ', '') = '<your RUT without dots>';
-- Then in your app or by inspecting Payload: only rows with isInvitation: true appear in invitation history.
``` The Node backend has been updated to work with this schema (user creation, login, obtain QR, invitations, validate QR, IClock rtlog).

## Password (MD5)

- **tbl_usuarios.Passwd** is stored as **MD5(plain)**.
- Stored procedures **spPRY_Usuario_Guardar** and **spPRY_Usuarios_CambiarPass** apply `MD5(ppass)` in the DB, so the backend passes **plain** password; the DB hashes it.
- For any **password verification** (e.g. login with password), hash the user input with MD5 and compare to `Passwd`. Use `utils/Functions.js` → `hashPasswordMD5(plain)`.

## Do I need to upgrade MariaDB/MySQL?

**No.** The dump was produced on MySQL 8.0. On older MySQL or MariaDB you may see:

- **Unknown collation `utf8mb4_0900_ai_ci`** – MySQL 8.0 only. Use a dump that uses `utf8mb4_general_ci` instead, or create the DB on 8.0 and export with a compatible collation.
- **Definer `admin`@`%` does not exist** – The procedures were created with that user. Either create that user (see `create-mysql-admin-user.sql`) or use a dump where `DEFINER` was removed so procedures run as the user that imports.

You can stay on your current MariaDB/MySQL version and either apply the compatibility fixes below or create the `admin` user.

## Keeping the “final” dump unchanged

If you must **not** change the dump file you receive from the other developer:

1. **Keep their file as-is** (e.g. `zkteco_new_20260212_ORIGINAL.sql`).
2. **Create the MySQL user** so the definer exists:
   ```bash
   mysql -u root -p < database/create-mysql-admin-user.sql
   ```
3. **Collation:** If you get `Unknown collation: 'utf8mb4_0900_ai_ci'`, your server is older than MySQL 8.0. Options:
   - Import on MySQL 8.0 and use that DB, or
   - Ask for a dump that uses `utf8mb4_general_ci`, or
   - Use a one-off patched copy only for import (e.g. `sed 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' original.sql > patched.sql` then import `patched.sql`).
4. **Non-ASCII in procedure (e.g. `pcontraseña`):** If you get a syntax error on a parameter name with `ñ`, the file encoding or the way it’s run can break that. Using a UTF-8 safe import (e.g. `mysql ... --default-character-set=utf8mb4 < file.sql`) or a dump where that parameter is renamed to `ppass` avoids the issue.

**In this repo**, `zkteco_new_20260212.sql` has already been patched for local/older MySQL (collation, DEFINER removed, one procedure parameter name). Use that for local import; keep the other dev’s original elsewhere if you need an untouched copy.

## Optional

- **Invitation payloads:** The base schema has `tbl_acceso.Payload` as `VARCHAR(255)`. Invitation rows store JSON with a base64 QR image and get truncated, so the list can show “no invitations” even when rows exist. Run `database/alter-tbl_acceso-payload-text.sql` to change `Payload` to `TEXT` so full payloads are stored. The backend also parses truncated payloads so existing rows still appear in the list (QR may be missing until you re-save or alter the column).
- Access event logging may use `device_access_logs` in the integrated DB instead of `PRY_AccessEvent`.
