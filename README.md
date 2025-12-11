
# HEAVY EQUIPMENT PRICING ANALYSIS

Se utilizo un DATASET o conjunto de datos proveniente de Kaggle, que representa operaciones de venta de maquinaria pesada (agricola/construcción) en Estados Unidos, durante los años 2019 y 2020. (DATOS CON FINES EDUCATIVOS FICTICIOS)

## 📌 DESCRIPCIÓN DEL PROYECTO

Este proyecto tiene como objetivo analizar el dataset **Heavy Equipment Pricing Data** para identificar patrones y generar métricas clave relacionadas con la valoración de equipos pesados. Se aplican técnicas de **limpieza de datos**, **transformación** y **visualización** para obtener insights que faciliten la toma de decisiones en el sector industrial.

## 🎯 OBJETIVOS

-Analizar tendencias de compra y comportamiento de los clientes según segmento y tipo de maquinaria.

-Evaluar la influencia de la estacionalidad (mes/año) en el volumen de ventas.

-Comparar la participación de los diferentes estados/regiones en las ventas totales.

-Identificar oportunidades para aumentar la rentabilidad en equipos de alta y baja rotación.

-Proponer estrategias basadas en el tipo de cliente y el comportamiento de compra.

## 💡 HIPÓTESIS DE NEGOCIO

 📈 Las ventas de maquinaria aumentan en determinados meses del año debido a la estacionalidad agrícola y de construcción.
 
 🚜 Las marcas líderes (por ejemplo, John Deere, Caterpillar) concentran la mayor proporción de ingresos.
 
 💰 Los clientes “gran empresa” y “contratista” generan los tickets promedio más altos.
 
 🌎 Algunos estados (por ejemplo, Illinois, Texas) lideran en ingresos y volumen de ventas.
 



## 🛠️ TECNOLOGÍAS UTILIZADAS

- **Google BigQuery**: Procesamiento y consultas SQL.

- **Canva**: Desarrollo de portada y diseño de dashboards.

- **Power BI**: Generacion de dashboards y visualización.
  
- **GitHub**: Control de versiones y documentación.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 📂 ESTRUCTURA DEL PROYECTO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 🔍 DESCRIPCIÓN DE LA FUENTE DE DATOS

El conjunto de datos utilizado para el desarrollo del proyecto es un archivo CSV que contiene información detallada sobre transacciones comerciales de maquinaria pesada en el mercado estadounidense. Tu dataset contiene 1742 registros y 14 columnas. 

Este conjunto de datos permite analizar tendencias de ventas, comportamiento del cliente y desempeño de productos en diferentes regiones y periodos. Las variables incluidas abarcan datos clave como identificador único de la máquina, marca, tipo, año de fabricación, estado, horas de uso, condición (nuevo/usado), segmento de cliente, fecha de transacción, tipo de vendedor, forma de pago y precio de venta, entre otros.

Esta fuente de datos resulta especialmente valiosa para:

•	Analizar tendencias de ventas por región, tipo de máquina y segmento de cliente.

•	Evaluar el comportamiento de compra y las preferencias de los distintos perfiles de clientes.

•	Medir el desempeño de productos y marcas en diferentes estados y periodos.

•	Identificar patrones estacionales y oportunidades de negocio en el sector de maquinaria pesada.

## 📋 PLAN DE MÉTRICAS

Para validar las hipótesis planteadas, se han definido 18 indicadores clave (KPIs) que facilitan el análisis del comportamiento de los clientes y el desempeño de las transacciones.

<img width="1702" height="330" alt="image" src="https://github.com/user-attachments/assets/3951c7bc-7ebc-4205-8ef9-650fd68e2955" />

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 💾 Data Flow

A continuación, se detalla el flujo de datos utilizado para la Extracción, Transformación y Carga de Datos (ETL) en el proyecto:

<img width="887" height="492" alt="image" src="https://github.com/user-attachments/assets/8f338748-6962-4ee4-a1ce-30e91aff3b67" />

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

🏗️ Entorno de Trabajo

Las consultas están diseñadas para ejecutarse en Google Cloud Platform > BigQuery, utilizando la sintaxis específica de este entorno.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🟤 Capa Bronce

Se subió el archivo CSV, que contiene 14 columnas y 1742 registros, como la tabla heavyquipment en el dataset que se llama de la misma manera. 

En esta capa, los datos se almacenan sin modificaciones para conservar su estado original.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## ⚪  Capa Silver

En esta etapa, se transformaron y depuraron los datos provenientes de la capa Bronze.
Se crearon las tablas DIM y FACT SALES en el conjunto de datos capaplata.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## ⭐ Data Mart

En el contexto de este proyecto, el Data Mart fue diseñado para centralizar y organizar la información clave relacionada con las ventas de maquinaria, permitiendo un análisis eficiente mediante la segmentación y el almacenamiento estructurado de los parámetros más relevantes.

Antes de la construcción del modelo, se realizó un proceso de limpieza y depuración para garantizar la calidad de los datos, asegurando que la información utilizada fuera confiable y lista para el análisis.

Posteriormente, se implementó un modelo dimensional tipo estrella (⭐) compuesto por 1 tabla de hechos, 3 tablas dimensionales, creadas en Big Query y una DIM_CALENDAR DAX obtenida en Power Query, que permiten una estructura optimizada para consultas analíticas:

<img width="1197" height="690" alt="image" src="https://github.com/user-attachments/assets/03f58847-217e-4172-a229-654e2fc95120" />

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## ⚙️ Modelo de Datos y Scripts SQL

Este modelo permite estructurar los datos de manera eficiente, agrupándolos en categorías como:

## Tabla de hechos: fact_sales

Contiene los datos transaccionales de las ventas, incluyendo atributos como:

id_venta (clave primaria)

id_machine (relación con la dimensión máquina)

precio_venta, modelo, horas_uso, nuevo_usado

Variables de contexto: estado, region, fecha_de_transaccion, forma_de_pago, tipo_de_cliente, tipo_de_vendedor



## Tablas Dimensionales:

dim_machine: Detalles de la máquina (ID, nombre, marca).

dim_state: Información geográfica (estado, región).

dim_customer_segment: Segmentación del cliente y tipo de vendedor.

dim_calendar: Desglose temporal (fecha, año, mes, día).

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📝 Script de Creación de Tablas

A continuación, se presenta el script completo para la creación de todas las tablas del Data Mart:


##  Crear tabla DIM_MACHINE

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.dim_machine` AS

WITH combinaciones AS (

  SELECT DISTINCT
  
    machine_name AS maquina,

    brand AS marca
    
  FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment`
)

SELECT

  ROW_NUMBER() OVER (ORDER BY maquina, marca) AS id,
  
  maquina,
  
  marca
  
FROM combinaciones;


## crear tabla DIM_STATE 

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

## crear tabla DIM_CUSTOMER_SEGMENT --

CREATE OR REPLACE TABLE `miproyecto2025-476423.capaplata.dim_customer_segment` AS

SELECT DISTINCT

  client_type AS segmento_cliente,

  seller_type AS tipo_vendedor

FROM `subtle-signal-472203-u7.heavyequipment.heavyequipment`;


## Dim_Calendar =

ADDCOLUMNS (

    CALENDAR (
        DATE (
            YEAR ( MIN ( 'fact_sales (2)'[fecha_de_transaccion] ) ),
            01,
            01
        ),
        DATE (
            YEAR ( MAX ( 'fact_sales (2)'[fecha_de_transaccion] ) ),
            12,
            31
        )
    ),

    "FechaSK", FORMAT ( [Date], "YYYYMMDD" ),

    "#Año", YEAR ( [Date] ),

    "#Trimestre", QUARTER ( [Date] ),

    "#Mes", MONTH ( [Date] ),

    "#Día", DAY ( [Date] ),

    "Trimestre", "T" & FORMAT ( [Date], "Q" ),

    "Mes", FORMAT ( [Date], "MMMM" ),

    "MesCorto", FORMAT ( [Date], "MMM" ),

    "#DíaSemana", WEEKDAY ( [Date], 2 ),

    "#SemanaAño", WEEKNUM ( [Date], 2 ),

    "CierreSemana", ( [Date] + 7 - WEEKDAY ( [Date], 2 ) ),

    "Día", FORMAT ( [Date], "DDDD" ),

    "DíaCorto", FORMAT ( [Date], "DDD" ),

    "AñoTrimestre", FORMAT ( [Date], "YYYY" ) & "/T" & FORMAT ( [Date], "Q" ),

    "Año#Mes", FORMAT ( [Date], "YYYY/MM" ),

    "AñoMesCorto", FORMAT ( [Date], "YYYY/mmm" ),

    "InicioMes", EOMONTH ( [Date], -1 ) + 1,

    "FinMes", EOMONTH ( [Date], 0 )

)



## crear tabla FACT_SALES --

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
  
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📏 Métricas de Rendimiento

Para este proyecto, se utilizaron medidas DAX para calcular los KPIs que se describen en el plan de métricas. A continuación, se detallan las medidas creadas en la tabla Medidas:

Métricas de Rendimiento
Para este proyecto, se utilizaron medidas DAX para calcular los KPIs que se describen en el plan de métricas. A continuación, se detallan las medidas creadas en la tabla Medidas:

1.	Equipos Vendidos:

Equipos_Vendidos = COUNTROWS(fact_sales)

2. Precio Promedio de Venta

Precio_Promedio_Venta = AVERAGE(fact_sales[price_usd])

3.	Precio Máximo y Mínimo

Precio_Maximo = MAX(fact_sales[price_usd])

Precio_Minimo = MIN(fact_sales[price_usd])

4. Ventas por Tipo de Cliente

Ventas_Por_Tipo_Cliente = CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales, 

fact_sales[client_type])

 5. Ventas por Tipo de Máquina

Ventas_Por_Tipo_Maquina = CALCULATE([Equipos_Vendidos],  ALLEXCEPT(fact_sales,
 
 fact_sales[machine_name]))


6. Ventas por Marca

Ventas_Por_Marca = CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales, fact_sales[brand]))


7. Precio Promedio por Estado

Precio_Promedio_Por_Estado = CALCULATE(AVERAGE(fact_sales[price_usd]), 

ALLEXCEPT(fact_sales, fact_sales[state]))


8. Precio Promedio por Condición (Nuevo/Usado)

Precio_Promedio_Por_Condicion = CALCULATE(AVERAGE(fact_sales[price_usd]), 

ALLEXCEPT(fact_sales, fact_sales[new_or_used]))


9. Evolución de Precios por Año

Precio_Promedio_Por_Año = 

AVERAGEX(

VALUES(Dim_Calendar[Año]), 
   
CALCULATE(AVERAGE(fact_sales[price_usd]))
)


10. Antigüedad Promedio del Equipo

Antiguedad_Promedio = 

AVERAGEX(
   
    fact_sales, 
   
    YEAR(fact_sales[transaction_date]) - fact_sales[year]
)

11. Ticket Promedio por Cliente

Ticket_Promedio_Por_Cliente = 

AVERAGEX(

 VALUES(fact_sales[client_type]),

 CALCULATE(AVERAGE(fact_sales[price_usd]))

13. Volumen de Ventas por Estado 

Volumen_Ventas_Por_Estado = CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales,

fact_sales[state]))


14. Volumen de Ventas por Mes

Volumen_Ventas_Por_Mes = 

CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales, Dim_Calendar[Mes]))

15. % de Ventas por Forma de Pago

Ventas_Por_Forma_Pago = CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales, fact_sales[payment_type]))

Porcentaje_Ventas_Por_Forma_Pago = 

DIVIDE([Ventas_Por_Forma_Pago], [Equipos_Vendidos], 0)

16. % de Ventas por Tipo de Vendedor
 
Ventas_Por_Tipo_Vendedor = CALCULATE([Equipos_Vendidos], ALLEXCEPT(fact_sales, fact_sales[seller_type]))

Porcentaje_Ventas_Por_Tipo_Vendedor = 

DIVIDE([Ventas_Por_Tipo_Vendedor], [Equipos_Vendidos], 0)

16. Precio Promedio por Segmento
    
Precio_Promedio_Por_Segmento = 

AVERAGEX(

VALUES(fact_sales[client_type]),
    
CALCULATE(AVERAGE(fact_sales[price_usd]))

)

17. Equipos de Mayor Rotación

Ranking_Maquinas = 

RANKX(

ALL(fact_sales[machine_name]),
    
ALCULATE([Equipos_Vendidos]),
  
    
 DESC,
    
DENSE
)

18. Equipos de Menor Rotación

Ranking_Maquinas_Menor = 

RANKX(

    ALL(fact_sales[machine_name]),
    
    CALCULATE([Equipos_Vendidos]),
    ,
    
    ASC,
    
    DENSE
    
)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## 📈 Análisis de Datos

El análisis de datos se realizó con un enfoque descriptivo y comparativo. Se creó un reporte compuesto por:

1 Portada

5 Dashboards

Los dashboards destacan aspectos clave de las ventas y presentan visualizaciones específicas para abordar cada una de las hipótesis de negocio. 

Esto permitió identificar insights relevantes para el proyecto.

Objetivo del Diseño

Los dashboards fueron diseñados con el objetivo de facilitar la comprensión de las visualizaciones, destacando las métricas principales y su relación con los datos, garantizando un análisis claro y efectivo.

<img width="1405" height="768" alt="image" src="https://github.com/user-attachments/assets/431e6218-8af9-44cd-8a63-084428a9cd7d" />

<img width="1402" height="799" alt="image" src="https://github.com/user-attachments/assets/ee5ab78e-d033-44bc-a60d-757c3e08c9fd" />

<img width="1402" height="787" alt="image" src="https://github.com/user-attachments/assets/21ebf1dc-47dc-4c26-a083-449dd4a1962b" />

<img width="1418" height="790" alt="image" src="https://github.com/user-attachments/assets/2dcdaabb-dbc0-4789-a568-1feb3fd8ade0" />

<img width="1422" height="801" alt="image" src="https://github.com/user-attachments/assets/ecb899bd-10a6-4ed4-b0ce-477f51884e34" />

<img width="1401" height="779" alt="image" src="https://github.com/user-attachments/assets/97c426ba-b7fd-469c-99f6-ee549c1ebed1" />

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

💡 Prueba de Hipótesis

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Hipótesis 1 — Estacionalidad

Las ventas de maquinaria aumentan en determinados meses del año debido a la estacionalidad agrícola y de construcción. ¿Es real?

Se analizaron visualizaciones con la evolución mensual de ventas (2019–2020), la variación interanual y el ranking de meses con mejor y peor desempeño. Los gráficos utilizados fueron:

ValorVenta por YearMonthText y Año/Mes (barras mensuales).

Tarjeta del mes pico.

Tarjeta del mes valle.

Variación interanual 2020 vs 2019.

Evidencia observada:

Mes de mayor facturación: junio de 2019 con $7,069,804.

Mes de menor facturación: febrero de 2020 con $3,951,385.

Variación interanual (YoY) 2020 vs 2019: -4.2%.

En las barras mensuales se aprecian picos concentrados en meses específicos (junio, y otros meses del Q2–Q3), con valles claros en los meses de invierno (enero–febrero), patrón consistente con ciclos agrícolas/obra.

Conclusión:

La hipótesis de estacionalidad se confirma: existen meses con picos (junio destaca) y otros con valles (febrero), coherentes con calendarios de cosecha/siembra y 
cronogramas de construcción. Aunque 2020 presenta un descenso del -4.2% frente a 2019, el patrón mensual de picos y valles se mantiene.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Hipótesis 2 — Concentración en Marcas Líderes

Las marcas líderes (John Deere, Caterpillar, etc.) concentran la mayor proporción de ingresos.
Se utilizaron:

Treemap Top 5 Brands (ventas por marca).

Grafico circular % Top 5 vs Others.

Tarjeta  “Top 5 — 75.3%”.

Evidencia observada:

La participación de las Top 5 alcanza 75.3% del total (Ventas_Top5_Total / Ventas_Totales).

El grafico circular % Top 5 vs Others muestra una relación clara de ~75% vs ~25%, confirmando alta concentración en esas marcas.

El treemap evidencia la distribución por marca, con líderes que acumulan volúmenes significativamente superiores al resto.

Conclusión:

La hipótesis se valida: el mercado presenta alta concentración en pocas marcas líderes (Top 5 ≈ 75% del total). Esto sugiere estrategias comerciales y de portfolio fuertemente orientadas a esas marcas.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Hipótesis 3 — Ticket Promedio por Segmento

Los clientes “gran empresa” y “contratista” generan los tickets promedio más altos.

Se analizaron:

Average Ticket by Customer Type (línea por tipo de cliente).

TotalVentas por segmento_cliente (distribución en torta).

Sales Rep by Customer Type (Dealer vs Privado) para entender el mix de canal.

Evidencia observada:

El gráfico de Average Ticket muestra una jerarquía descendente por tipo; en tu visual los tickets más altos aparecen en la parte izquierda (p. ej., Distribuidor/Agricultor/Contratista), con Gobierno como el más bajo alrededor de $70k–$72k.

La torta por segmento está relativamente balanceada (13–15% cada uno), lo que sugiere que volumen de ventas está diversificado, pero el ticket promedio difiere por segmento.

La barra apilada Dealer vs Privado revela mix de canal por tipo de cliente (algunos segmentos muestran 100% en un canal), lo que impacta el ticket: Dealer tiende a tickets altos cuando predomina en segmentos con ventas de alto valor.

Conclusión:

La hipótesis se confirma parcialmente: Contratista y  otros, (p. ej., Distribuidor/Agricultor) muestran tickets promedio más altos. Gran empresa no es el máximo en el gráfico, pero mantiene un ticket elevado. El tipo de vendedor (Dealer vs Privado) influye en el ticket por segmento.


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Hipótesis 4 — Estados Líderes

Algunos estados (Illinois, Texas) lideran en ingresos y volumen de ventas.
Se utilizaron:

Tarjetas de facturación por estado.
Mapa Top 5 States — Sales.

Scatter (TotalVentas vs TicketPromedio) coloreado por región.


Evidencia observada:

Estado con mayor facturación: Nebraska — $7,813,686.

Estado con menor facturación: North Dakota — $416,151.

Estado con mayor ticket promedio: Virginia — $94,099.44.

El mapa Top 5 resalta Nebraska, Montana, Iowa, Arizona y South Dakota como polos relevantes.

El scatter muestra la relación volumen vs ticket por estado, con clústeres regionales que ayudan a identificar territorios de alto valor (ticket alto) vs alto volumen (muchas transacciones).

Conclusión:

La hipótesis se valida en términos de liderazgo territorial, aunque los líderes específicos de tu dataset son Nebraska (ingresos) y Virginia (ticket), no Illinois/Texas. El análisis por región y el mapa de Top 5 confirman concentración geográfica de ventas y diferencias de valor por estado.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🏆 Resultados Obtenidos

## Estacionalidad marcada en ventas.

Picos en junio de 2019 ($7,069,804) y valles en febrero de 2020 ($3,951,385).

Variación 2020 vs 2019: -4.2% (descenso interanual), manteniendo el patrón mensual.


## Alta concentración en marcas líderes.

Top 5 marcas concentran 75.3% de las ventas; el resto 24.7%.

Implica foco comercial en pocas marcas estratégicas.


## Tickets más altos por segmentos profesionales.

Contratista (y perfiles afines como Distribuidor/Agricultor) con tickets superiores.
Gobierno en el extremo inferior (~$70k).

## Dominio territorial heterogéneo.

Nebraska lidera en facturación ($7,813,686); North Dakota es el mínimo ($416,151).

Virginia presenta el ticket promedio más alto ($94,099.44).

Top 5 estados: Nebraska, Montana, Iowa, Arizona, South Dakota.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

📧 Contacto

Cualquier duda sobre el proyecto, no dudes en conectarte conmigo: https://drive.google.com/file/d/1Tgg2zgvFtz7mcTW-5FDpIkxm1RrfwE52/view?usp=drive_link

LinkedIn: https://www.linkedin.com/in/agust%C3%ADn-lesmes-a60449196/
