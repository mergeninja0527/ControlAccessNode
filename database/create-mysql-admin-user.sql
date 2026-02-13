-- Create MySQL user 'admin' so stored procedures (created with DEFINER=`admin`@`%`) can run.
-- Use this if you import the other developer's dump AS-IS and do not want to change it.
-- Run as root: mysql -u root -p < database/create-mysql-admin-user.sql
-- If 'admin' already exists, skip the CREATE USER lines and run only GRANT + FLUSH.

CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON zkteco_new.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON zkteco_new.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON zkteco.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON zkteco.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;
