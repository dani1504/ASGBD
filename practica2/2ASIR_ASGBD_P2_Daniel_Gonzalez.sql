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

-- Como se hace un update en las tablas:
UPDATE nombre_tabla
SET columna = nuevo_valor
WHERE condicion;

-- Como se hace un delete:
DELETE FROM nombre_tabla
WHERE condicion;

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
WHERE id NOT IN (SELECT tecnico_id
				FROM reparaciones
				WHERE tecnico_id);
                
-- PARTE 2: CONSULTAS
-- Batería de Consultas 1:
USE tienda_informatica;
/*
Consulta 1: Muestra el nombre y el precio de aquellos artículos que sean, exactamente, el
artículo más caro de su respectivo fabricante.
*/
SELECT nombre, precio
FROM articulos a1
WHERE precio = (SELECT MAX(precio)
					FROM articulos a2
                    WHERE a1.fabricante_id = a2.fabricante_id);
/*
Una consulta con una subconsulta buscando el precio maximo de los articulos de cada fabricante.
*/
/*
Consulta 2: Muestra el nombre de los fabricantes que no tienen ningún artículo con un precio
inferior o igual a la media general de precios de toda la tienda.
*/

SELECT *
FROM fabricantes;

SELECT *
FROM articulos;

SELECT nombre
FROM fabricantes
WHERE id NOT IN (SELECT fabricante_id
			     FROM articulos
		         WHERE precio <= (SELECT AVG(precio)
								  FROM articulos)
				 GROUP BY fabricante_id);
/*
Para esta consulta lo que he hecho ha sido una subconsulta para saber que ids de fabricantes tienen un articulo
con un precio menor o igual a la media de toda la tienda. Una vez sabiendo los que SI tienen un articulo 
puedo saber el nombre de los que NO tienen un articulo inferior o igual a la media y por eso he usado NOT IN.
*/

/*
Consulta 3: Muestra la descripción y el coste de aquellas reparaciones cuyo coste sea
estrictamente superior a la media de las reparaciones realizadas por su propio técnico.
*/
select *
from reparaciones;

SELECT descripcion_averia, coste_reparacion
FROM reparaciones r1
WHERE coste_reparacion > (SELECT ROUND(AVG(coste_reparacion),2)
								FROM reparaciones r2
                                WHERE r1.tecnico_id = r2.tecnico_id
								GROUP BY tecnico_id);
/*
En esta consulta lo que he hecho ha sido hacer una subconsulta correlacionada, es decir, estas subconsultas 
hacen referencia a columnas de la tabla externa, en este caso a reparaciones r1. La subconsulta calcula la 
media de los costes por cada técnico, filtrando a los técnicos que superan la media.
*/

/*
Consulta 4: Muestra el identificador y la especialidad de los técnicos cuya suma total del coste de
las reparaciones que han realizado supere el doble de su propio salario.
*/

SELECT id, especialidad
FROM tecnicos t
WHERE (salario * 2) < (SELECT SUM(coste_reparacion)
							FROM reparaciones r
                            WHERE t.id = r.tecnico_id
                            GROUP BY tecnico_id);
   
SELECT *
FROM tecnicos;

INSERT INTO reparaciones (id, descripcion_averia, coste_reparacion, tecnico_id) VALUES
(16, 'Caída de servidores', 9000, 4);

/*
En esta consulta lo que he hecho ha sido hacer una subconsulta correlacionada, es decir, estas subconsultas 
hacen referencia a columnas de la tabla externa, en este caso a tecnicos t. La subconsulta calcula la 
suma de los costes por cada técnico, filtrando al técnico que la suma del coste de las reparaciones que ha
relizado supere al doble de su salario. En este caso, no había ningún técnico que cumpliera esa condición
así que lo que hice fue insertar a la tabla reparaciones una reparación con un coste alto.
*/

/*
Consulta 5: Muestra el nombre del fabricante (o fabricantes) que posee el mayor número de
artículos registrados en la base de datos.
*/

SELECT * FROM fabricantes;
select * from articulos;
-- suma de los articulos totales por cada fabricante_id
SELECT SUM(id) AS articulos_totales, fabricante_id
FROM articulos
GROUP BY fabricante_id;
-- seleccionar el fabricante_id con mayor numero de articulos registrados
SELECT MAX(articulos_totales)
FROM (SELECT SUM(id) AS articulos_totales, fabricante_id
		FROM articulos
		GROUP BY fabricante_id) AS tabla_max;
-- Hacemos un filtro con having para saber el fabricante
SELECT fabricante_id
FROM articulos
GROUP BY fabricante_id
HAVING SUM(id) IN (SELECT MAX(articulos_totales)
					FROM (SELECT SUM(id) AS articulos_totales, fabricante_id
							FROM articulos
							GROUP BY fabricante_id) AS tabla_max);
-- Para mostrar el nombre del fabricante hay que relacionarla con la tabla fabricantes pero como no hay join:
SELECT nombre
FROM fabricantes
WHERE id IN (SELECT fabricante_id
			FROM articulos
			GROUP BY fabricante_id
			HAVING COUNT(id) IN (SELECT MAX(articulos_totales)
								FROM (SELECT COUNT(id) AS articulos_totales, fabricante_id
										FROM articulos
										GROUP BY fabricante_id) AS tabla_max));
                                        
/*
En esta consulta agrupo los artículos por fabricante para calcular el total de cada uno y sacar el valor máximo en una tabla con
alias tabla_max. Con el HAVING e IN me quedo con el (o los) ID del fabricante (o fabricantes) que alcanza esa cifra máxima. Por último, 
en la consulta principal uso ese ID con un IN para mostrar la columna del nombre.
*/

/*
Consulta 6: Muestra el nombre de los técnicos que han realizado alguna reparación, pero que
nunca han realizado ninguna reparación cuyo coste haya superado los 100.00 euros.
*/

SELECT nombre
FROM tecnicos
WHERE id NOT IN (SELECT tecnico_id
				 FROM reparaciones
				 WHERE coste_reparacion > 100.00);

SELECT *
FROM reparaciones;
/*
He hecho una subconsulta para que me muestre los id de los tecnicos que hayan superado alguna vez los 100 euros en una reparacion.
Luego con un where y NOT IN para que me muestre los que nunca hayan superado una reparacion que haya costado 100 euros. 
Y luego uso IN para que me de los id de los que nunca han superado 100 euros y con el id ya puede mostrar el nombre de los tecnicos.
*/

/*
Consulta 7: Muestra el nombre y el salario de los técnicos cuyo salario sea inferior a la media
salarial de su propia especialidad.
*/

SELECT nombre, salario
FROM tecnicos t
WHERE salario < (SELECT AVG(salario)
					FROM tecnicos
					WHERE especialidad = t.especialidad
                    GROUP BY especialidad);
                    
SELECT AVG(salario)
FROM tecnicos
GROUP BY especialidad;
                  
SELECT *
FROM tecnicos;

INSERT INTO tecnicos (id, nombre, especialidad, salario) VALUES
(7, 'Sergio Gonzalez', 'Movilidad y Tablets', 500);

/*
En esta consulta lo que he hecho ha sido hacer una subconsulta correlacionada, es decir, estas subconsultas 
hacen referencia a columnas de la tabla externa, en este caso a tecnicos t. La subconsulta calcula la media
salarial de la propia especialidad de cada técnico y luego la consulta principal filtra que técnicos tienen
un salario inferior a la media de su especialidad. En este caso, no había ningún técnico que cumpliera esa 
condición así que lo que hice fue insertar a la tabla tecnicos un técnico que tuviera un salario muy bajo.
*/

/*
Consulta 8: Muestra el nombre de los fabricantes cuyo país coincide con el país del fabricante
que produce el artículo más caro de toda la tienda.
*/

SELECT nombre
FROM fabricantes 
WHERE pais = (SELECT pais
				FROM fabricantes
				WHERE id = (SELECT fabricante_id
								FROM articulos 
								WHERE precio = (SELECT MAX(precio)
												FROM articulos)));

/*
Para esta consulta he ido anidando varios SELECT: primero busco el artículo más caro y saco su fabricante.
Luego miro de qué país es ese fabricante en concreto, y con ese dato ya filtro en la consulta principal 
para mostrar el nombre de todos los fabricantes que sean de ese mismo país.
*/

/*
Consulta 9: Muestra el nombre y el precio del artículo más barato de entre todos los fabricantes
que son originarios de 'Estados Unidos'.
*/

SELECT MIN(precio)
FROM articulos;

SELECT fabricante_id
FROM articulos
WHERE precio = (SELECT MIN(precio)
				FROM articulos);

SELECT id 
FROM fabricantes
WHERE pais LIKE UPPER('Estados Unidos');

SELECT MIN(precio)
FROM articulos
WHERE fabricante_id IN (SELECT id 
						FROM fabricantes
						WHERE pais LIKE UPPER('Estados Unidos'));

SELECT nombre, precio 
FROM articulos
WHERE precio = (SELECT MIN(precio)
				FROM articulos
				WHERE fabricante_id IN (SELECT id 
										FROM fabricantes
										WHERE pais LIKE UPPER('Estados Unidos')));
                                        
SELECT * FROM fabricantes;

/*
Para esta consulta he ido anidando varios SELECT: primero busco que fabricantes son de Estados unidos.
Luego lo que hago es buscar el articulos más barato filtrando por los fabricantes que son de Estados
Unidos. Y por último en la consulta principal mostramos el nombre y precio del artículo más barato y
con orígen Estados Unidos.
*/

/*
Consulta 10: Muestra el identificador del técnico (tecnico_id) que ha acumulado el mayor
coste total en reparaciones.
*/

SELECT * FROM reparaciones;
SELECT * FROM tecnicos;

SELECT SUM(coste_reparacion) AS coste_total
FROM reparaciones 
GROUP BY tecnico_id;

SELECT MAX(coste_total)
FROM (SELECT SUM(coste_reparacion) AS coste_total, tecnico_id AS id_tecnico
		FROM reparaciones 
		GROUP BY tecnico_id) AS tabla_max;

SELECT tecnico_id
FROM reparaciones
GROUP BY tecnico_id
HAVING SUM(coste_reparacion) = ((SELECT MAX(coste_total)
								FROM (SELECT SUM(coste_reparacion) AS coste_total, tecnico_id AS id_tecnico
										FROM reparaciones 
										GROUP BY tecnico_id) AS tabla_max));

/*
He agrupado las reparaciones por técnico y mediante HAVING he filtrado para mostrar solo al técnico que 
la suma del coste de sus reparaciones iguala el coste total máximo. Ese filtro HAVING lo he sacado calculando 
la suma total del coste de reparaciones de cada técnico y lo he metido dentro de una tabla a la que le he dado 
un alias tabla_max para poder sacar al coste de reparaciones total más alto.
*/

-- Batería de Consultas 2:
/*
Consulta 1: Muestra el nombre de cada artículo junto con el nombre de su fabricante, pero
únicamente para aquellos artículos cuyo precio sea superior a 100.00 euros.
*/

SELECT a.nombre, f.nombre
FROM articulos a
INNER JOIN fabricantes f ON f.id = a.fabricante_id
WHERE precio > 100.00;

SELECT *
FROM tecnicos;

/* 
Tenemos que hacer un inner join ya que nos dicen que tenemos que mostrar cada artículo con su
fabricante, además un where para que muestre solamente los superiores a 100 euros.
*/
SELECT *
FROM articulos;

/*
Consulta 2: Muestra el nombre de todos los fabricantes de la base de datos y, al lado, el nombre
de sus artículos. Asegúrate de que aparezcan los fabricantes que no tienen ningún
artículo registrado.
*/

SELECT f.nombre AS fabricante, a.nombre AS articulo
FROM fabricantes f
LEFT JOIN articulos a ON f.id = a.fabricante_id;

INSERT INTO fabricantes (id, nombre) VALUES 
(9, 'Apple');

SELECT nombre
FROM fabricantes;

/*
Tenemos que hacer un LEFT JOIN ya que nos piden todos lo fabricantes aunque no tengan ningún
artículo registrado. Eso es lo que hace el LEFT JOIN, muestra hasta lo que no tienen nada en
común con la tabla artículos.
*/

/*
Consulta 3: Muestra el nombre del fabricante y la media de los precios de sus artículos, 
pero solo para aquellos fabricantes cuya media de precios supere los 150.00 euros.
*/

SELECT f.nombre, ROUND(AVG(a.precio), 2)
FROM fabricantes f
INNER JOIN articulos a ON f.id = a.fabricante_id
GROUP BY f.nombre
HAVING AVG(a.precio) > 150.00;

/*
Tenemos que agrupar por nombre de fabricantes para 
*/

/*
Consulta 4: Muestra la descripción de la avería, el coste de la reparación y el nombre del 
técnico que la ha llevado a cabo, ordenado por el coste de mayor a menor.
*/

SELECT descripcion_averia, coste_reparacion, t.nombre
FROM reparaciones r
INNER JOIN tecnicos t ON r.tecnico_id = t.id
ORDER BY coste_reparacion DESC;
-- Hacemos un inner join porque no queremos que nos muestre una reparacion que no tenga asignado
-- ningun tecnico y un order by para ordenar de mayor a menor.

/*
Consulta 5: Muestra el nombre de aquellos técnicos que no han realizado ninguna reparación,
utilizando obligatoriamente un cruce externo de tablas.
*/
SELECT *
FROM tecnicos;
-- Primero insertamos un tecnico que no hayan realizado ninguna reparación
INSERT INTO tecnicos (id, nombre, salario) VALUES
(5, 'Daniel Gonzalez', 1500);

SELECT t.nombre, r.descripcion_averia
FROM tecnicos t
LEFT JOIN reparaciones r ON t.id = r.tecnico_id
WHERE r.tecnico_id IS NULL;
-- Esta consulta vemos que nos muestra toda la tabla de tecnicos relacionada con la de reparaciones pero
-- como queremos que solo se muestre los que no hayan realizado ninguna reparacion hay que filtrar con IS NULL.

/*
Consulta 6: Muestra el nombre del técnico y la suma total del dinero recaudado con sus
reparaciones, filtrando únicamente aquellos técnicos cuya recaudación total supere
los 100.00 euros.
*/
SELECT *
FROM reparaciones;

SELECT t.nombre, SUM(r.coste_reparacion)
FROM tecnicos t
INNER JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.nombre
HAVING SUM(r.coste_reparacion) > 100.00;

/*
Lo que hay que hacer en esta consulta es hacer una suma a coste_reparacion para ver
el total del dinero recaudado. Agrupar por tecnicos y hacer un filtro con HAVING,
para que nos muestre solo los que han recaudado mas de 100 euros.
*/

/*
Consulta 7: Muestra el nombre de los artículos y el nombre de su respectivo fabricante, pero
filtrando exclusivamente aquellos artículos cuyos fabricantes sean originarios de
'Estados Unidos' o 'Taiwán'.
*/
SELECT *
FROM fabricantes;

SELECT *
FROM articulos;

SELECT a.nombre AS articulo, f.nombre AS fabricante
FROM articulos a 
INNER JOIN fabricantes f ON a.fabricante_id = f.id
WHERE f.pais LIKE UPPER('Estados Unidos') OR f.pais LIKE UPPER('Taiwán');
-- En este caso hacemos el JOIN filtrando el pais ya que pide que los fabricantes originarios
-- deben ser estados unidos o taiwan.

/*
Consulta 8: Muestra el nombre de todos los técnicos y, al lado, el número total de reparaciones
que ha realizado cada uno de ellos.
*/

SELECT t.nombre, COUNT(r.id)
FROM tecnicos t
INNER JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.nombre;

-- COUNT para contar las filas asi sabemos cuantas reparaciones a hecho ese tecnico. Agrupamos,
-- ya que nos piden cada uno de ellos.

/*
Consulta 9: Muestra el nombre del fabricante y el número total de artículos que produce, pero
solo de aquellos fabricantes que tengan un número de artículos mayor o igual a 2.
*/

SELECT f.nombre, COUNT(a.id)
FROM fabricantes f
INNER JOIN articulos a ON f.id = a.fabricante_id
GROUP BY f.nombre
HAVING COUNT(a.id) >= 2;
-- Hacemos filtro con HAVING de que el número de artículos tiene que ser mayor o igual a 2,
-- y agrupamos por fabricantes.

/*
Consultas 10: Muestra el nombre del técnico, su especialidad y la descripción de la reparación más
costosa que ha realizado cada uno de ellos.
*/
SELECT *
FROM reparaciones;

SELECT t.nombre, t.especialidad, MAX(coste_reparacion)
FROM tecnicos t
INNER JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.id;

-- MAX coje el valor maximo en esa colunma para cada grupo, en este caso para cada uno de los tecnicos


-- Muestra el nombre del articulo, su precio y el nombre del fabricante para aquellos
-- articulos que tienen el precio maxima dentro de su propio fabricante.

USE tienda_informatica;

SELECT *
FROM articulos;

SELECT *
FROM fabricantes;

SELECT a.nombre AS nombre_articulo, a.precio, f.nombre AS nombre_fabricante
FROM articulos a
INNER JOIN fabricantes f ON a.fabricante_id = f.id
WHERE precio IN (SELECT MAX(precio)
					FROM articulos a
					GROUP BY fabricante_id);

SELECT MAX(precio), fabricante_id
FROM articulos a
GROUP BY fabricante_id;
