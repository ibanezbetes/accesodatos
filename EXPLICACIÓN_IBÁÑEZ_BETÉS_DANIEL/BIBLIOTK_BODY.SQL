-- Aquí programamos la lógica interna (el código funcional) de todo lo declarado en la cabecera del paquete anterior.
CREATE OR REPLACE PACKAGE BODY BiblioTK AS

  -- -------------------------------------------------------------
  -- 08. ALTA OBRA
  -- -------------------------------------------------------------
  FUNCTION alta_obra (p_titulo VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2 IS
    -- Declaramos una variable que tendrá exactamente el mismo tipo que la columna 'id' de la tabla 'obra' (%TYPE)
    v_id obra.id%TYPE;
  BEGIN
    -- Generar cadena aleatoria de 5 letras para usarla de primary key
    v_id := dbms_random.string('X', 5);
    INSERT INTO obra (id, titulo, anyo) VALUES (v_id, p_titulo, p_anyo);
    RETURN v_id; -- Devuelve la que acabamos de generar
  EXCEPTION
    -- DUP_VAL_ON_INDEX salta automáticamente si intentamos hacer INSERT de un 'id' que ya estaba en la tabla, rompiendo la PK.
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: ID de obra generado duplicado. Reintente.');
      RETURN '-1';
    -- Cualquier otro error general. Devolvemos -1 simulando el patrón de enseñanza en clase.
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en alta_obra.');
      RETURN '-1';
  END alta_obra;

  -- -------------------------------------------------------------
  -- 09. BORRADO OBRA
  -- -------------------------------------------------------------
  FUNCTION borrado_obra (p_id VARCHAR2) RETURN INTEGER IS
    v_count NUMBER;
  BEGIN
    -- Usamos COUNT para saber si existe. Lo metemos dentro de v_count usando INTO
    SELECT COUNT(*) INTO v_count FROM obra WHERE id = p_id;
    
    -- Patrón: Si es 0, significa que esa obra no existe. 
    IF v_count = 0 THEN 
        RETURN 0; 
    END IF;
    
    -- Si llegó aquí, es que sí existe, la borramos (y saltará el trigger automáticamente)
    DELETE FROM obra WHERE id = p_id;
    RETURN 1; -- Borrado con éxito
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error borrando obra.');
      RETURN -1;
  END borrado_obra;

  -- -------------------------------------------------------------
  -- 10. ALTA AUTOR (muy similar a obra)
  -- -------------------------------------------------------------
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

  -- -------------------------------------------------------------
  -- 11. BORRADO AUTOR
  -- -------------------------------------------------------------
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

  -- -------------------------------------------------------------
  -- 12. VINCULAR
  -- -------------------------------------------------------------
  -- Relaciona el autor con su obra insertando en la tabla intermedia.
  FUNCTION vincular (p_id_autor VARCHAR2, p_id_obra VARCHAR2) RETURN INTEGER IS
  BEGIN
    INSERT INTO autor_obra (id_autor, id_obra) VALUES (p_id_autor, p_id_obra);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1; -- Si falla (ej: intento de duplicado, autor falso o la obra no existe)
  END vincular;

  -- -------------------------------------------------------------
  -- 13. DESVINCULAR
  -- -------------------------------------------------------------
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

  -- -------------------------------------------------------------
  -- 14. ALTA EDICION
  -- -------------------------------------------------------------
  FUNCTION alta_edicion (p_id_obra VARCHAR2, p_isbn VARCHAR2, p_anyo INTEGER DEFAULT NULL) RETURN VARCHAR2 IS
    v_id edicion.id%TYPE;
  BEGIN
    v_id := dbms_random.string('X', 6);
    INSERT INTO edicion (id, id_obra, isbn, anyo) VALUES (v_id, p_id_obra, p_isbn, p_anyo);
    RETURN v_id;
  EXCEPTION
    WHEN OTHERS THEN RETURN '-1';
  END alta_edicion;

  -- -------------------------------------------------------------
  -- 15. BORRADO EDICION
  -- -------------------------------------------------------------
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

  -- -------------------------------------------------------------
  -- 16, 17, 18. ALTA EJEMPLAR (Autoincremental por edición)
  -- -------------------------------------------------------------
  FUNCTION alta_ejemplar (p_id_edicion VARCHAR2) RETURN INTEGER IS
    v_num INTEGER;
    v_count_edicion NUMBER;
  BEGIN
    -- Comprobamos si la edición matriz existe antes de insertar su ejemplar (control de nulos manual)
    SELECT COUNT(*) INTO v_count_edicion FROM edicion WHERE id = p_id_edicion;
    IF v_count_edicion = 0 THEN RETURN -1; END IF;
    
    -- Calculamos el numero que le toca al libro (Si fuera el primer ejemplar MAX devuelve null,
    -- por lo que usamos NVL para transformarlo en 0 y sumarle 1, y seria el ejemplar 1)
    SELECT NVL(MAX(numero), 0) + 1 INTO v_num FROM ejemplar WHERE id_edicion = p_id_edicion;
    
    -- Insertamos fecha actual SYSDATE en alta y fecha NULL de baja.
    INSERT INTO ejemplar (id_edicion, numero, alta, baja) VALUES (p_id_edicion, v_num, SYSDATE, NULL);
    RETURN v_num; -- Devolvemos el número de libro asignado.
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END alta_ejemplar;

  -- -------------------------------------------------------------
  -- 20, 21, 22. BORRADO COMPLETADO (Con lógica de negocio)
  -- -------------------------------------------------------------
  FUNCTION borrado_ejemplar (p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
    v_max_num INTEGER;
    v_alta DATE;
    v_baja DATE;
  BEGIN
    -- Consultamos los datos. Cuidado: Si no hay fila en la tabla, esto lanza un error NO_DATA_FOUND y detiene el BEGIN.
    SELECT alta, baja INTO v_alta, v_baja FROM ejemplar 
    WHERE id_edicion = p_id_edicion AND numero = p_numero;
    
    -- El enunciado solo permite borrarlo si es "el último de su clase". Vemos cuál es el MAX.
    SELECT MAX(numero) INTO v_max_num FROM ejemplar WHERE id_edicion = p_id_edicion;
    IF p_numero <> v_max_num THEN RETURN -1; END IF;
    
    -- Regla de negocio: Si ya fue dado de baja, no podemos borrarlo.
    IF v_baja IS NOT NULL THEN RETURN -1; END IF;
    -- Regla de negocio: SYSDATE (hoy) menos la fecha de Alta extrae el "número de días". Comparamos con 30.
    IF (SYSDATE - v_alta) > 30 THEN RETURN -1; END IF;
    
    -- Si superó todas las reglas, se borra el ejemplar.
    DELETE FROM ejemplar WHERE id_edicion = p_id_edicion AND numero = p_numero;
    RETURN 1;
  EXCEPTION
    -- Capturamos especificamente el error de que el primer SELECT falló porque no había libros con esos IDs
    WHEN NO_DATA_FOUND THEN 
      RETURN 0; 
    WHEN OTHERS THEN 
      RETURN -1;
  END borrado_ejemplar;

  -- -------------------------------------------------------------
  -- 23, 24, 25, 26. BAJA LÓGICA DE EJEMPLAR
  -- -------------------------------------------------------------
  FUNCTION baja_ejemplar(p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
    v_baja DATE;
  BEGIN
    SELECT baja INTO v_baja FROM ejemplar WHERE id_edicion = p_id_edicion AND numero = p_numero;
    
    IF v_baja IS NOT NULL THEN 
      RETURN -1; -- Ya estaba dado de baja previamente.
    END IF;
    
    -- Actualizamos poniendo la fecha del sistema en el hueco a nulo.
    UPDATE ejemplar SET baja = SYSDATE WHERE id_edicion = p_id_edicion AND numero = p_numero;
    RETURN 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RETURN 0;
    WHEN OTHERS THEN 
      RETURN -1;
  END baja_ejemplar;

  -- -------------------------------------------------------------
  -- OPCIONAL 29: APERTURA PRESTAMO
  -- -------------------------------------------------------------
  FUNCTION apertura_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
  BEGIN
    INSERT INTO prestamo (cod_socio, id_edicion, numero, fecha_prestamo, fecha_devolucion) 
    VALUES (p_socio, p_id_edicion, p_numero, SYSDATE, NULL);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END apertura_prestamo;

  -- -------------------------------------------------------------
  -- OPCIONAL 30: CIERRE PRESTAMO
  -- -------------------------------------------------------------
  FUNCTION cierre_prestamo (p_socio NUMBER, p_id_edicion VARCHAR2, p_numero INTEGER) RETURN INTEGER IS
  BEGIN
    -- Para evitar errores de NO_DATA_FOUND al buscar manualmente, usamos un UPDATE directo inteligente
    UPDATE prestamo SET fecha_devolucion = SYSDATE 
    -- Solo cierra aquel donde la fecha está todavía vacía (NULL)
    WHERE cod_socio = p_socio AND id_edicion = p_id_edicion AND numero = p_numero AND fecha_devolucion IS NULL;
    
    -- SQL%ROWCOUNT es una variable del sistema que nos dice en esta sesion: "¿Cuántas filas acaba de pintar mi UPDATE?"
    IF SQL%ROWCOUNT = 0 THEN 
        RETURN 0; -- Si es 0 es que no ha actualizado nada, no había un préstamo abierto disponible.
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN RETURN -1;
  END cierre_prestamo;

END BiblioTK;
/
