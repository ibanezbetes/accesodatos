-- Activa la funcionalidad de imprimir mensajes por consola en Oracle
SET SERVEROUTPUT ON;

-- Inicio del Bloque Anónimo PL/SQL de prueba. DECLARE define las variables del test.
DECLARE
  v_id_obra VARCHAR2(5);
  v_id_autor VARCHAR2(4);
  v_resultado INTEGER;
BEGIN
  -- Probamos Alta de Obra. Llamamos al paquete.nombrefuncion y metemos su devolución a la variable
  v_id_obra := BiblioTK.alta_obra('El Quijote', 1605);
  -- Imprimimos (el equivalente a un print() de Java/Python)
  DBMS_OUTPUT.PUT_LINE('Obra dada de alta con ID: ' || v_id_obra);
  
  -- Probamos Alta de Autor
  v_id_autor := BiblioTK.alta_autor('Miguel', 'Cervantes');
  DBMS_OUTPUT.PUT_LINE('Autor dado de alta con ID: ' || v_id_autor);
  
  -- Probamos vincular
  v_resultado := BiblioTK.vincular(v_id_autor, v_id_obra);
  -- Evaluamos resultado estandar. 1 = éxito
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Obra y Autor vinculados correctamente.');
  END IF;
  
  -- Probamos el borrado para detonar el trigger interno automaticamente.
  v_resultado := BiblioTK.borrado_obra(v_id_obra);
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Obra borrada correctamente. Revisa la tabla audit_borrado_obra.');
  END IF;
  
  -- Al testear no nos podemos olvidar del COMMIT; o los datos no se guardan de verdad 
  -- una vez termina el bloque anónimo, es fundamental para que persista en disco.
  COMMIT;
END;
/
