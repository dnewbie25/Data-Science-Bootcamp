select * from henry.cohorte;
-- 2.	No se sabe con certeza el lanzamiento de las cohortes N° 1245 y N° 1246, se solicita que las elimine de la tabla.
select * from henry.cohorte WHERE codigo like '%1245' or codigo like '%1246';
delete from henry.cohorte where idCohorte in (1245, 1246);
-- 3.	Se ha decidido retrasar el comienzo de la cohorte N°1243, por lo que la nueva fecha de inicio será el 16/05. Se le solicita modificar la fecha de inicio de esos alumnos.
update henry.cohorte set fecha_inicio = '2022-05-16' where idCohorte = 1243;
-- 4.	El alumno N° 165 solicito el cambio de su Apellido por “Ramirez”. 
select * from henry.alumnos where idAlumno = 165;
update alumnos set apellido = 'Ramirez' where idAlumno = 165;
-- 5.	El área de Learning le solicita un listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso.
select idAlumno, cedula, nombre, apellido, fecha_ingreso, cohorte from henry.alumnos where cohorte = 1243;

-- 6.	Como parte de un programa de actualización, el área de People le solicita un listado de los instructores que dictan la carrera de Full Stack Developer.
select * from henry.instructores inner join cohorte on idInstructor=instructor where codigo like 'FT%';

-- 7. Se desea saber que alumnos formaron parte de la cohorte N° 1235. Elabore un listado.
-- 8. Del listado anterior se desea saber quienes ingresaron en el año 2019.
select * from henry.alumnos where cohorte = 1235 and fecha_ingreso between '2019-01-01' and '2019-12-31';

-- 9. La siguiente consulta permite acceder a datos de otras tablas y devolver un listado con la carrera a la cual pertenece cada alumno:

SELECT alumnos.nombre, apellido, fecha_nacimiento, carrera.nombre
FROM alumnos
INNER JOIN cohorte
ON cohorte=idCohorte
INNER JOIN carrera
ON carrera = idCarrera;