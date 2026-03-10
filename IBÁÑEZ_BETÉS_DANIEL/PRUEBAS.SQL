SET SERVEROUTPUT ON;

DECLARE
  v_id_obra VARCHAR2(5);
  v_id_autor VARCHAR2(4);
  v_resultado INTEGER;
BEGIN
  -- Probamos Alta de Obra
  v_id_obra := BiblioTK.alta_obra('El Quijote', 1605);
  DBMS_OUTPUT.PUT_LINE('Obra dada de alta con ID: ' || v_id_obra);
  
  -- Probamos Alta de Autor
  v_id_autor := BiblioTK.alta_autor('Miguel', 'Cervantes');
  DBMS_OUTPUT.PUT_LINE('Autor dado de alta con ID: ' || v_id_autor);
  
  -- Probamos vincular
  v_resultado := BiblioTK.vincular(v_id_autor, v_id_obra);
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Obra y Autor vinculados correctamente.');
  END IF;
  
  -- Probamos el borrado (Para probar el trigger de auditoría)
  v_resultado := BiblioTK.borrado_obra(v_id_obra);
  IF v_resultado = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Obra borrada correctamente. Revisa la tabla audit_borrado_obra.');
  END IF;
  
  -- Como las llamadas a funciones de modificación requieren Commit en la sesión:
  COMMIT;
END;
/
