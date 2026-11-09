/* CONTEXTO DEL ESCENARIO:
Continuando con la administración de la base de datos tienda_informatica, el
departamento de seguridad de la empresa exige endurecer las directivas de acceso para
cumplir estrictamente con las normativas de auditoría vigentes. Se requiere configurar
cuentas con caducidad de credenciales, control estricto de tiempo de sesión, roles, vistas de
seguridad y un análisis crítico de los privilegios asignados en MariaDB / MySQL
*/

-- Tarea 1: Creación de usuarios y políticas de conexión y caducidad
-- 1. Creación de cuentas 
CREATE USER 'gestor_tienda'@'localhost' IDENTIFIED BY '#Gestor@20:26';
-- Para crear una contraseña segura lo que hacemos es simplemente poner carácteres especiales.
CREATE USER 'auditor_externo'@'%' IDENTIFIED BY '@udit0r#2:026';
-- Igual que el anterior ponemos carácteres especiales en la contraseña para que sea segura.
/*Además algo muy importante para que las contraseñas sean seguras es no seguir el mismo patrón
para todos los usuarios, como vemos la contraseña de arriba no tiene nada que ver con la que hay
debajo.*/
-- 2. Directiva de caducidad de creedenciales
ALTER USER 'auditor_externo'@'%' PASSWORD EXPIRE INTERVAL 30 DAY;
/*Esto lo hago para que cuando pasen 30 días exactos la contraseña tenga que ser obligatoriamente
cambiada por otra lo que nos garantiza que cada mes tenemos otra contraseña totalmente nueva
ampliando la seguridad.*/
-- 3. Directiva de control de sesión. 
SET GLOBAL wait_timeout = 3600;
/* Esto lo hago para */

FLUSH PRIVILEGES; -- Para refrescar cada que hagamos cambios de permisos.

-- Tarea 2: Creación y asignación de roles
-- 1. Definición de rol operativo.
CREATE ROLE 'rol_consultor';
-- 2. Concesión de privilegios al rol.
GRANT SELECT ON tienda_informatica.* TO 'rol_consultor';
-- 3. Asignación y rol por defecto.
GRANT 'rol_consultor' TO 'auditor_externo'@'%';
ALTER USER 'auditor_externo'@'%' DEFAULT ROLE 'rol_consultor';

-- Tarea 3: Seguridad mediante Vistas y Privilegios Granulares
-- 1. Creación de la vista de enmascaramiento.
CREATE VIEW v_tecnicos_activos AS 
SELECT id, nombre, especialidad FROM tecnicos;
-- 2. Privilegio granular.
GRANT SELECT ON tienda_informatica.v_tecnicos_activos TO 'gestor_tienda'@'localhost';
-- 3. Prueba de denegación.
En el documento viene resuelto este apartado;

SELECT *
FROM v_tecnicos_activos;

-- Tarea 4: Consistencia y control con WITH CHECK OPTION
-- 1. Vista con restricción de dominio.
CREATE VIEW v_articulos_gama_baja AS
SELECT *
FROM articulos
WHERE precio <= 50.00
WITH CHECK OPTION;

SELECT * FROM v_articulos_gama_baja;

-- 2 Demostración técnica.
INSERT INTO v_articulos_gama_baja (id, nombre, precio, fabricante_id) VALUES
(20, 'Ratón razer', 75.00, 4);

INSERT INTO v_articulos_gama_baja (id, nombre, precio, fabricante_id) VALUES
(21, 'Alfombrilla', 5.00, 4);

SELECT nombre
FROM v_articulos_gama_baja
WHERE precio = 5.00;

-- Tarea 5: Auditoría, Resolución de Incidencias y Reflexión Crítica
En el documento viene resuelto este apartado;
-- 1 
SHOW GRANTS FOR 'auditor_externo'@'%';
SHOW GRANTS FOR 'rol_consultor';