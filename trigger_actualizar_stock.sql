-- =========================================
-- TRIGGER: actualizar_stock_ingrediente
-- Requiere haber ejecutado antes: inventario_pizzeria.sql
-- (usa las tablas ingredientes y movimientos_ingrediente)
-- =========================================

DELIMITER $$

CREATE TRIGGER actualizar_stock_ingrediente
AFTER INSERT ON movimientos_ingrediente
FOR EACH ROW
BEGIN
    -- Si es ENTRADA, se suma la cantidad al stock
    IF NEW.tipo = 'ENTRADA' THEN
        UPDATE ingredientes
        SET stock_actual = stock_actual + NEW.cantidad
        WHERE id_ingrediente = NEW.id_ingrediente;
    -- Si es SALIDA, se resta la cantidad del stock
    ELSEIF NEW.tipo = 'SALIDA' THEN
        UPDATE ingredientes
        SET stock_actual = stock_actual - NEW.cantidad
        WHERE id_ingrediente = NEW.id_ingrediente;
    END IF;
END$$

DELIMITER ;
