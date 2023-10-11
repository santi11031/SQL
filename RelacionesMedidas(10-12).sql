--10. Por cuáles municipios pasa el río más grande

create temporary table p10 as( with s1 as(
	select st_length(geom) as distancia, gid as ID, nombre as Nombre, geom  from rios_colombia
	group by gid, nombre)select * from s1 where distancia=(select max(distancia) from s1))
	
create table S10 as(	
	select st_crosses(p10.geom, m.geom), m.gid as ID, m.nom_munici, m.geom as Geom1, p10.geom as Geom2 from municipios m, p10
	where st_crosses(p10.geom, m.geom))
	
	
select * from S10;

	
-- 11.Cuál es el departamento que contiene más de los municipios por donde pasa el río más
--grande

with p11 as(
	select  nom_depart, count(*) conteo from municipios 
	join S10 on S10.ID = municipios.gid
	group by nom_depart)
select * from p11 where conteo=(select max(conteo) from p11)

--12.Muestre un listado con el nombre del departamento, el porcentaje del área que ocupa en
--relación al país, y la distancia entre la capital del departamento y Bogotá.

select st_area(geom) as AreaDpto,gid, nombre_dpt,
st_area(geom)*100/(select sum(st_area(geom)) from limites) as Porcentaje,
(st_distance(st_centroid(l.geom), (select st_centroid(geom) from limites where nombre_dpt ilike 'BOGOTÁ')))
as Distancia_C, geom
from limites l;


