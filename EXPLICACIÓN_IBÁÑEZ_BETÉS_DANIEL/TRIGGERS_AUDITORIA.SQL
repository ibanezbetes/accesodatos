-- Trigger para auditar borrado de obras (Punto 9.1)
-- El modificador "OR REPLACE" sobreescribe el trigger si ya existía.
CREATE OR REPLACE TRIGGER auditar_borrado_obra 
-- "BEFORE DELETE" indica que se ejecutará justo un instante ANTES de que Oracle borre la fila física de la tabla 'obra'.
BEFORE DELETE ON obra 
-- "FOR EACH ROW" significa que esto saltará individualmente por cada fila afectada.
-- Si borramos 5 obras de golpe con un DELETE sin WHERE, este trigger se ejecuta 5 veces.
FOR EACH ROW
BEGIN
    -- Los triggers no deben llevar COMMIT, ya forman parte de la misma transacción que el comando DELETE que los lanzó.
    -- Usamos la palabra reservada :old para acceder a los datos que la fila tenía justo antes de ser borrada.
    INSERT INTO audit_borrado_obra (id_borrado, titulo_borrado, anyo_borrado, fecha_auditoria)
    -- SYSDATE nos devuelve la fecha y hora actual del servidor, perfecto para auditoría.
    VALUES (:old.id, :old.titulo, :old.anyo, SYSDATE);
END;
/
