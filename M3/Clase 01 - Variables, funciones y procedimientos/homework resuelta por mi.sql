use adventureworks;

-- 1. Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en esa fecha.
drop procedure if exists ordenes_por_fecha;
DELIMITER $$
CREATE PROCEDURE ordenes_por_fecha(in p_fecha date)
BEGIN
    select count(*)
    from salesorderheader
    where date(OrderDate) = p_fecha
    ;
END $$

DELIMITER ;

call ordenes_por_fecha('2002-01-01');

-- 2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.

drop function if exists calcular_valor_nominal;
delimiter $$
create function calcular_valor_nominal(precio decimal(15,3), margen decimal(10,2)) returns decimal(15,3)
deterministic
begin
declare v_nominal_calculado decimal(15,3);
set @margen_bruto = precio*margen;
return @margen_bruto;
end $$

delimiter ;

select calcular_valor_nominal(100.5, 1.2);

/*
3. Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, 
si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. 
Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.
*/
select name, listprice, calcular_valor_nominal(Standardcost, 1.2) as listprice_after_nominal, listprice - calcular_valor_nominal(Standardcost, 1.2) as diferencia
from product
order by name;

/*
4. Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, y muestre un listado con los Id de los diez 
Clientes que más costo de transporte tienen entre esas fechas (campo Freight).
*/
drop procedure if exists ids_mayor_costo_transporte;
delimiter $$
create procedure ids_mayor_costo_transporte(in p_fecha_desde date, in p_fecha_hasta date)
begin
select customerid, sum(freight) as costo_total
from salesorderheader
where date(orderdate) between p_fecha_desde and p_fecha_hasta
group by customerid
order by costo_total desc
;
end $$
delimiter ;

call ids_mayor_costo_transporte('2002-01-01','2002-01-31');

-- 5. Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.
create table shipmethod_dup (
ShipMethodID int NOT NULL AUTO_INCREMENT,
  Name_dup varchar(50) NOT NULL,
  ShipBase double NOT NULL DEFAULT '0',
  ShipRate double NOT NULL DEFAULT '0',
  rowguid varbinary(16) DEFAULT NULL,
  ModifiedDate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ShipMethodID)
);

insert into shipmethod_dup 
(select ShipMethodID,name,shipbase,shiprate,rowguid,modifieddate from shipmethod);

select * from shipmethod_dup;
drop procedure if exists insert_shipmethod;

delimiter $$
create procedure insert_shipmethod(in Name_dup varchar(50), in ShipBase double,
  in ShipRate double)
begin
insert into shipmethod_dup(name_dup,shipbase,shiprate,modifieddate) values (Name_dup,ShipBase,ShipRate,now());
end $$

delimiter ;

call insert_shipmethod('Prueba', 1.5, 3.5);
