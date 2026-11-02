-- Sistema Peluquería - Base de datos (MySQL 8, esquema `peluqueria`).
-- NO destructivo: no borra el esquema ni los datos existentes y se puede ejecutar varias veces.
SET NAMES utf8mb4;
CREATE SCHEMA IF NOT EXISTS `peluqueria` DEFAULT CHARACTER SET utf8mb4;
USE `peluqueria`;

-- ============================================================
-- 1. ESQUEMA
-- ============================================================
CREATE TABLE IF NOT EXISTS `cliente` (
  `idcliente` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`    VARCHAR(60) NOT NULL,
  `telefono`  VARCHAR(20) NULL,
  `email`     VARCHAR(80) NULL,
  PRIMARY KEY (`idcliente`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `servicio` (
  `idservicio`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`       VARCHAR(60) NOT NULL,
  `duracion_min` SMALLINT UNSIGNED NOT NULL,
  `precio`       DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idservicio`)
) ENGINE = InnoDB;

-- 1:n cliente-turno y 1:n servicio-turno.
-- fecha_fin = fecha_inicio + duración del servicio (se calcula en la aplicación).
-- precio = importe cobrado en este turno (puede diferir del precio actual del servicio).
CREATE TABLE IF NOT EXISTS `turno` (
  `idturno`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cliente_idcliente`   INT UNSIGNED NOT NULL,
  `servicio_idservicio` INT UNSIGNED NOT NULL,
  `fecha_inicio`        DATETIME NOT NULL,
  `fecha_fin`           DATETIME NOT NULL,
  `precio`              DECIMAL(10,2) NOT NULL,
  `estado` ENUM('PENDIENTE','CONFIRMADO','ATENDIDO','CANCELADO','AUSENTE')
           NOT NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (`idturno`),
  INDEX `fk_turno_cliente_idx`  (`cliente_idcliente`),
  INDEX `fk_turno_servicio_idx` (`servicio_idservicio`),
  INDEX `idx_turno_inicio`      (`fecha_inicio`),
  CONSTRAINT `fk_turno_cliente` FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `cliente` (`idcliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_turno_servicio` FOREIGN KEY (`servicio_idservicio`)
    REFERENCES `servicio` (`idservicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- ============================================================
-- 2. DATOS DE PRUEBA (solo si las tablas están vacías)
-- ============================================================
INSERT INTO `servicio` (`nombre`, `duracion_min`, `precio`)
SELECT v.n, v.d, v.p
FROM (SELECT 'Corte' AS n, 30 AS d, 8000.00 AS p
      UNION ALL SELECT 'Tintura', 90, 25000.00
      UNION ALL SELECT 'Barba', 20, 5000.00) v
WHERE NOT EXISTS (SELECT 1 FROM `servicio`);

INSERT INTO `cliente` (`nombre`, `telefono`, `email`)
SELECT v.n, v.t, v.e
FROM (SELECT 'Laura Gómez' AS n, '2644000001' AS t, 'laura@example.com' AS e
      UNION ALL SELECT 'Martín Ruiz', '2644000002', NULL) v
WHERE NOT EXISTS (SELECT 1 FROM `cliente`);

-- Dos turnos de mañana, para probar listados y la regla de solapamiento.
-- El precio cobrado se toma del precio del servicio.
INSERT INTO `turno` (`cliente_idcliente`, `servicio_idservicio`, `fecha_inicio`, `fecha_fin`, `precio`, `estado`)
SELECT c.idcliente, s.idservicio, v.inicio,
       DATE_ADD(v.inicio, INTERVAL s.duracion_min MINUTE), s.precio, 'CONFIRMADO'
FROM (SELECT 'Laura Gómez' AS cliente, 'Corte' AS servicio,
             TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00') AS inicio
      UNION ALL SELECT 'Martín Ruiz', 'Tintura',
             TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00')) v
JOIN `cliente`  c ON c.nombre = v.cliente
JOIN `servicio` s ON s.nombre = v.servicio
WHERE NOT EXISTS (SELECT 1 FROM `turno`);

-- Verificación: deben aparecer 2 filas (Laura/Corte 10:00-10:30 $8000 y Martín/Tintura 11:00-12:30 $25000).
SELECT t.idturno, c.nombre AS cliente, s.nombre AS servicio,
       t.fecha_inicio, t.fecha_fin, t.precio, t.estado
FROM `turno` t
JOIN `cliente`  c ON c.idcliente  = t.cliente_idcliente
JOIN `servicio` s ON s.idservicio = t.servicio_idservicio
ORDER BY t.fecha_inicio;
