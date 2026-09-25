-- =========================================
-- EXAMEN: Inventario Pizzería Don Piccolo
-- Script principal (ejecutar antes del trigger)
-- =========================================

-- 1) Tabla de ingredientes
CREATE TABLE ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,     -- nombre del ingrediente, no se repite
    unidad_medida VARCHAR(10) NOT NULL,     -- ej: kg, lts, und
    stock_actual DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0
);

-- 2) Tabla de movimientos (entradas/salidas de insumos)
CREATE TABLE movimientos_ingrediente (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_ingrediente INT NOT NULL,
    tipo ENUM('ENTRADA','SALIDA') NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    fecha_movimiento DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

-- 3) Ingredientes con bajo stock (stock_actual < stock_minimo)
SELECT nombre, unidad_medida, stock_actual
FROM ingredientes
WHERE stock_actual < stock_minimo
ORDER BY stock_actual ASC;

-- 4) Últimos 5 movimientos registrados (con nombre del ingrediente)
SELECT i.nombre, m.tipo, m.fecha_movimiento
FROM movimientos_ingrediente m
JOIN ingredientes i ON m.id_ingrediente = i.id_ingrediente
ORDER BY m.fecha_movimiento DESC
LIMIT 5;

-- 5) Vista resumen del inventario (ordenada por diferencia)
CREATE VIEW vista_resumen_inventario AS
SELECT
    nombre,
    stock_actual,
    stock_minimo,
    (stock_actual - stock_minimo) AS diferencia
FROM ingredientes
ORDER BY diferencia ASC;

-- NOTA: el trigger 'actualizar_stock_ingrediente' está en el archivo
-- trigger_actualizar_stock.sql, ejecutarlo después de este script
-- porque depende de la tabla movimientos_ingrediente creada aquí.
