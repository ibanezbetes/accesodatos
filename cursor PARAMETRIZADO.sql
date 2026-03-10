SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE ver_emple_por_dpto(dep VARCHAR2) AS
  v_dept EMPLE.dept_no%TYPE;
  CURSOR v_cur1 IS 
    SELECT apellido FROM EMPLE
    WHERE dept_no = v_dept;
  v_apellido EMPLE.apellido%TYPE;

BEGIN
  v_dept := dep;
  OPEN v_cur1;
  FETCH v_cur1 INTO v_apellido;
  WHILE v_cur1%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(v_apellido);
    FETCH v_cur1 INTO v_apellido;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(v_cur1%ROWCOUNT||' EMPLEADOS LISTADOS');
  CLOSE v_cur1;
END;
/

DECLARE
v_dept_no NUMBER(2);
BEGIN
  v_dept_no := &v_num_dpto;
  ver_emple_por_dpto(v_dept_no);
END;
/