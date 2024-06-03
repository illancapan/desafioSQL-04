-- Active: 1716506184190@@127.0.0.1@5432@desafio_igor_llancapan_123@public
-- CREATE DATABASE IF NOT EXISTS desafio_igor_llancapan_123;


-- MODELO 1

CREATE TABLE pelicula (
    id 		INT             PRIMARY KEY,
    titulo 	VARCHAR(255)    NOT NULL,
    año 	INT             NOT NULL
);

CREATE TABLE tag (
    id 		INT             PRIMARY KEY,
    nombre 	VARCHAR(255)    NOT NULL
);

-- 1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
-- primarias, foráneas y tipos de datos.

CREATE TABLE peliculaTag (
    pelicula_id             INT,
    tag_id 		            INT,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) 	REFERENCES pelicula(id),
    FOREIGN KEY (tag_id) 		REFERENCES tag(id)
);

-- 2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
-- segunda película debe tener 2 tags asociados.
INSERT INTO pelicula (id, titulo, año) VALUES 
(1, 'Inception', 2010),
(2, 'The Matrix', 1999),
(3, 'The Godfather', 1972),
(4, 'Pulp Fiction', 1994),
(5, 'The Shawshank Redemption', 1994);

INSERT INTO tag (id, nombre) VALUES 
(1, 'Sci-Fi'),
(2, 'Thriller'),
(3, 'Drama'),
(4, 'Crime'),
(5, 'Action');

INSERT INTO peliculaTag (pelicula_id, tag_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 5),
(3, 3),
(3, 4),
(4, 4),
(4, 5),
(5, 3);

-- PRUEBAS TABLAS
-- SELECT * FROM pelicula;
-- SELECT * FROM tag;
-- SELECT * FROM peliculaTag;


-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0.

SELECT p.titulo,
       COUNT(pt.tag_id) AS cantidad_tags,
       (SELECT STRING_AGG(t.nombre, ', ')
        FROM peliculaTag pt2
        JOIN tag t ON pt2.tag_id = t.id
        WHERE pt2.pelicula_id = p.id) AS tags
FROM pelicula p
LEFT JOIN peliculaTag pt ON p.id = pt.pelicula_id
GROUP BY p.id, p.titulo;


-- MODELO 2


-- 4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
-- foráneas y tipos de datos.
CREATE TABLE usuarios (
    id                  INT             PRIMARY KEY,
    nombre              VARCHAR(255)    NOT NULL,
    edad                INT             NOT NULL
);

CREATE TABLE preguntas (
    id                  INT             PRIMARY KEY,
    pregunta            VARCHAR(255)    NOT NULL,
    respuesta_correcta  VARCHAR         NOT NULL
);

CREATE TABLE respuestas (
    id                  INT             PRIMARY KEY,
    respuesta           VARCHAR(255)    NOT NULL,
    usuario_id          INT,
    pregunta_id         INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);
-- Agrega 5 usuarios y 5 preguntas.
INSERT INTO usuarios (id, nombre, edad) VALUES 
(1, 'Alicia', 30),
(2, 'Roberto', 25),
(3, 'Carlos', 35),
(4, 'Diana', 28),
(5, 'Elena', 32);

-- Insertar preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES 
(1, '¿Cuál es la capital de Francia?', 'París'),
(2, '¿Cuánto es 2 + 2?', '4'),
(3, '¿Cuál es el planeta más grande de nuestro sistema solar?', 'Júpiter'),
(4, '¿Qué elemento tiene el símbolo químico O?', 'Oxígeno'),
(5, '¿En qué año llegó el hombre a la Luna?', '1969');

-- Respuestas correctas a la primera pregunta por dos usuarios
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(1, 'París', 1, 1),
(2, 'París', 2, 1);

-- Respuesta correcta a la segunda pregunta por un usuario
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(3, '4', 3, 2);

-- Respuestas incorrectas a las otras tres preguntas
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(4, 'Saturno', 4, 3),
(5, 'Helio', 5, 4),
(6, '1970', 1, 5);

-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
-- pregunta).

SELECT u.nombre AS nombre_usuario, r.usuario_id AS id_usuario, COUNT(*) AS respuestas_correctas_totales
FROM respuestas r
JOIN preguntas p ON r.pregunta_id = p.id
JOIN usuarios u ON r.usuario_id = u.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY u.nombre, r.usuario_id;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
-- correctamente.

SELECT u.nombre AS nombre_usuario, r.pregunta_id, COUNT(*) AS usuarios_correctos_por_pregunta
FROM respuestas r
JOIN preguntas p ON r.pregunta_id = p.id
JOIN usuarios u ON r.usuario_id = u.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY u.nombre, r.pregunta_id;

-- 8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
-- implementación borrando el primer usuario.
ALTER TABLE respuestas
ADD CONSTRAINT fk_usuario_respuesta
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON DELETE CASCADE;

SELECT * FROM respuestas;
SELECT * FROM usuarios;
SELECT * FROM preguntas;

-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
-- datos.

ALTER TABLE usuarios
ADD CONSTRAINT edad_minima
CHECK (edad >= 18);

-- 10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la
-- restricción de ser único.

ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;