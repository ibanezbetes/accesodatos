-- ----------------------------------------------------------------------
-- 1. TABLAS DEL SISTEMA (Parte Obligatoria)
-- ----------------------------------------------------------------------
DROP TABLE ejemplar CASCADE CONSTRAINTS;
DROP TABLE edicion CASCADE CONSTRAINTS;
DROP TABLE autor_obra CASCADE CONSTRAINTS;
DROP TABLE autor CASCADE CONSTRAINTS;
DROP TABLE obra CASCADE CONSTRAINTS;

CREATE TABLE obra (
    id CHAR(5),
    titulo VARCHAR2(100),
    anyo INTEGER,
    CONSTRAINT PK_obra PRIMARY KEY (id),
    CONSTRAINT NN_titulo CHECK (titulo IS NOT NULL)
);

CREATE TABLE autor (
    id CHAR(4),
    nombre VARCHAR2(30),
    apellidos VARCHAR2(60),
    nacimiento DATE,
    CONSTRAINT PK_autor PRIMARY KEY (id),
    CONSTRAINT NN_nombre CHECK (nombre IS NOT NULL),
    CONSTRAINT NN_apellidos CHECK (apellidos IS NOT NULL)
);

CREATE TABLE autor_obra (
    id_autor CHAR(4),
    id_obra CHAR(5),
    CONSTRAINT PK_autor_obra PRIMARY KEY (id_autor, id_obra),
    CONSTRAINT FK_autor_obra_id_autor FOREIGN KEY (id_autor) REFERENCES autor (id),
    CONSTRAINT FK_autor_obra_id_obra FOREIGN KEY (id_obra) REFERENCES obra (id)
);

CREATE TABLE edicion (
    id CHAR(6),
    id_obra CHAR(5),
    isbn VARCHAR2(20),
    anyo INTEGER,
    CONSTRAINT PK_edicion PRIMARY KEY (id),
    CONSTRAINT NN_id_obra CHECK (id_obra IS NOT NULL),
    CONSTRAINT NN_isbn CHECK (isbn IS NOT NULL),
    CONSTRAINT FK_edicion FOREIGN KEY (id_obra) REFERENCES obra(id)
);

CREATE TABLE ejemplar (
    id_edicion CHAR(6),
    numero INTEGER,
    alta DATE,
    baja DATE,
    CONSTRAINT PK_ejemplar PRIMARY KEY (id_edicion, numero),
    CONSTRAINT FK_ejemplar FOREIGN KEY (id_edicion) REFERENCES edicion (id),
    CONSTRAINT NN_alta CHECK (alta IS NOT NULL)
);

-- ----------------------------------------------------------------------
-- 2. TABLAS DE AUDITORÍA (Ocultas para el usuario)
-- ----------------------------------------------------------------------
DROP TABLE audit_borrado_obra CASCADE CONSTRAINTS;

CREATE TABLE audit_borrado_obra (
    id_borrado CHAR(5),
    titulo_borrado VARCHAR2(100),
    anyo_borrado INTEGER,
    fecha_auditoria DATE
);

-- (Nota: Para la parte opcional, haríamos más tablas de auditoría similares)
