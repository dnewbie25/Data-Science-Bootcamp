use adventureworks;
select * from salesorderheader where contactid=378;
-- 1) Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5"
SELECT distinct
    c.contactid,
    c.firstname,
    c.lastname,
    soh.salesorderid,
    soh.orderdate,
    sod.productid,
    psc.productsubcategoryid,
    psc.name
FROM
    contact c
        JOIN
    salesorderheader soh ON c.contactid = soh.contactid
        JOIN
    salesorderdetail sod ON soh.salesorderid = sod.salesorderid
        JOIN
    product p ON sod.productid = p.productid
        JOIN
    productsubcategory psc ON p.productsubcategoryid = psc.productsubcategoryid
WHERE
    psc.name = 'Mountain Bikes'
        AND YEAR(soh.orderdate) BETWEEN 2000 AND 2003
group by c.contactid;

SELECT c.LastName, c.FirstName, SUM(d.OrderQty) as Cantidad
FROM salesorderheader h
	JOIN contact c
		ON (h.ContactID = c.ContactID)
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN product p
		ON (d.ProductID = p.ProductID)
	JOIN productsubcategory s
		ON (p.ProductSubcategoryID = s.ProductSubcategoryID)
WHERE YEAR(h.OrderDate) BETWEEN 2002 AND 2003
AND s.Name = 'Mountain Bikes'
GROUP BY c.LastName, c.FirstName
ORDER BY Cantidad DESC;

-- 2. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.<br>

-- 3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.<br>

-- 4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().

