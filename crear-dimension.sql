
--crear tabla DIM_MACHINE--

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.dim_machine` AS
WITH combinaciones AS (
  SELECT
    DISTINCT machine_name AS maquina,
    brand AS marca
  FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment`
)
SELECT
  ROW_NUMBER() OVER (ORDER BY maquina, marca) AS id,
  maquina,
  marca
FROM combinaciones;

--crear tabla DIM_STATE--

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.dim_state` AS
SELECT DISTINCT
  state,
  CASE
    WHEN state IN ('North Dakota','South Dakota','Minnesota','Wisconsin','Michigan') THEN 'NORTE'
    WHEN state IN ('Texas','Florida','Georgia','Alabama','Mississippi','Louisiana','South Carolina','North Carolina','Tennessee','Kentucky','Arkansas','Oklahoma') THEN 'SUR'
    WHEN state IN ('Illinois','Indiana','Iowa','Missouri','Kansas','Nebraska','Ohio') THEN 'CENTRO'
    WHEN state IN ('New York','New Jersey','Pennsylvania','Virginia','West Virginia','Maryland','Delaware','Connecticut','Massachusetts','Vermont','New Hampshire','Maine','Rhode Island','District of Columbia') THEN 'ESTE'
    WHEN state IN ('California','Washington','Oregon','Nevada','Arizona','New Mexico','Colorado','Utah','Idaho','Montana','Wyoming','Alaska','Hawaii') THEN 'OESTE'
  END AS region
FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment`
WHERE state IS NOT NULL;

--crear tabla DIM_CUSTOMER_SEGMENT--

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.dim_customer_segment` AS
SELECT DISTINCT
  client_type AS segmento_cliente,
  seller_type AS tipo_vendedor,
FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment`;

--crear tabla FACT_SALES--

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.fact_sales` AS
SELECT
  h.uuid AS id_venta,
  m.id AS id_machine, -- ID incremental de la máquina
  h.price_usd AS precio_venta,
  h.year AS modelo,
  h.meter_hours AS horas_uso,
  h.new_or_used AS nuevo_o_usado,
  h.state AS estado,
  h.region AS region,
  h.transaction_date AS fecha_de_transaccion,
  h.payment_type AS forma_de_pago,
  h.client_type AS tipo_de_cliente,
  h.seller_type AS tipo_de_vendedor
FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment` h
LEFT JOIN `miproyecto2025-476423.capaplata.dim_machine` m
  ON h.machine_name = m.maquina
  AND h.brand = m.marca;



