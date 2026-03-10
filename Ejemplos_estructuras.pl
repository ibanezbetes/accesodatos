SET SERVEROUTPUT ON
DECLARE
  v_sum NUMBER(2) := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('En el bucle, vuelta '||v_sum);
    v_sum:=(v_sum+1);
    IF v_sum > 10 THEN
       EXIT;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIN ');

END;  

// v 2.0  EJEMPLO DE COMO NO SE TIENE QUE HACER; SE DESCONTROLA EL BUCLE

SET SERVEROUTPUT ON
DECLARE
  v_sum NUMBER(2) := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('En el bucle, vuelta '||v_sum);
    v_sum:=(v_sum+1);
    IF v_sum > 10 THEN
       EXIT;
    END IF;
    v_sum:=v_sum+1;
    DBMS_OUTPUT.PUT_LINE('Sigo en el bucle, aumento vsum '||v_sum);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIN ');

END; 


// v 3.0  EJEMPLO DE COMO NO SE TIENE QUE HACER; SE DESCONTROLA EL BUCLE

SET SERVEROUTPUT ON
DECLARE
  v_sum NUMBER(2) := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('En el bucle, vuelta '||v_sum);
    v_sum:=(v_sum+1);
    IF v_sum > 10 THEN
       EXIT;
    END IF;
    v_sum:=v_sum+1;
    DBMS_OUTPUT.PUT_LINE('Sigo en el bucle, aumento vsum '||v_sum);
    IF v_sum = 6 THEN
       EXIT;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIN ');

END; 