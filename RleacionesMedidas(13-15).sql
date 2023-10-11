--¿Cuál es el municipio que tiene su cabecera municipal más alejada del centroide del municipio?

create table S13 as (
with p12 as(
select st_distance(c.geom, st_centroid(m.geom)) distancia, * from cabeceras c, municipios m
where m.gid= c.gid)
select * from p12 where distancia = (select max(distancia) from p12))


select * from S13



--¿Cuál es el río más largo que NO cruza algún departamento? (Asuma que los río no están fragmentados)

create temporary table S13 as(
with p13 as(
select st_crosses(r.geom, l.geom), r.gid id from rios_colombia r, limites l
where st_crosses(r.geom, l.geom)
)
select st_length(geom) Distancia, * from rios_colombia where gid not in (select id from p13))


with p13_1 as(
select gid, sum(Distancia) distancia from S13
group by gid)
select * from rios_colombia where st_length(geom)=(select max(distancia) from S13)



--Hay municipios que tienen el mismo nombre, pero que quedan en departamentos diferentes. 
--Muestre los municipios junto con el departamento cuyos nombres de municipios 
--son iguales y que sean los más cercanos entre sí, 
--en comparación con la distancia entre los otros municipios que también tienen nombres iguales.
create temporary table S10 as(




create table C15 as 
with consulta_15 as
(select m.nom_depart, m.gid, m.nom_munici, m.geom as muni_geom, d.geom as 
dpt_geom
from limites as d, municipios as m 
where st_contains(d.geom, m.geom))
select consulta_15_1.nom_depart, consulta_15_1.nom_munici , 
consulta_15_2.nom_depart as nombre_dpt2, consulta_15_2.nom_munici as 
nombre_mun2,
st_distance(consulta_15_1.muni_geom, consulta_15_2.muni_geom) as distancia,
consulta_15_1.dpt_geom,consulta_15_1.muni_geom,
consulta_15_2.dpt_geom as dpt_geom2, consulta_15_2.muni_geom as 
muni_geom2
from consulta_15 as consulta_15_1, consulta_15 as consulta_15_2
where consulta_15_1.nom_munici=consulta_15_2.nom_munici and 
consulta_15_1.gid > consulta_15_2.gid 
order by st_distance(consulta_15_1.muni_geom, consulta_15_2.muni_geom) asc 
limit 1


select * from C15;

