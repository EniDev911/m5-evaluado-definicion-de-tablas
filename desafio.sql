-- formato
\pset border 2
DROP DATABASE IF EXISTS peliculas;
CREATE DATABASE peliculas
  ENCODING 'UTF8';

\c peliculas;

DROP TABLE IF EXISTS peliculas;

CREATE TABLE peliculas (
	id INT4 PRIMARY KEY,
	pelicula VARCHAR(64) NOT NULL,
	"año estreno" INT4 NOT NULL,
	director VARCHAR(50) NOT NULL
);

-- CARGAMOS EL CSV de peliculas.csv
\copy peliculas (id, pelicula, "año estreno", director) FROM './peliculas.csv' WITH DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS reparto CASCADE;
CREATE TABLE reparto (
	id_pelicula INT4,
    nombre_actor VARCHAR(50) NOT NULL,
    CONSTRAINT fk_pelicula
      FOREIGN KEY(id_pelicula) 
	  REFERENCES peliculas(id)
);

-- CARGAMOS EL CSV DE reparto.csv
\copy reparto (id_pelicula, nombre_actor) FROM './reparto.csv' WITH DELIMITER ',';

-- Obtener el ID de la película “Titanic”.
SELECT id FROM peliculas WHERE pelicula = 'Titanic';

-- Listar a todos los actores que aparecen en la película "Titanic".
\C 'REPARTO PELÍCULA TITANIC';
SELECT nombre_actor AS actor FROM peliculas 
INNER JOIN reparto ON peliculas.id = reparto.id_pelicula
WHERE pelicula = 'Titanic';

--  Consultar en cuántas películas del top 100 participa Harrison Ford.

\C 'PARTICIPACIONES EN PELÍCULA DE HARRISON FORD';
SELECT nombre_actor AS actor, COUNT(id_pelicula) AS participaciones FROM reparto 
WHERE nombre_actor = 'Harrison Ford'
GROUP BY actor;


-- Indicar las películas estrenadas entre los años 1990 y 1999 ordenadas por título de manera ascendente.
\C 'PELÍCULAS ESTRENADAS ENTRE LOS AÑOS 1990 y 1999';
SELECT pelicula, "año estreno" FROM peliculas
WHERE "año estreno" BETWEEN 1990 AND 1999
ORDER BY pelicula ASC;


-- Hacer una consulta SQL que muestre los títulos con su longitud, la longitud debe ser nombrado para la consulta como “longitud_titulo"
\C 'TÍTULOS CON SU LONGITUD';
SELECT pelicula, CHAR_LENGTH(pelicula) AS longitud_titulo FROM peliculas;

-- Consultar cual es la longitud más grande entre todos los títulos de las películas.
\C 'PELÍCULA CON EL TÍTULO MÁS LARGO';
SELECT pelicula, CHAR_LENGTH(pelicula) AS longitud_titulo 
FROM peliculas
GROUP BY pelicula
ORDER BY longitud_titulo DESC LIMIT 1;