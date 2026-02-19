/**
 * OpenAPI 3.0 spec for Control de Acceso API.
 * Served at /api-docs. Backend is used by all clients: tablet, mobile, desktop.
 */
const PORT = process.env.PORT || 3000;

module.exports = {
  openapi: '3.0.3',
  info: {
    title: 'Control de Acceso API',
    description: 'Backend API for all clients (tablet, mobile, desktop): login, invitations, user registration, units, QR.',
    version: '1.0.0',
  },
  servers: [
    { url: `http://localhost:${PORT}`, description: 'Local' },
    { url: '/', description: 'Current host' },
  ],
  tags: [
    { name: 'Auth', description: 'Login' },
    { name: 'Users', description: 'User registration and lookup' },
    { name: 'QR', description: 'QR code' },
    { name: 'Units', description: 'Units (salas)' },
    { name: 'Invitations', description: 'Invitations' },
  ],
  paths: {
    '/login': {
      post: {
        tags: ['Auth'],
        summary: 'Login',
        description: 'Login with RUT (username) and password. Returns user, roles, and unidades. Accepts JSON or form-data.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['username', 'password'],
                properties: {
                  username: { type: 'string', description: 'RUT (e.g. 12.345.678-5)', example: '12.345.678-5' },
                  password: { type: 'string', description: 'User password', example: 'mypassword' },
                },
              },
              example: { username: '12.345.678-5', password: 'mypassword' },
            },
            'application/x-www-form-urlencoded': {
              schema: {
                type: 'object',
                required: ['username', 'password'],
                properties: {
                  username: { type: 'string', description: 'RUT (e.g. 12.345.678-5)', example: '12.345.678-5' },
                  password: { type: 'string', description: 'User password', example: 'mypassword' },
                },
              },
              example: { username: '12.345.678-5', password: 'mypassword' },
            },
            'multipart/form-data': {
              schema: {
                type: 'object',
                required: ['username', 'password'],
                properties: {
                  username: { type: 'string', description: 'RUT (e.g. 12.345.678-5)', example: '12.345.678-5' },
                  password: { type: 'string', description: 'User password', example: 'mypassword' },
                },
              },
            },
          },
        },
        responses: {
          200: {
            description: 'Login OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    username: { type: 'string', description: 'Display name' },
                    user: { type: 'string', description: 'RUT (normalized)' },
                    userrol: { type: 'number' },
                    passTemp: { type: 'number' },
                    roles: { type: 'array', items: { type: 'object', properties: { value: { type: 'number' }, label: { type: 'string' }, tipo: { type: 'string' } } } },
                    unidades: { type: 'array', items: { type: 'object', properties: { value: { type: 'number' }, label: { type: 'string' } } } },
                  },
                },
              },
            },
          },
          403: { description: 'Usuario o contraseña inválidos' },
        },
      },
    },
    '/obtainQR': {
      post: {
        tags: ['QR'],
        summary: 'Obtain QR',
        description: 'Request QR code for a user. Returns base64 PNG and validity info. Validity: 20 min (admin), 50 min (resident).',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['user'],
                properties: {
                  user: { type: 'string', description: 'User RUT (username)', example: '12345678-9' },
                },
              },
              example: { user: '12345678-9' },
            },
            'application/x-www-form-urlencoded': {
              schema: {
                type: 'object',
                required: ['user'],
                properties: {
                  user: { type: 'string', description: 'User RUT' },
                },
              },
              example: { user: '12345678-9' },
            },
          },
        },
        responses: {
          200: {
            description: 'QR code and validity',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    qrCode: { type: 'string', description: 'Base64 PNG data URL (data:image/png;base64,...)' },
                    validityEnd: { type: 'string', format: 'date-time', description: 'Expiration ISO string' },
                    validityMinutes: { type: 'integer' },
                  },
                },
              },
            },
          },
          400: { description: 'user is required' },
        },
      },
    },
    '/obtainQR/{user}': {
      get: {
        tags: ['QR'],
        summary: 'Get QR for user',
        parameters: [{ name: 'user', in: 'path', required: true, schema: { type: 'string' }, description: 'User RUT' }],
        responses: { 200: { description: 'OK' } },
      },
    },
    '/createUser': {
      post: {
        tags: ['Users'],
        summary: 'Create user',
        description: 'Register a new user (resident or admin). RUT must include hyphen (e.g. 12345678-9). sala required when rol is RES.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['rut', 'nombre', 'correo', 'telefono', 'rol', 'fechaInicio', 'fechaFin'],
                properties: {
                  rut: { type: 'string', description: 'RUT with hyphen (dots removed OK)', example: '12345678-9' },
                  nombre: { type: 'string', description: 'Full name', example: 'Juan Pérez' },
                  correo: { type: 'string', format: 'email', description: 'Email', example: 'juan.perez@email.com' },
                  telefono: { type: 'string', description: 'Phone', example: '+56912345678' },
                  password: { type: 'string', description: 'Password (optional)' },
                  rol: { type: 'string', enum: ['ADM', 'RES', 'SAD'], description: 'Role code' },
                  sala: { type: 'integer', description: 'Unit ID (required when rol is RES)', example: 101 },
                  fechaInicio: { type: 'string', format: 'date-time', example: '2025-02-12 00:00:00' },
                  fechaFin: { type: 'string', format: 'date-time', example: '2026-02-12 23:59:59' },
                },
              },
              example: {
                rut: '12345678-9',
                nombre: 'Juan Pérez',
                correo: 'juan.perez@email.com',
                telefono: '+56912345678',
                password: 'secret123',
                rol: 'RES',
                sala: 101,
                fechaInicio: '2025-02-12 00:00:00',
                fechaFin: '2026-02-12 23:59:59',
              },
            },
            'application/x-www-form-urlencoded': {
              schema: {
                type: 'object',
                required: ['rut', 'nombre', 'correo', 'telefono', 'rol', 'fechaInicio', 'fechaFin'],
                properties: {
                  rut: { type: 'string' },
                  nombre: { type: 'string' },
                  correo: { type: 'string' },
                  telefono: { type: 'string' },
                  password: { type: 'string' },
                  rol: { type: 'string', enum: ['ADM', 'RES', 'SAD'] },
                  sala: { type: 'integer' },
                  fechaInicio: { type: 'string' },
                  fechaFin: { type: 'string' },
                },
              },
              example: {
                rut: '12345678-9',
                nombre: 'Juan Pérez',
                correo: 'juan.perez@email.com',
                telefono: '+56912345678',
                password: 'secret123',
                rol: 'RES',
                sala: 101,
                fechaInicio: '2025-02-12 00:00:00',
                fechaFin: '2026-02-12 23:59:59',
              },
            },
          },
        },
        responses: { 200: { description: 'OK' }, 400: { description: 'Validation error' }, 403: { description: 'Forbidden' } },
      },
    },
    '/check-rut': {
      post: {
        tags: ['Users'],
        summary: 'Check if RUT exists',
        requestBody: {
          content: {
            'application/json': { schema: { type: 'object', properties: { rut: { type: 'string' } } } },
            'application/x-www-form-urlencoded': { schema: { type: 'object', properties: { rut: { type: 'string' } } } },
          },
        },
        responses: { 200: { description: 'OK' } },
      },
    },
    '/unidades': {
      get: {
        tags: ['Units'],
        summary: 'Get units (salas)',
        description: 'List available units for selectors.',
        responses: { 200: { description: 'List of unidades (value, label)' } },
      },
    },

    '/invitations': {
      get: {
        tags: ['Invitations'],
        summary: 'List invitations',
        description: 'List invitations created by a user.',
        parameters: [
          { name: 'userId', in: 'query', required: true, schema: { type: 'string' }, description: 'Creator RUT (IDUsuario)' },
        ],
        responses: { 200: { description: 'List of invitations' } },
      },
      post: {
        tags: ['Invitations'],
        summary: 'Create invitation',
        description: 'Create a visitor invitation and get QR code. Payload stores activo: 1 by default.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['createdBy', 'nombreInvitado', 'rutInvitado', 'fechaInicio', 'fechaFin'],
                properties: {
                  createdBy: { type: 'string', description: 'Creator RUT (IDUsuario)' },
                  nombreInvitado: { type: 'string', description: 'Guest name' },
                  rutInvitado: { type: 'string', description: 'Guest RUT', example: '12345678-9' },
                  correoInvitado: { type: 'string', description: 'Guest email' },
                  telefonoInvitado: { type: 'string', description: 'Guest phone' },
                  tipoInvitacion: { type: 'string', enum: ['Visitante', 'Delivery'], default: 'Visitante' },
                  motivo: { type: 'string', description: 'Visit reason' },
                  fechaInicio: { type: 'string', format: 'date-time', example: '2025-02-12 08:00:00' },
                  fechaFin: { type: 'string', format: 'date-time', example: '2025-02-12 20:00:00' },
                  idSala: { type: 'integer', description: 'Unit ID (sala)' },
                  usageLimit: { type: 'integer', description: 'Max uses (1 for Delivery)' },
                },
              },
              example: {
                createdBy: '11111111-1',
                nombreInvitado: 'María García',
                rutInvitado: '12345678-9',
                correoInvitado: 'maria@email.com',
                telefonoInvitado: '+56987654321',
                tipoInvitacion: 'Visitante',
                motivo: 'Reunión',
                fechaInicio: '2025-02-12 08:00:00',
                fechaFin: '2025-02-12 20:00:00',
                idSala: 101,
                usageLimit: 1,
              },
            },
          },
        },
        responses: {
          201: {
            description: 'Created',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean' },
                    id: { type: 'string', description: 'IDAcceso (QR code value)' },
                    qrCode: { type: 'string' },
                  },
                },
              },
            },
          },
          400: { description: 'Validation error' },
        },
      },
    },
    '/invitations/{id}': {
      get: {
        tags: ['Invitations'],
        summary: 'Get invitation by ID',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' }, description: 'IDAcceso' }],
        responses: { 200: { description: 'Invitation details' }, 404: { description: 'Not found' } },
      },
      delete: {
        tags: ['Invitations'],
        summary: 'Delete invitation',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' } }],
        responses: { 200: { description: 'Deleted' } },
      },
    },
    '/invitations/{id}/cancel': {
      post: {
        tags: ['Invitations'],
        summary: 'Cancel invitation',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' } }],
        responses: { 200: { description: 'Cancelled' } },
      },
    },
  },
};
