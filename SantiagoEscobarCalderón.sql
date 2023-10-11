--Santiago Escobar Calderón
--Cod:20182025162
 
 set search_path="EstudioParcial";
 SHOW search_path;
 set search_path='EstudioParcial';
 
 
-- 1) Nombre de los estudiantes que perdieron asignaturas y no prestaron libros de la asignatura


CREATE OR REPLACE FUNCTION def(num1 float8, num2 float8, num3 float8)
RETURNS float
AS 
$$
SELECT coalesce(num1,0) *0.35 + coalesce(num2,0)*0.35 + coalesce(num3,0) *0.3;
$$
LANGUAGE sql;


create temporary table p1 as(
	select cod_e,cod_a, nom_a, def(n1,n2,n3) from inscribe
	natural join asignaturas
	where def(n1,n2,n3) <3)
	

create temporary table p1_ as (
	select * from libros
	natural join presta
	natural join referencia
	)
	
select * from p1_
right join p1 on p1.cod_a = p1_.cod_a
where p1_.cod_e is null

--2. Nombre de los profesores que tiene el mayor número de estudiantes que ve simultáneamente más 
--asignaturas con él


with p2 as(
	select id_p, nom_p ,cod_e, count(cod_a) as numero_asignaturas from profesores
	natural join inscribe
	group by id_p, cod_e,nom_p
	)
select id_p, nom_p, numero_asignaturas from p2
where numero_asignaturas=(select max(numero_asignaturas) from p2)


--3 Cual es la carrera con mayor porcentaje de éxito
--(asignaturas que pasa respecto a las asignaturas que pierde)

create temporary table EstudiantesAprobados as(
select id_carr,count(def(n1,n2,n3)) as Aprobados from inscribe
natural join estudiantes
natural join carreras
where def(n1,n2,n3)>=3
group by id_carr
)

drop table EstudiantesAprobados
drop table EstudiantesReprobados

create temporary table EstudiantesReprobados as(
select id_carr,count(def_final(n1,n2,n3)) as Reprobados from inscribe
natural join estudiantes
natural join carreras
where def(n1,n2,n3)<3
group by id_carr
)

select *, aprobados*100/(aprobados+coalesce(reprobados,0)) as porcentaje from EstudiantesAprobados EA
left join EstudiantesReprobados ER on EA.id_carr= ER.id_carr
where  aprobados*100/(aprobados+coalesce(reprobados,0)) =(select max(aprobados*100/(aprobados+coalesce(reprobados,0)))
from EstudiantesAprobados left join EstudiantesReprobados ER on EA.id_carr= ER.id_carr)
order by aprobados*100/(aprobados+coalesce(reprobados,0)) desc limit 2;

-- 4. Liste los estudiantes que son más exitosos (pasaron todas las asignaturas y tienen el mejor promedio)

with p4 as
(
	(with estudientes_aprobados as
	( 
		(select cod_e, nom_e, count(cod_e) from estudiantes natural join inscribe 
		where def(n1,n2,n3)>=3 group by cod_e, nom_e)
		intersect
		(select cod_e, nom_e, count(cod_e) from estudiantes natural join inscribe group by cod_e, nom_e)
	)
	select cod_e, nom_e from estudientes_aprobados)
	
	intersect

	(with mejor_promedio as
	(
		select cod_e, nom_e, avg(nota_def)::numeric(3,2) as promedio from 
			(select cod_e, nom_e, cod_a, 
		 	def(n1,n2,n3)  as nota_def 
			from estudiantes natural join inscribe)Tabla_1 group by cod_e, nom_e
	)
	select cod_e, nom_e from mejor_promedio
	where promedio=(select max(promedio) from mejor_promedio))
)
select cod_e, nom_e,id_carr,nom_carr from p4 natural join estudiantes natural join carreras 
 
	
	
--5. Liste los profesores que solo imparten asignaturas a estudiantes de una sola carrera, incluya el nombre
-- de la carrera a la lista



create temporary table p5 as(
	select cod_a, nom_p,count(distinct(cod_a)) from profesores
	natural join imparte
	natural join asignaturas
	group by nom_p, cod_a)
	
create temporary table p5_1 as(
	select cod_a, id_carr, count(cod_a) from estudiantes
	natural join inscribe
	natural join carreras
	group by cod_a, id_carr)


select nom_p, count(id_carr), id_carr from p5 
natural join p5_1
group by nom_p, id_carr
except
select distinct nom_p, count(id_carr), id_carr from p5
natural join p5_1
group by nom_p, id_carr
having count(id_carr)=1;








