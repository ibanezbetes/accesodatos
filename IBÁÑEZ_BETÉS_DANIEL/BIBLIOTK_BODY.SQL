CREATE OR REPLACE PACKAGE BODY BiblioTK AS

  -- 08. ALTA OBRA
  FUNCTION alta_obra (p_titulo VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2 IS
    v_id obra.id%TYPE;
  BEGIN
    v_id := dbms_random.string('X', 5);
    INSERT INTO obra (id, titulo, anyo) VALUES (v_id, p_titulo, p_anyo);
    RETURN v_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: ID de obra generado duplicado. Reintente.');
      RETURN '-1';
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en alta_obra.');
      RETURN '-1';
  END alta_obra;

  -- 09. BORRADO OBRA
  FUNCTION borrado_obra (p_id VARCHAR2) RETURN INTEGER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM obra WHERE id = p_id;
    IF v_count = 0 THEN 
        RETURN 0; -- No existe
    END IF;
    
    DELETE FROM obra WHERE id = p_id;
    RETURN 1; -- Borrado OK
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error borrando obra.');
      RETURN -1;
  END borrado_obra;

  -- 10. ALTA AUTOR
  FUNCTION alta_autor (p_nombre VARCHAR2, p_apellidos VARCHAR2, p_nacimiento DATE DEFAULT NULL) RETURN VARCHAR2 IS
    v_id autor.id%TYPE;
  BEGIN
    v_id := dbms_random.string('X', 4);
    INSERT INTO autor (id, nombre, apellidos, nacimiento) VALUES (v_id, p_nombre, p_apellidos, p_nacimiento);
    RETURN v_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: ID de autor generado duplicado.');
      RETURN '-1';
    WHEN OTHERS THEN
      RETURN '-1';
  END alta_autor;

  -- 11. BORRADO AUTOR
  FUNCTION borrado_autor (p_id VARCHAR2) RETURN INTEGER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM autor WHERE id = p_id;
    IF v_count = 0 THEN RETURN 0; END IF;
    
    DELETE FROM autor WHERE id = p_id;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END borrado_autor;

  -- 12. VINCULAR
  FUNCTION vincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER IS
  BEGIN
    INSERT INTO autor_obra (id_autor, id_obra) VALUES (p_id_autor, p_id_obra);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END vincular;

  -- 13. DESVINCULAR
  FUNCTION desvincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM autor_obra WHERE id_autor = p_id_autor AND id_obra = p_id_obra;
    IF v_count = 0 THEN RETURN 0; END IF;
    
    DELETE FROM autor_obra WHERE id_autor = p_id_autor AND id_obra = p_id_obra;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END desvincular;

  -- 14. ALTA EDICION
  FUNCTION alta_edicion (p_id_obra VARCHAR2, p_isbn VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2 IS
    v_id edicion.id%TYPE;
  BEGIN
    v_id := dbms_random.string('X', 6);
    INSERT INTO edicion (id, id_obra, isbn, anyo) VALUES (v_id, p_id_obra, p_isbn, p_anyo);
    RETURN v_id;
  EXCEPTION
    WHEN OTHERS THEN RETURN '-1';
  END alta_edicion;

  -- 15. BORRADO EDICION
  FUNCTION borrado_edicion (p_id VARCHAR2) RETURN INTEGER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM edicion WHERE id = p_id;
    IF v_count = 0 THEN RETURN 0; END IF;
    DELETE FROM edicion WHERE id = p_id;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END borrado_edicion;

  -- 16, 17, 18. ALTA EJEMPLAR (Calcula número consecutivo automático)
  FUNCTION alta_ejemplar (p_id_edicion VARCHAR2) RETURN INTEGER IS
    v_num INTEGER;
    v_count_edicion NUMBER;
  BEGIN
    -- Comprobamos si la edición existe
    SELECT COUNT(*) INTO v_count_edicion FROM edicion WHERE id = p_id_edicion;
    IF v_count_edicion = 0 THEN RETURN -1; END IF;
    
    -- Calculamos el número de ejemplar (Si no hay, empieza en 1)
    SELECT NVL(MAX(numero), 0) + 1 INTO v_num FROM ejemplar WHERE id_edicion = p_id_edicion;
    
    INSERT INTO ejemplar (id_edicion, numero, alta, baja) VALUES (p_id_edicion, v_num, SYSDATE, NULL);
    RETURN v_num;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END alta_ejemplar;

  -- 20, 21, 22. BORRADO EJEMPLAR (Solo el último, sin baja, alta <= 30 días)
  FUNCTION borrado_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
    v_max_num INTEGER;
    v_alta DATE;
    v_baja DATE;
  BEGIN
    -- Intentamos recuperar los datos. Si no hay datos, saltará a NO_DATA_FOUND
    SELECT alta, baja INTO v_alta, v_baja FROM ejemplar 
    WHERE id_edicion = p_id_edicion AND numero = p_numero;
    
    -- Comprobamos si es el último de su serie
    SELECT MAX(numero) INTO v_max_num FROM ejemplar WHERE id_edicion = p_id_edicion;
    IF p_numero <> v_max_num THEN RETURN -1; END IF;
    
    -- Comprobamos si tiene fecha de baja o han pasado más de 30 días
    IF v_baja IS NOT NULL THEN RETURN -1; END IF;
    IF (SYSDATE - v_alta) > 30 THEN RETURN -1; END IF;
    
    DELETE FROM ejemplar WHERE id_edicion = p_id_edicion AND numero = p_numero;
    RETURN 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RETURN 0; -- No existe
    WHEN OTHERS THEN 
      RETURN -1;
  END borrado_ejemplar;

  -- 23, 24, 25, 26. BAJA EJEMPLAR
  FUNCTION baja_ejemplar(p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
    v_baja DATE;
  BEGIN
    SELECT baja INTO v_baja FROM ejemplar WHERE id_edicion = p_id_edicion AND numero = p_numero;
    
    IF v_baja IS NOT NULL THEN 
      RETURN -1; -- Ya estaba dado de baja
    END IF;
    
    UPDATE ejemplar SET baja = SYSDATE WHERE id_edicion = p_id_edicion AND numero = p_numero;
    RETURN 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RETURN 0;
    WHEN OTHERS THEN 
      RETURN -1;
  END baja_ejemplar;

  -- OPCIONAL 29: APERTURA PRESTAMO
  FUNCTION apertura_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
  BEGIN
    INSERT INTO prestamo (cod_socio, id_edicion, numero, fecha_prestamo, fecha_devolucion) 
    VALUES (p_socio, p_id_edicion, p_numero, SYSDATE, NULL);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END apertura_prestamo;

  -- OPCIONAL 30: CIERRE PRESTAMO
  FUNCTION cierre_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
  BEGIN
    UPDATE prestamo SET fecha_devolucion = SYSDATE 
    WHERE cod_socio = p_socio AND id_edicion = p_id_edicion AND numero = p_numero AND fecha_devolucion IS NULL;
    
    IF SQL%ROWCOUNT = 0 THEN 
        RETURN 0; -- No encontró el préstamo abierto
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END cierre_prestamo;

END BiblioTK;
/
