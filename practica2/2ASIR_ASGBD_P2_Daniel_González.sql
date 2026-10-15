CREATE DATABASE IF NOT EXISTS tienda_informatica;
USE tienda_informatica;

-- PARTE1: CREACIÓN Y INSERCIÓN DE LOS DATOS
/*
Creamos la tabla fabricantes almacena a las marcas o 
fabricantes de los componentes. Con tres columnas, id
nombre y pais. Siendo id la clave primaria de la tabla.
*/

CREATE TABLE fabricantes (
id INT PRIMARY KEY,
nombre VARCHAR(50) UNIQUE NOT NULL,
pais VARCHAR(50)
);

/*
Creamos la tabala articulos que almacena productos a la venta.
Con cuatro columnas, id, nombre, precio, fabricante_id. 
Siendo id la clave primaria de la tabla y fabricante_id 
la foreign key de la taba fabricantes.
*/

CREATE TABLE articulos (
id INT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
fabricante_id INT,
FOREIGN KEY (fabricante_id) REFERENCES fabricantes(id)
);

/*
Creamos la tabla tecnicos que almacena los empleados del servicio
tecnico. Con cuatro columnas, id, nombre, especialidad, salario. 
Siendo la clave primaria id la clave primaria de la tabla.
*/

CREATE TABLE tecnicos (
id INT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
especialidad VARCHAR(100),
salario DECIMAL(6, 2) NOT NULL
);

/*
Creamos la tabla reparaciones que almacena reparaciones realizadas
por los tecnicos. Con cuatro columnas, id, descripcion_averia, 
coste_reparacion, tecnico_id. Siendo id la clave primaria y
tecnico_id la foreign key de la tabla tecnicos.
*/

CREATE TABLE reparaciones (
id INT PRIMARY KEY,
descripcion_averia VARCHAR(300) NOT NULL,
coste_reparacion DECIMAL(6, 2),
tecnico_id INT,
FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
);

-- DATOS INICIALES DE LAS TABLAS
-- Tabla fabricantes:
/*
Lo que hacemos usar el insert into para insertar datos dentro de
la tabla fabricantes. 
*/
INSERT INTO fabricantes (id, nombre, pais) VALUES
(1, 'Kingston', 'Estados Unidos'),
(2, 'Asus', 'Taiwán'),
(3, 'Samsung', 'Corea del Sur'),
(4, 'Logitech', 'Suiza'),
(5, 'Intel', 'Estados Unidos');
-- Comprobamos que se hayan insertado correctamente
SELECT *
FROM fabricantes;

-- Tabla articulos:
/*
Lo que hacemos usar el insert into para insertar datos dentro de
la tabla articulos. 
*/
INSERT INTO articulos (id, nombre, precio, fabricante_id) VALUES
(1, 'Memoria RAM 16GB DDR4', 45.50, 1),
(2, 'SSD NVMe 1TB', 79.99, 1),
(3, 'Placa Base ROG Strix', 185.00, 2),
(4, 'Monitor 27" IPS 144Hz', 249.00, 2),
(5, 'Monitor 32" Curved', 320.00, 3),
(6, 'Ratón Óptico Inalámbrico', 29.99, 4),
(7, 'Teclado Mecánico RGB', 89.90, 4),
(8, 'Procesador Core i7', 310.00, 5);
-- Comprobamos que se hayan insertado correctamente
SELECT *
FROM articulos;

-- Tabla tecnicos:
/*
Lo que hacemos usar el insert into para insertar datos dentro de
la tabla tecnicos. 
*/
INSERT INTO tecnicos (id, nombre, especialidad, salario) VALUES
(1, 'Carlos Pérez', 'Hardware', 1800.00),
(2, 'Ana Gómez', 'Redes y Servidores', 2100.00),
(3, 'Luis Martínez', 'Portátiles', 1650.00),
(4, 'Marta Ruiz', 'Movilidad y Tablets', 1750.00);
-- Comprobamos que se hayan insertado correctamente
SELECT *
FROM tecnicos;

-- Tabla reparaciones:
/*
Lo que hacemos usar el insert into para insertar datos dentro de
la tabla reparaciones. 
*/
INSERT INTO reparaciones (id, descripcion_averia, coste_reparacion, tecnico_id) VALUES
(1, 'Sustitución de pantalla rota', 120.50, 3),
(2, 'Cambio de fuente de alimentación', 65.00, 1),
(3, 'Recuperación de datos en disco dañado', 150.00, 2),
(4, 'Limpieza interna y cambio de pasta térmica', 45.00, 1),
(5, 'Sustitución de conector de carga', 50.00, 3),
(6, 'Ampliación de RAM y formateo', 80.00, 4);
-- Comprobamos que se hayan insertado correctamente
SELECT *
FROM reparaciones;

-- PARTE 2: BATERÍA DE CONSULTAS
/*
1. Consulta 1: Muestra el nombre y el precio de todos los artículos 
ordenados de formadescendente por su precio.
*/
SELECT nombre, precio
FROM articulos
ORDER BY precio DESC;
-- Usamos order by para ordenar de forma ascendente o descendente.

/*
2. Consulta 2: Muestra los nombres de los fabricantes cuyo 
país sea "Estados Unidos".
*/
SELECT nombre
FROM fabricantes
WHERE pais LIKE UPPER('Estados Unidos');
-- El UPPER lo que hace es transformar el texto a mayúsculas.

/*
Consulta 3: Muestra todos los datos de aquellos artículos cuyo precio 
sea mayor o igual a 100 y menor o igual a 300.
*/
SELECT *
FROM articulos
WHERE (precio >= 100) AND (precio <= 300);
-- El AND sirve para poner dos condiciones y ambas tienen que ser verdaderas.

/*
Consulta 4: Calcula el precio medio de todos los artículos almacenados en la tabla
articulos.
*/
SELECT ROUND(AVG(precio), 2) AS Precio_Medio
FROM articulos;
-- Usamos AVG para la media y ROUND para que redondee a dos decimales.

/*
Consulta 5: Muestra el identificador del fabricante y el número de 
artículos que tiene cada uno.
*/
SELECT fabricante_id, COUNT(id) AS Num_articulos
FROM articulos
GROUP BY fabricante_id;
-- COUNT para contar todas las filas de cada grupo.
-- GROUP BY para agurpar varias filas que comparten el mismo valor,
-- en una o más columnas.

/*
Consulta 6: Muestra los tecnico_id que han realizado más de una 
reparación.
*/
SELECT tecnico_id, COUNT(id) AS Num_reparaciones
FROM reparaciones
GROUP BY tecnico_id
HAVING COUNT(id) > 1;
-- HAVING para filtrar grupos
/*
Consulta 7: Muestra el nombre y el precio de los artículos fabricados 
por empresas de 'Taiwán' .
*/
SELECT nombre, precio
FROM articulos
WHERE fabricante_id IN (SELECT id
						FROM fabricantes
						WHERE pais LIKE UPPER('Taiwán'));
-- Hacemos primero una consulta para saber que id tiene Taiwan y una vez
-- lo tengamos ya sabemos que articulos son de ese fabricante.

/*
Consulta 8: Muestra la descripción y el coste de la reparación más cara registrada.
*/
SELECT descripcion_averia, coste_reparacion
FROM reparaciones
WHERE coste_reparacion = (SELECT MAX(coste_reparacion)
							FROM reparaciones);
-- Hacemos una subconsulta con MAX lo que hace es devolver el valor mas alto en una
-- columna.

SELECT descripcion_averia, coste_reparacion
FROM reparaciones
ORDER BY coste_reparacion DESC
LIMIT 1;
-- No se hasta que punto esta bien, pero es otra forma que he encontrado.

/*
Consulta 9: Muestra el nombre de los técnicos y el importe resultante de sumar a su
salario actual un 10% de subida.
*/
SELECT nombre, (salario + (salario * 0.10)) AS Importe_10
FROM tecnicos;
-- Calculamos con el * (multiplicar) y con + (sumar)

/*
Consulta 10: Muestra el nombre de los técnicos que no han realizado ninguna
reparación.
*/
SELECT nombre
FROM tecnicos
WHERE id IN (SELECT tecnico_id
				FROM reparaciones
				WHERE tecnico_id IS NULL);