SET SERVEROUTPUT ON;

DECLARE
  v_id_obra VARCHAR2(5);
  v_id_autor VARCHAR2(4);
  v_id_edicion VARCHAR2(6);
  v_id_obra_temp VARCHAR2(5); -- Variable nueva para la prueba de borrado
  v_num_ejemplar1 INTEGER;
  v_num_ejemplar2 INTEGER;
  v_resultado INTEGER;
  
BEGIN
  DBMS_OUTPUT.PUT_LINE('==============================================');
  DBMS_OUTPUT.PUT_LINE('      INICIANDO BATERIA DE PRUEBAS BIBLIOTK   ');
  DBMS_OUTPUT.PUT_LINE('==============================================');

  INSERT INTO socio (cod_socio, nombre, apellidos) VALUES (999, 'Estudiante', 'Pruebas');
  DBMS_OUTPUT.PUT_LINE('-> Socio de prueba insertado correctamente.');

  v_id_autor := BiblioTK.alta_autor('J.R.R.', 'Tolkien', TO_DATE('03/01/1892', 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('-> Autor registrado con ID: ' || v_id_autor);

  v_id_obra := BiblioTK.alta_obra('El Senor de los Anillos', 1954);
  DBMS_OUTPUT.PUT_LINE('-> Obra registrada con ID: ' || v_id_obra);

  v_resultado := BiblioTK.vincular(v_id_autor, v_id_obra);
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('-> Autor y Obra vinculados (OK).');
  END IF;

  v_id_edicion := BiblioTK.alta_edicion(v_id_obra, '978-84-450-0066', 2001);
  DBMS_OUTPUT.PUT_LINE('-> Edicion registrada con ID: ' || v_id_edicion);

  v_num_ejemplar1 := BiblioTK.alta_ejemplar(v_id_edicion);
  DBMS_OUTPUT.PUT_LINE('-> Ejemplar 1 registrado con Num: ' || v_num_ejemplar1);

  v_num_ejemplar2 := BiblioTK.alta_ejemplar(v_id_edicion);
  DBMS_OUTPUT.PUT_LINE('-> Ejemplar 2 registrado con Num: ' || v_num_ejemplar2);

  v_resultado := BiblioTK.apertura_prestamo(999, v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Prestamo abierto para el ejemplar 1 (OK).');
  END IF;

  v_resultado := BiblioTK.cierre_prestamo(999, v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Prestamo cerrado para el ejemplar 1 (OK).');
  END IF;

  v_resultado := BiblioTK.baja_ejemplar(v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Ejemplar 1 dado de baja por deterioro (OK).');
  END IF;

  v_resultado := BiblioTK.borrado_ejemplar(v_id_edicion, v_num_ejemplar1);
  IF v_resultado = -1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Intento borrado Ejemplar 1 bloqueado por reglas negocio (FALLO ESPERADO Y CORRECTO).');
  END IF;

  v_resultado := BiblioTK.borrado_ejemplar(v_id_edicion, v_num_ejemplar2);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Borrado del Ejemplar 2 (OK).');
  END IF;

  -- 9. Probar el Trigger de Auditoria de Borrado de Obra
  DBMS_OUTPUT.PUT_LINE('-> Creando obra temporal para probar la auditoria de borrado...');
  v_id_obra_temp := BiblioTK.alta_obra('Obra de Prueba', 2026);
  
  v_resultado := BiblioTK.borrado_obra(v_id_obra_temp);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Obra temporal borrada. El TRIGGER de auditoria debe haber saltado (OK).');
  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('==============================================');
  DBMS_OUTPUT.PUT_LINE(' BATERIA FINALIZADA Y CAMBIOS CONFIRMADOS ');
  DBMS_OUTPUT.PUT_LINE('==============================================');

EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('ERROR FATAL EN BATERIA DE PRUEBAS: ' || SQLERRM);
     ROLLBACK;
END;
/