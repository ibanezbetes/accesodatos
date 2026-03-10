-- TABLAS PARTE OPCIONAL
-- Eliminamos primero las tablas hijas (prestamo) y luego las padres (socio) para evitar conflictos de claves foráneas.
DROP TABLE prestamo CASCADE CONSTRAINTS;
DROP TABLE socio CASCADE CONSTRAINTS;

-- Tabla para almacenar a los socios de la biblioteca.
CREATE TABLE socio (
    cod_socio NUMBER(4), -- Usamos NUMBER para el código del socio.
    nombre VARCHAR2(30) NOT NULL, -- NOT NULL en línea como alternativa a la constraint explícita (más rápido).
    apellidos VARCHAR2(60) NOT NULL,
    CONSTRAINT PK_socio PRIMARY KEY (cod_socio)
);

-- Tabla para registrar qué ejemplar se ha prestado a qué socio.
CREATE TABLE prestamo (
    cod_socio NUMBER(4),
    id_edicion CHAR(6),
    numero INTEGER,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE, -- Si es nulo, significa que aún no lo ha devuelto.
    -- Un mismo socio puede sacar prestado el mismo ejemplar en fechas distintas, de ahí la clave principal de 4 partes.
    CONSTRAINT PK_prestamo PRIMARY KEY (cod_socio, id_edicion, numero, fecha_prestamo),
    -- Referencia al socio.
    CONSTRAINT FK_prestamo_socio FOREIGN KEY (cod_socio) REFERENCES socio(cod_socio),
    -- Referencia compuesta al ejemplar concreto (necesita las 2 columnas que forman su Primary Key).
    CONSTRAINT FK_prestamo_ejemplar FOREIGN KEY (id_edicion, numero) REFERENCES ejemplar(id_edicion, numero)
);
