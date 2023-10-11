--Seleccionar el río más largo sobre el territorio Colombiano. Muestre gráficamente la
--información de la respuesta del rio, sobre los departamentos.

select max(ST_LENGTH(geom)), nombre, geom from rios_colombia
group by geom, nombre
order by ST_LENGTH(geom) desc limit 1;


--Cuál es el departamento con mayor número de municipios. Grafique el departamento y
--sus municipios

create temporary table p5 as(
	select count(nom_munici) Conteo, nom_depart from municipios
	group by nom_depart)
				
select * from p5
where Conteo =(select max(Conteo) from p5);

with p5 as(
	select count(st_contains(l.geom, m.geom)) as conteo, l.gid as id from municipios m, limites l
	where st_contains(l.geom, m.geom)
	group by l.gid)
select conteo, id from p5
where conteo=(select max(conteo) from p5)

--Determine los municipios que contienen más de una cabecera municipal, y los que no
--tienen cabeceras municipales


create temporary table p6 as (
	select count(ST_contains(m.geom, c.geom)) as Numero_Cabeceras, m.gid
	from municipios m, cabeceras c
	where ST_Contains(m.geom,c.geom)
	group by m.gid)


create  temporary table CabecerasMunicipales as (
	select * from p6
	natural join municipios
	where Numero_Cabeceras >1)
	


create temporary table NoCabecerasMunicipales as(
	select * from municipios
	where nom_munici not in (select nom_munici from p6))
	
	
	
	


--10. Por cuáles municipios pasa el río más grande

create temporary table p10 as( with s1 as(
	select st_length(geom) as distancia, gid as ID, nombre as Nombre, geom  from rios_colombia
	group by gid, nombre)select * from s1 where distancia=(select max(distancia) from s1))
	
create table S10 as(	
	select st_crosses(p10.geom, m.geom), m.gid as ID, m.nom_munici, m.geom as Geom1, p10.geom as Geom2 from municipios m, p10
	where st_crosses(p10.geom, m.geom))


	
	
	
-- Cuál es el departamento que contiene más de los municipios por donde pasa el río más
--grande

with p11 as(
	select  nom_depart, count(*) conteo from municipios 
	join S10 on S10.ID = municipios.gid
	group by nom_depart)
select * from p11 where conteo=(select max(conteo) from p11)



--Muestre un listado con el nombre del departamento, el porcentaje del área que ocupa en
--relación al país, y la distancia entre la capital del departamento y Bogotá.


select st_area(geom) as AreaDpto,gid, nombre_dpt,
st_area(geom)*100/(select sum(st_area(geom)) from limites) as Porcentaje,
(st_distance(st_centroid(l.geom), (select st_centroid(geom) from limites where nombre_dpt ilike 'BOGOTÁ')))
as Distancia_C, geom
from limites l;



	


