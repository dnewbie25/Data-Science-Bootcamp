use henry;
-- 1. ¿Cuantas carreas tiene Henry?
select COUNT(nombre) from carrera;

-- 2. ¿Cuantos alumnos hay en total?
SELECT COUNT(idAlumno) from alumnos;
-- 3. ¿Cuantos alumnos tiene cada cohorte?
select cohorte, count(idAlumno) from alumnos group by cohorte;
-- 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.
select concat(nombre, " ", apellido) as nombre_completo, fecha_ingreso from alumnos order by fecha_ingreso DESC;
-- 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?
SELECT CONCAT(NOMBRE, " ", APELLIDO) as nombre_completo, fecha_ingreso, idAlumno from alumnos order by fecha_ingreso ASC LIMIT 1;
-- 6. ¿En que fecha ingreso?
select fecha_ingreso, nombre from alumnos where idAlumno = 2;
-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
SELECT CONCAT(NOMBRE, " ", APELLIDO) as nombre_completo, fecha_ingreso, idAlumno from alumnos order by fecha_ingreso DESC LIMIT 1;

-- 8. La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.
SELECT year(fecha_ingreso), count(idAlumno) from alumnos group by year(fecha_ingreso);
-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
select weekofyear(fecha_ingreso) as semana, count(idAlumno), year(fecha_ingreso) as year from alumnos group by weekofyear(fecha_ingreso), year(fecha_ingreso) order by year asc,semana asc;
-- 10. ¿En que años ingresaron más de 20 alumnos?
select year(fecha_ingreso), count(idAlumno) from alumnos group by year(fecha_ingreso) having count(idAlumno) >= 20;
-- 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().
select timestampdiff(YEAR,fecha_nacimiento, curdate()) as age, date_add(fecha_nacimiento,INTERVAL timestampdiff(YEAR,fecha_nacimiento, curdate()) YEAR) as fecha_hoy, fecha_nacimiento from instructores;
-- 12. Cálcula:<br>
            -- La edad de cada alumno.<br>
create view edad_alumnos as select timestampdiff(YEAR, fecha_nacimiento, curdate()) as age, concat(nombre, " ", apellido) as nombre from alumnos;
select * from edad_alumnos;
            -- La edad promedio de los alumnos de henry.<br>
select avg(age) from edad_alumnos;
            -- La edad promedio de los alumnos de cada cohorte.<br>
create view edad_alumnos2 as select timestampdiff(year, fecha_nacimiento, curdate()) as age, nombre, cohorte, fecha_nacimiento from alumnos;
select * from edad_alumnos2;
select cohorte, avg(age) from edad_alumnos2 group by cohorte;
-- 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.
select age, nombre from edad_alumnos2 where age > (select avg(age) from edad_alumnos2);