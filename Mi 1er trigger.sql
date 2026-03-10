-- Trigger que controla la modificación de salarios de empleados a la baja
-- cada vez que a un empleado se le baje el sueldo se registrará en 
-- una tabla dde auditoría los datos del empleado y la fecha de la modificación

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER LOLO IDENTIFIED BY LOLO;
GRANT CONNECT TO LOLO;
GRANT DBA TO LOLO;

ALTER USER LOLO ACCOUNT UNLOCK;
ALTER USER LOLO IDENTIFIED BY LOLO;

-- A partir de aquí trabajamos con el usuario LOLO

CONNECT LOLO

CREATE TABLE emple_auditado (emp_no NUMBER(4), apellido VARCHAR2(10), 
      salario_viejo NUMBER(7), salario_nuevo NUMBER(7), fecha DATE);

CREATE OR REPLACE TRIGGER mod_emple BEFORE UPDATE ON emple FOR EACH ROW 
BEGIN
  IF (:new.salario <:old.salario) THEN
     INSERT INTO emple_auditado VALUES (:old.emp_no, :old.apellido, :old.salario, 
                    :new.salario, SYSDATE);
  END IF;
END;

/

UPDATE EMPLE SET SALARIO = SALARIO*0.9
  WHERE EMP_NO = 7654;

ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy HH:MI';

SELECT * FROM emple_auditado;

    EMP_NO APELLIDO   SALARIO_VIEJO SALARIO_NUEVO FECHA
---------- ---------- ------------- ------------- ----------------
      7654 MARTIN              1600          1440 26/02/2024 09:16




SQL> SELECT * FROM EMPLE_AUDITADO;

ninguna fila seleccionada

SQL> SELECT * FROM EMPLE;

    EMP_NO APELLIDO   OFICIO            DIR FECHA_ALT     SALARIO   COMISION
---------- ---------- ---------- ---------- ---------- ---------- ----------
   DEPT_NO
----------
      7369 SANCHEZ    EMPLEADO         7902 17/12/1990       1040
        20

      7499 ARROYO     VENDEDOR         7698 20/02/1990       1500        390
        30

      7521 SALA       VENDEDOR         7698 22/02/1991       1625        650
        30


    EMP_NO APELLIDO   OFICIO            DIR FECHA_ALT     SALARIO   COMISION
---------- ---------- ---------- ---------- ---------- ---------- ----------
   DEPT_NO
----------
      7566 JIMENEZ    DIRECTOR         7839 02/04/1991       2900
        20

      7654 MARTIN     VENDEDOR         7698 29/09/1991       1600       1020
        30

      7698 NEGRO      DIRECTOR         7839 01/05/1991       3005
        30


    EMP_NO APELLIDO   OFICIO            DIR FECHA_ALT     SALARIO   COMISION
---------- ---------- ---------- ---------- ---------- ---------- ----------
   DEPT_NO
----------
      7782 CEREZO     DIRECTOR         7839 09/06/1991       2885
        10

      7788 GIL        ANALISTA         7566 09/11/1991       3000
        20

      7839 REY        PRESIDENTE            17/11/1991       4100
        10


    EMP_NO APELLIDO   OFICIO            DIR FECHA_ALT     SALARIO   COMISION
---------- ---------- ---------- ---------- ---------- ---------- ----------
   DEPT_NO
----------
      7844 TOVAR      VENDEDOR         7698 08/09/1991       1350          0
        30

      7876 ALONSO     EMPLEADO         7788 23/09/1991       1430
        20

      7900 JIMENO     EMPLEADO         7698 03/12/1991       1335
        30


    EMP_NO APELLIDO   OFICIO            DIR FECHA_ALT     SALARIO   COMISION
---------- ---------- ---------- ---------- ---------- ---------- ----------
   DEPT_NO
----------
      7902 FERNANDEZ  ANALISTA         7566 03/12/1991       3000
        20

      7934 MUÑOZ      EMPLEADO         7782 23/01/1992       1690
        10


14 filas seleccionadas.

SQL> UPDATE EMPLE SET SALARIO = 3500 WHERE EMP_NO = 7902;

1 fila actualizada.

SQL> COMMIT;

Confirmaci¾n terminada.

SQL> SELECT * FROM EMPLE_AUDITADO;

ninguna fila seleccionada

SQL> UPDATE EMPLE SET SALARIO = 3499 WHERE EMP_NO = 7902;

1 fila actualizada.

SQL> COMMIT;

Confirmaci¾n terminada.

SQL> SELECT * FROM EMPLE_AUDITADO;

    EMP_NO APELLIDO   SALARIO_VIEJO SALARIO_NUEVO FECHA
---------- ---------- ------------- ------------- ----------
      7902 FERNANDEZ           3500          3499 12/02/2025

SQL> UPDATE EMPLE SET SALARIO = 500 WHERE DEPT_NO=10;

3 filas actualizadas.

SQL> COMMIT;

Confirmaci¾n terminada.

SQL> SELECT * FROM EMPLE_AUDITADO;

    EMP_NO APELLIDO   SALARIO_VIEJO SALARIO_NUEVO FECHA
---------- ---------- ------------- ------------- ----------
      7902 FERNANDEZ           3500          3499 12/02/2025
      7782 CEREZO              2885           500 12/02/2025
      7839 REY                 4100           500 12/02/2025
      7934 MUÑOZ               1690           500 12/02/2025