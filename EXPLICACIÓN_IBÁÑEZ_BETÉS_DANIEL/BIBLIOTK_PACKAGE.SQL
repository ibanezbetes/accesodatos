-- En PL/SQL, los paquetes se dividen en Cabecera (PACKAGE) y Cuerpo (PACKAGE BODY).
-- Esta es la Cabecera. Sirve como "índice" o declaración o interfaz.
-- Le decimos a Oracle qué funciones o procedimientos van a existir públicamente, 
-- qué parámetros van a recibir (y de qué tipo), y qué van a devolver, sin incluir aún la lógica.
CREATE OR REPLACE PACKAGE BiblioTK AS

  -- Operativa Requerida
  -- Recibe título y un año opcional (DEFAULT NULL indica que si no enviamos año, asumirá nulo). Devuelve el ID.
  FUNCTION alta_obra (p_titulo VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2;
  -- Recibe el ID a borrar, y devolverá un número entero: -1, 0, o 1 según pide el profesor.
  FUNCTION borrado_obra (p_id VARCHAR2) RETURN INTEGER;
  
  -- Siguientes funciones siguen el mismo patrón.
  FUNCTION alta_autor (p_nombre VARCHAR2, p_apellidos VARCHAR2, p_nacimiento DATE DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION borrado_autor (p_id VARCHAR2) RETURN INTEGER;
  
  -- Las vinculaciones devuelven INTEGER (1 o 0, exito o fracaso).
  FUNCTION vincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER;
  FUNCTION desvincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER;
  
  FUNCTION alta_edicion (p_id_obra VARCHAR2, p_isbn VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION borrado_edicion (p_id VARCHAR2) RETURN INTEGER;
  
  -- El ejemplar requiere doble clave (id y numero).
  FUNCTION alta_ejemplar (p_id_edicion VARCHAR2) RETURN INTEGER;
  FUNCTION borrado_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;
  FUNCTION baja_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;

  -- Operativa Opcional (préstamos y devoluciones)
  FUNCTION apertura_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;
  FUNCTION cierre_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;

END BiblioTK;
/
