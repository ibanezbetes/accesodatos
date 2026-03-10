SET SERVEROUTPUT ON
DROP PROCEDURE ver_emple_por_dpto;

CREATE OR REPLACE PROCEDURE ver_emple_por_dpto(dep VARCHAR2) AS
  v_dept EMPLE.dept_no%TYPE;
  CURSOR v_cur1 IS 
    SELECT emp_no, apellido FROM EMPLE
    WHERE dept_no = dep;
  v_num_emple EMPLE.emp_no%TYPE;
  v_apellido EMPLE.apellido%TYPE;

BEGIN
  v_dept := dep;
  OPEN v_cur1;
  FETCH v_cur1 INTO v_num_emple, v_apellido;
  WHILE v_cur1%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(v_num_emple||' '||v_apellido);
    FETCH v_cur1 INTO v_num_emple,v_apellido;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(v_cur1%ROWCOUNT||' EMPLEADOS LISTADOS');
  CLOSE v_cur1;
END;