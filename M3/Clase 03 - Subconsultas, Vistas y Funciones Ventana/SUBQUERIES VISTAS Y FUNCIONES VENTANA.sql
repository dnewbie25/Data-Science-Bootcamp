use henry;

-- Alumno que ingresó primero
select * from alumnos where fecha_ingreso=(SELECT 
    MIN(fecha_ingreso)
FROM
    alumnos);
    
-- obtener la lista de las cohortes sin alumnos asignados 
select * from cohorte where idcohorte not in (select distinct cohorte from alumnos);

-- guardar vistas

create view cohorte_sin_alumnos as select * from cohorte where idcohorte not in (select distinct cohorte from alumnos);

select * from cohorte_sin_alumnos;

-- ++++++++++++++++++++++++++++++++++		Funciones ventana		++++++++++++++++++++++++
use henry_checkpoint_m3;
-- sin usar funciones ventanas se puede comparar el total del ventas de cada producto con el promedio de ventas del día
SELECT 
    v.idventa,
    v.fecha,
    v.cantidad * v.precio AS venta,
    a.prom_venta,
    ROUND(((v.cantidad * v.precio) / a.prom_venta) * 100,
            2) AS relacion_venta_promedio_venta
FROM
    henry_checkpoint_m3.venta v
        INNER JOIN
    (SELECT 
        fecha, AVG(precio * cantidad) AS prom_venta
    FROM
        henry_checkpoint_m3.venta
    GROUP BY fecha) a ON v.fecha = v.fecha
ORDER BY v.fecha; 

-- usando funciones ventana se puede hacer así
SELECT 
    v.idventa,
    v.fecha,
    v.cantidad * v.precio AS venta,
    avg(v.cantidad * v.precio) over (partition by v.fecha) as prom_venta
FROM henry_checkpoint_m3.venta v
ORDER BY v.fecha; 

-- venta acumulada a lo largo del dia
SELECT 
    v.idventa,
    v.fecha,
    v.cantidad * v.precio AS venta,
    sum(v.cantidad * v.precio) over (partition by v.fecha rows between unbounded preceding and current row) as total_venta_promedio_acumulada
FROM henry_checkpoint_m3.venta v
ORDER BY v.fecha; 

SELECT 
    SUM(precio * cantidad)
FROM
    henry_checkpoint_m3.venta
WHERE
    fecha = '2019-01-01';

-- hacer ranking
select rank() over (partition by v.fecha order by precio*cantidad desc) as rank_ventas, v.fecha, v.precio*v.cantidad as venta_total from henry_checkpoint_m3.venta v;

select dense_rank() over (partition by v.fecha order by precio*cantidad desc) as rank_ventas, v.fecha, v.precio*v.cantidad as venta_total from henry_checkpoint_m3.venta v;

