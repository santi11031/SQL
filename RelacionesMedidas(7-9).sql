--Determine cuáles son las cabeceras municipales que se encuentran más alejadas entre
--sí, y cuáles son los más cercanos entre sí.


create temporary table p7 as(
	select st_distance(c1.geom, c2.geom) as Distancia, c1.codigo as Cod1, c2.codigo as Cod2,
	c1.nombre as Nombre1, c2.nombre as Nombre2, c1.geom as geom1, c2.geom as geom2
	from cabeceras c1, cabeceras c2)
	
drop table p7;
select * from p7
where Distancia = (select max(Distancia) from p7);

select * from p7
where Distancia = (select min(Distancia) from p7 where Distancia <> 0);

--Determine cuáles son las cabeceras municipales que se encuentran más alejadas entre
--sí, y cuáles son los más cercanos entre sí en un mismo departamento.


With C8 as (
select d.nombre_dpt as Nombre_departamento, c1.nombre as Nombre_Cabecera_1, c2.nombre as Nombre_Cabecera_2,
ST_Distance(c1.geom,c2.geom) as distancia, c1.geom as c1_geom , c2.geom as c2_geom
from cabeceras as c1, cabeceras as c2, limites as d
where c1.gid>c2.gid and st_within(c1.geom,d.geom) and st_within(c2.geom,d.geom))
select Nombre_departamento, Nombre_Cabecera_1, Nombre_Cabecera_2, distancia, c1_geom, c2_geom from C8
where distancia=(select max(distancia)from C8) or distancia=(select min(distancia)from C8)


--Cuáles con los departamentos con los que limita NN


Create  temporary table C9 as(
select nombre_dpt, geom from limites
where st_touches(geom, (select geom from limites where nombre_dpt ilike '%N%N')))

select * from C9










