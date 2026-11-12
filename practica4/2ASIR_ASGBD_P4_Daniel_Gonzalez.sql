CREATE DATABASE IF NOT EXISTS VIDEOJUEGOS;
USE VIDEOJUEGOS;
CREATE TABLE IF NOT EXISTS genero (
id_genero INT PRIMARY KEY,
nombre_genero VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS juego (
id_juego INT PRIMARY KEY,
id_genero INT,
nombre_juego VARCHAR(200),
FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
);

CREATE TABLE IF NOT EXISTS desarrollador (
id_desarrollador INT PRIMARY KEY,
nombre_desarrollador VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS desarrollador_juego (
id_des_juego INT PRIMARY KEY,
id_juego INT,
id_desarrollador INT,
FOREIGN KEY (id_juego) REFERENCES juego(id_juego),
FOREIGN KEY (id_desarrollador) REFERENCES desarrollador(id_desarrollador)
);

CREATE TABLE IF NOT EXISTS plataforma (
id_plataforma INT PRIMARY KEY,
nombre_plataforma VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS plataforma_juego (
id_plat_juego INT PRIMARY KEY,
id_desarrollador_juego INT,
id_plataforma INT,
anio_lanzamiento INT,
FOREIGN KEY (id_desarrollador_juego) REFERENCES desarrollador_juego(id_des_juego),
FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma)
);

-- INSERCIÓN DE DATOS:


--
-- Añadir datos a la tabla 'genero'
--
USE VIDEOJUEGOS;
INSERT INTO `genero` VALUES (1,'Estrategia'),(2,'MOBA'),(3,'ARPG'),(4,'Mundo abierto');


INSERT INTO `juego` VALUES 
	(1,1, 'Hearthstone'),(2,1,'Clash Royale'),
	(3,2, 'League of Legends'),(4,2,'Brawl Stars'),
    (5,3, 'Elden Ring'),(6,3,'Sekiro: Shadows Die Twice'),
    (7,4, 'Horizon Forbidden West'),(8,4,'The legend of Zelda: Breath of the wild');


--
-- Estructura de la tabla desarrollador
--


INSERT INTO `desarrollador` VALUES 
	(1,'Blizzard'),(2,'Supercell'),(3,'Riot Games'),(4,'FromSoftware'),(5, 'Guerrilla Games'), (6, 'Nintendo EPD'), (7, 'Monolith Soft');


--
-- Estructura de la tabla desarrollador_juego
--

INSERT INTO `desarrollador_juego` VALUES 
	(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 2), (5, 5, 4), (6, 6, 4), (7, 7, 5), (8, 8, 6);

SELECT * FROM desarrollador_juego;
--
--  Estructura de la tabla plataforma
--

INSERT INTO `plataforma` VALUES 
	(1, 'PC'), (2, 'PlayStation'), (3, 'Xbox'), (4, 'Mobile'), (5, 'Nintendo');


--
-- Estructura de la tabla plataforma_juego
--


INSERT INTO `plataforma_juego` VALUES 
	(1, 1, 1, 2014), (2, 1, 4, 2015), (3, 2, 4, 2016), (4, 3, 1, 2009),
    (5, 4, 4, 2017), (6, 5, 3, 2022), (7, 5, 1, 2022), (8, 5, 2, 2022),
    (9, 6, 3, 2019), (10, 6, 1, 2019), (11, 6, 2, 2019),
    (12, 7, 2, 2022), (13, 8, 5, 2017);
--
-- Ectura de la tabla plataforma
--

INSERT INTO `plataforma` VALUES 
	(1, 'PC'), (2, 'PlayStation'), (3, 'Xbox'), (4, 'Mobile'), (5, 'Nintendo');

SELECT *
FROM plataforma_juego;
--
-- Estructura de la tabla plataforma_juego
--

INSERT INTO `plataforma_juego` VALUES 
	(1, 1, 1, 2014), (2, 1, 4, 2015), (3, 2, 4, 2016), (4, 3, 1, 2009),
    (5, 4, 4, 2017), (6, 5, 3, 2022), (7, 5, 1, 2022), (8, 5, 2, 2022),
    (9, 6, 3, 2019), (10, 6, 1, 2019), (11, 6, 2, 2019),
    (12, 7, 2, 2022), (13, 8, 5, 2017);
/*
----------------------------------------------------------------------------------------
*/

-- Ejercicio 1: 
-- Crear un procedimiento que obtenga los videojuegos que pertenecen al género MOBA.

DELIMITER $
CREATE PROCEDURE NombreJuegoMOBA()
BEGIN 
	SELECT nombre_juego
	FROM juego
    WHERE id_genero = (SELECT id_genero
						FROM genero
						WHERE nombre_genero LIKE UPPER('MOBA'));
END $

CALL NombreJuegoMOBA();

-- Ejercicio 2
-- Crear un procedimiento que obtenga los videojuegos desarrollados por Supercell.

DROP PROCEDURE NombreJuegoSupercell;
DELIMITER $
CREATE PROCEDURE NombreJuegoSupercell()
BEGIN 
	SELECT nombre_juego
	FROM juego
	WHERE id_juego IN (SELECT id_juego
						FROM desarrollador_juego
						WHERE id_desarrollador IN (SELECT id_desarrollador
													FROM desarrollador
													WHERE nombre_desarrollador LIKE UPPER('SUPERCELL')));
END $

CALL NombreJuegoSupercell();

SELECT *
FROM juego;

SELECT *
FROM desarrollador_juego;

SELECT *
FROM desarrollador;

-- Ejercicio 3: 
-- Crear un procedimiento que obtenga el nombre de los videojuegos y el género de los juegos
-- publicados en la plataforma ‘PlayStation’

DROP PROCEDURE NombreJuegoPlaystation;
DELIMITER $
CREATE PROCEDURE NombreJuegoPlaystation()
BEGIN 
	SELECT j.nombre_juego, g.nombre_genero
    FROM juego j 
    INNER JOIN genero g 			  ON j.id_juego = g.id_genero
    INNER JOIN desarrollador_juego dj ON dj.id_juego = j.id_juego
    INNER JOIN plataforma_juego pj    ON pj.id_desarrollador_juego = dj.id_des_juego
    INNER JOIN plataforma p           ON p.id_plataforma = pj.id_plataforma
    WHERE p.nombre_plataforma LIKE UPPER('PLAYSTATION');

END $

USE VIDEOJUEGOS;

SELECT j.nombre_juego, g.nombre_genero
    FROM juego j 
    INNER JOIN genero g ON j.id_juego = g.id_genero
    INNER JOIN desarrollador_juego dj ON j.id_juego = dj.id_juego
    INNER JOIN plataforma_juego pj ON pj.id_desarrollador_juego = dj.id_des_juego
    INNER JOIN plataforma p ON p.id_plataforma = pj.id_plataforma
    WHERE nombre_plataforma LIKE UPPER('PLAYSTATION');
