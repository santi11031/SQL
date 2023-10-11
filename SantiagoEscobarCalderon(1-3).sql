--Determinar el departamento más grande y el más pequeño de todos.
create temporary table P2 as(
	
	select max(ST_Area(geom)) as maximo from public."Departamental"

)


select * from public."Departamental" D
where ST_Area(geom) = (select maximo from P2)


create temporary table P2_1 as(
	
	select min(ST_Area(geom)) as minimo from public."Departamental"

)


select ST_Area(geom), * from public."Departamental" 
where ST_Area(geom) = (select minimo from P2_1);


--Cuál es el departamento que tiene la mayor diferencia entre el área real y el área oficial



select  max((ST_Area(geom)-area_ofici)/1000000) as diferencia, nombre_dpt, geom from public."Departamental"
group by nombre_dpt, geom, area_ofici, geom
order by (ST_Area(geom)-area_ofici)/1000000 desc  limit 1;



-- Cuál es la distancia máxima y mínima entre los departamentos más pequeño y más grande

create temporary table MaxArea as(
	
select max(ST_Area(geom)) as maximo, geom from public."Departamental"
group by geom
order by geom desc limit 1)

create temporary table MinArea as(
	
select max(ST_Area(geom)) as minimo, geom from public."Departamental"
group by geom
order by geom asc limit 1)


select st_length(st_shortestline(
(select geom from MaxArea),
(select geom from MinArea))	
) as Minimo;


select st_length(st_longestline(
(select geom from MaxArea),
(select geom from MinArea))	
) as Masximo;


	

