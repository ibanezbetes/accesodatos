-- ----------------------------------------------------------------------
-- 1. TABLAS DEL SISTEMA (Parte Obligatoria)
-- ----------------------------------------------------------------------
-- DROP TABLE elimina las tablas previas para poder volver a ejecutar el script sin errores de "la tabla ya existe".
-- CASCADE CONSTRAINTS se usa para borrar la tabla aunque tenga claves foráneas que dependan de ella en otras tablas.
DROP TABLE ejemplar CASCADE CONSTRAINTS;
DROP TABLE edicion CASCADE CONSTRAINTS;
DROP TABLE autor_obra CASCADE CONSTRAINTS;
DROP TABLE autor CASCADE CONSTRAINTS;
DROP TABLE obra CASCADE CONSTRAINTS;

-- Tabla principal de obras.
CREATE TABLE obra (
    id CHAR(5), -- Usamos CHAR(5) porque el ID tiene una longitud fija de 5 caracteres.
    titulo VARCHAR2(100), -- VARCHAR2 porque el título puede tener longitud variable.
    anyo INTEGER,
    -- Definimos la clave primaria para evitar obras duplicadas y poder enlazarlas posteriormente.
    CONSTRAINT PK_obra PRIMARY KEY (id),
    -- Constraint CHECK para asegurar que el título nunca se deje vacío (otra opción es poner NOT NULL arriba).
    CONSTRAINT NN_titulo CHECK (titulo IS NOT NULL)
);

-- Tabla de autores.
CREATE TABLE autor (
    id CHAR(4),
    nombre VARCHAR2(30),
    apellidos VARCHAR2(60),
    nacimiento DATE,
    CONSTRAINT PK_autor PRIMARY KEY (id),
    CONSTRAINT NN_nombre CHECK (nombre IS NOT NULL),
    CONSTRAINT NN_apellidos CHECK (apellidos IS NOT NULL)
);

-- Tabla intermedia que relaciona qué autores han escrito qué obras (relación de muchos a muchos).
CREATE TABLE autor_obra (
    id_autor CHAR(4),
    id_obra CHAR(5),
    -- La clave primaria es compuesta: un mismo autor no puede tener asignada la misma obra dos veces.
    CONSTRAINT PK_autor_obra PRIMARY KEY (id_autor, id_obra),
    -- Claves foráneas (FOREIGN KEY) que apuntan a las tablas autor y obra para asegurar integridad referencial.
    CONSTRAINT FK_autor_obra_id_autor FOREIGN KEY (id_autor) REFERENCES autor (id),
    CONSTRAINT FK_autor_obra_id_obra FOREIGN KEY (id_obra) REFERENCES obra (id)
);

-- Tabla de ediciones de cada obra.
CREATE TABLE edicion (
    id CHAR(6),
    id_obra CHAR(5),
    isbn VARCHAR2(20),
    anyo INTEGER,
    CONSTRAINT PK_edicion PRIMARY KEY (id),
    CONSTRAINT NN_id_obra CHECK (id_obra IS NOT NULL),
    CONSTRAINT NN_isbn CHECK (isbn IS NOT NULL),
    -- Clave foránea referenciando a qué obra pertenece esta edición concreta.
    CONSTRAINT FK_edicion FOREIGN KEY (id_obra) REFERENCES obra(id)
);

-- Tabla de ejemplares físicos disponibles en la biblioteca para una edición.
CREATE TABLE ejemplar (
    id_edicion CHAR(6),
    numero INTEGER,
    alta DATE,
    baja DATE,
    -- Clave primaria compuesta, ya que el 'numero' de ejemplar se reinicia por cada edición diferente.
    CONSTRAINT PK_ejemplar PRIMARY KEY (id_edicion, numero),
    CONSTRAINT FK_ejemplar FOREIGN KEY (id_edicion) REFERENCES edicion (id),
    CONSTRAINT NN_alta CHECK (alta IS NOT NULL)
);

-- ----------------------------------------------------------------------
-- 2. TABLAS DE AUDITORÍA (Ocultas para el usuario)
-- ----------------------------------------------------------------------
DROP TABLE audit_borrado_obra CASCADE CONSTRAINTS;

-- Tabla de auditoría. Aquí no solemos poner Primary keys estrictamente o foreign keys,
-- porque solo sirve para guardar un registro histórico de lo que ocurre (quién/qué se ha borrado).
CREATE TABLE audit_borrado_obra (
    id_borrado CHAR(5),
    titulo_borrado VARCHAR2(100),
    anyo_borrado INTEGER,
    fecha_auditoria DATE
);
