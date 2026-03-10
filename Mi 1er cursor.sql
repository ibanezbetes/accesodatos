SET SERVEROUTPUT ON

DECLARE
  CURSOR v_cur1 IS 
    SELECT dnombre, loc FROM DEPART;
  v_nombre DEPART.dnombre%TYPE;
  v_localidad DEPART.loc%TYPE; 
BEGIN
  OPEN v_cur1;
  LOOP
    FETCH v_cur1 INTO v_nombre, v_localidad;
    EXIT WHEN v_cur1%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_nombre||' * '||v_localidad);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(v_cur1%ROWCOUNT||' DEPARTAMENTOS LISTADOS');
  CLOSE v_cur1;
END;