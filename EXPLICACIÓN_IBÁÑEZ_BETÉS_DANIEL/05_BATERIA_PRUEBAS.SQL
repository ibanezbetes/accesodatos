-- Es imprescindible activar la salida por pantalla como dice el profesor
SET SERVEROUTPUT ON;

DECLARE
  -- Variables para almacenar los IDs aleatorios que devuelven nuestras funciones
  v_id_obra VARCHAR2(5);
  v_id_autor VARCHAR2(4);
  v_id_edicion VARCHAR2(6);
  v_num_ejemplar1 INTEGER;
  v_num_ejemplar2 INTEGER;
  v_resultado INTEGER;
  
BEGIN
  DBMS_OUTPUT.PUT_LINE('==============================================');
  DBMS_OUTPUT.PUT_LINE('      INICIANDO BATERÍA DE PRUEBAS BIBLIOTK   ');
  DBMS_OUTPUT.PUT_LINE('==============================================');

  -- 1. Insertamos un socio "a mano" para poder probar los préstamos (Parte opcional)
  INSERT INTO socio (cod_socio, nombre, apellidos) VALUES (999, 'Estudiante', 'Pruebas');
  DBMS_OUTPUT.PUT_LINE('-> Socio de prueba insertado correctamente.');

  -- 2. Alta de Autor y Obra
  v_id_autor := BiblioTK.alta_autor('J.R.R.', 'Tolkien', TO_DATE('03/01/1892', 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('-> Autor registrado con ID: ' || v_id_autor);

  v_id_obra := BiblioTK.alta_obra('El Señor de los Anillos', 1954);
  DBMS_OUTPUT.PUT_LINE('-> Obra registrada con ID: ' || v_id_obra);

  -- 3. Vincular Autor y Obra
  v_resultado := BiblioTK.vincular(v_id_autor, v_id_obra);
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('-> Autor y Obra vinculados (OK).');
  END IF;

  -- 4. Alta de Edición
  v_id_edicion := BiblioTK.alta_edicion(v_id_obra, '978-84-450-0066', 2001);
  DBMS_OUTPUT.PUT_LINE('-> Edición registrada con ID: ' || v_id_edicion);

  -- 5. Alta de Ejemplares (Comprobando que el número es consecutivo)
  v_num_ejemplar1 := BiblioTK.alta_ejemplar(v_id_edicion);
  DBMS_OUTPUT.PUT_LINE('-> Ejemplar 1 registrado con Num: ' || v_num_ejemplar1);

  v_num_ejemplar2 := BiblioTK.alta_ejemplar(v_id_edicion);
  DBMS_OUTPUT.PUT_LINE('-> Ejemplar 2 registrado con Num: ' || v_num_ejemplar2);

  -- 6. Apertura y Cierre de Préstamo (Parte opcional)
  v_resultado := BiblioTK.apertura_prestamo(999, v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Préstamo abierto para el ejemplar 1 (OK).');
  END IF;

  v_resultado := BiblioTK.cierre_prestamo(999, v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Préstamo cerrado para el ejemplar 1 (OK).');
  END IF;

  -- 7. Pruebas de reglas de negocio: BAJA de ejemplar
  v_resultado := BiblioTK.baja_ejemplar(v_id_edicion, v_num_ejemplar1);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Ejemplar 1 dado de baja por deterioro (OK).');
  END IF;

  -- 8. Pruebas de reglas de negocio: BORRADO de ejemplar
  -- Intentamos borrar el ejemplar 1. Debe FALLAR y devolver -1 porque tiene fecha de baja y no es el último.
  v_resultado := BiblioTK.borrado_ejemplar(v_id_edicion, v_num_ejemplar1);
  IF v_resultado = -1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Intento de borrado Ejemplar 1 bloqueado por reglas de negocio (FALLO ESPERADO Y CORRECTO).');
  END IF;

  -- Borramos el ejemplar 2. Debe FUNCIONAR porque es el último de la serie, no tiene baja y hace menos de 30 días del alta.
  v_resultado := BiblioTK.borrado_ejemplar(v_id_edicion, v_num_ejemplar2);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Borrado del Ejemplar 2 (OK).');
  END IF;

  -- 9. Probar el Trigger de Auditoría de Borrado de Obra
  -- Para borrar la obra sin que den error las Foreign Keys, primero borramos sus dependencias
  v_resultado := BiblioTK.borrado_edicion(v_id_edicion);
  v_resultado := BiblioTK.desvincular(v_id_autor, v_id_obra);
  
  -- Borramos la obra, lo que hará saltar nuestro trigger "auditar_borrado_obra"
  v_resultado := BiblioTK.borrado_obra(v_id_obra);
  IF v_resultado = 1 THEN
      DBMS_OUTPUT.PUT_LINE('-> Obra borrada. El TRIGGER de auditoría debería haber saltado (OK).');
  END IF;

  -- Hacemos COMMIT para que el profesor pueda hacer SELECTs a las tablas y ver que se ha guardado
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('==============================================');
  DBMS_OUTPUT.PUT_LINE(' BATERÍA FINALIZADA Y CAMBIOS CONFIRMADOS ');
  DBMS_OUTPUT.PUT_LINE('==============================================');

EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('ERROR FATAL EN BATERÍA DE PRUEBAS: ' || SQLERRM);
     ROLLBACK;
END;
/