CREATE OR REPLACE PACKAGE BiblioTK AS

  -- Operativa Requerida
  FUNCTION alta_obra (p_titulo VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION borrado_obra (p_id VARCHAR2) RETURN INTEGER;
  
  FUNCTION alta_autor (p_nombre VARCHAR2, p_apellidos VARCHAR2, p_nacimiento DATE DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION borrado_autor (p_id VARCHAR2) RETURN INTEGER;
  
  FUNCTION vincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER;
  FUNCTION desvincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER;
  
  FUNCTION alta_edicion (p_id_obra VARCHAR2, p_isbn VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION borrado_edicion (p_id VARCHAR2) RETURN INTEGER;
  
  FUNCTION alta_ejemplar (p_id_edicion VARCHAR2) RETURN INTEGER;
  FUNCTION borrado_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;
  FUNCTION baja_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;

  -- Operativa Opcional
  FUNCTION apertura_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;
  FUNCTION cierre_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER;

END BiblioTK;
/
