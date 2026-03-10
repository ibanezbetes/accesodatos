// Recordad !!!  Hay que activar la variable de sesión SERVER_OUTPUT para poder ver por pantalla los mensajes:
//  Antes de ejecutar nada, por línea de comando la activo
// SET SERVER_OUTPUT ON

DECLARE
  v_dept99 NUMBER(2):=0;
  v_num_empleados NUMBER(2);

BEGIN
  SELECT DEPT_NO INTO v_dept99 FROM DEPART WHERE dept_no =99;  

  IF (v_dept99 <> 99)
   THEN 
     INSERT INTO DEPART VALUES (99, 'TEMPORAL', 'TEMPORAL');
  END IF;

  UPDATE EMPLE SET dept_no = 99 WHERE dept_no = 10;
  v_num_empleados := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE(v_num_empleados || ' empleados ubicados en PROVISIONAL');
  DELETE FROM DEPART WHERE dept_no = 10;

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(' NO EXISTE EL DEPT PROVISIONAL');
    INSERT INTO DEPART VALUES (99, 'TEMPORAL', 'TEMPORAL');
END;
/

-- NUEVA VERSIÓN !!!  METIENDO EN EL CONTROL DE ERRORES LAS
-- INSTRUCCIONES DE UPDATE PARA LOS EMPLEADOS DEL DPTO 10 
-- Y EL BORRADO DEL DEPTO 10 !!!

DECLARE
  v_dept99 NUMBER(2):=0;
  v_num_empleados NUMBER(2);

BEGIN
  SELECT DEPT_NO INTO v_dept99 FROM DEPART WHERE dept_no =99;  
  UPDATE EMPLE SET dept_no = 99 WHERE dept_no = 10;
  v_num_empleados := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE(v_num_empleados || ' empleados ubicados en PROVISIONAL');
  DELETE FROM DEPART WHERE dept_no = 10;

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(' NO EXISTE EL DEPT PROVISIONAL LO CREO YO');
    INSERT INTO DEPART VALUES (99, 'TEMPORAL', 'TEMPORAL');
    UPDATE EMPLE SET dept_no = 99 WHERE dept_no = 10;
    v_num_empleados := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(v_num_empleados || ' empleados ubicados en PROVISIONAL');
    DELETE FROM DEPART WHERE dept_no = 10;
END;
/