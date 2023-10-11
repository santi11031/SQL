--2 .Muestra gráficamente en QGis, la información cargada en la base de datos
select * from colombia;

--3. Genere una nueva geometría a partir del polígono de Colombia, con el borde del polígono y despliéguela en QGis.

create table Bordes as 
select ST_Boundary(geom) from colombia;

select * from Bordes;

--4. Responda las siguientes preguntas mediante consultas sobre la información espacial en la base de datos (borde de Colombia):

--a. Tipo de dato de la geometría del borde e Colombia
select ST_GeometryType(st_boundary) from Bordes;

--b. ¿Es una geometría cerrada?
select ST_IsClosed(st_boundary) from Bordes;

--c. ¿Es una geometría válida?
select ST_IsValid(st_boundary) from Bordes;

--d. ¿De cuántos puntos está formada la geometría?
select ST_NPoints(st_boundary) from Bordes;

--e.¿Cuál es el SRID de la geometría?
select ST_SRID(st_boundary) from Bordes;