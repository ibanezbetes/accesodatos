-- TABLAS PARTE OPCIONAL
DROP TABLE prestamo CASCADE CONSTRAINTS;
DROP TABLE socio CASCADE CONSTRAINTS;

CREATE TABLE socio (
    cod_socio NUMBER(4),
    nombre VARCHAR2(30) NOT NULL,
    apellidos VARCHAR2(60) NOT NULL,
    CONSTRAINT PK_socio PRIMARY KEY (cod_socio)
);

CREATE TABLE prestamo (
    cod_socio NUMBER(4),
    id_edicion CHAR(6),
    numero INTEGER,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    CONSTRAINT PK_prestamo PRIMARY KEY (cod_socio, id_edicion, numero, fecha_prestamo),
    CONSTRAINT FK_prestamo_socio FOREIGN KEY (cod_socio) REFERENCES socio(cod_socio),
    CONSTRAINT FK_prestamo_ejemplar FOREIGN KEY (id_edicion, numero) REFERENCES ejemplar(id_edicion, numero)
);
