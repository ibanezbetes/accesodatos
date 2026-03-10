-- Trigger para auditar borrado de obras (Punto 9.1)
CREATE OR REPLACE TRIGGER auditar_borrado_obra 
BEFORE DELETE ON obra 
FOR EACH ROW
BEGIN
    INSERT INTO audit_borrado_obra (id_borrado, titulo_borrado, anyo_borrado, fecha_auditoria)
    VALUES (:old.id, :old.titulo, :old.anyo, SYSDATE);
END;
/
