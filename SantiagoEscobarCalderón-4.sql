create extension postgis;
--Creación de la tabla de líneas

create table lineas(
	id int primary key,
	nom varchar(5));
	
select AddGeometryColumn('lineas','geom','3116','LINESTRING',2);

--Creación de la tabla de poligonos

create table poligonos (
	id int primary key,
	nom varchar(5),
	geom geometry(polygon,3116));	
	
--Inserción de los datos

insert into lineas
	values (1, 'L_1',ST_GeomFromText('LINESTRING(40 20, 110 65)', 3116));
	
insert into lineas
	values (2, 'L_2',ST_GeomFromText('LINESTRING(30 10, 30 50)', 3116));
	
insert into poligonos  values (4, 'P_D',
ST_GeomFromText('POLYGON((0 0,0 80,140 80,140 0,0 0))', 3116));

insert into poligonos  values (3, 'P_C',
ST_GeomFromText('POLYGON((100 10,80 10,80 50, 100 50, 100 10))', 3116));

insert into poligonos  values (2, 'P_B',
ST_GeomFromText('POLYGON((130 10,60 10, 60 60, 130 60, 130 10))', 3116));

insert into poligonos  values (1, 'P_A',
ST_GeomFromText('POLYGON((120 50,20 50, 20 70, 120 70, 120 50))', 3116));


select * from poligonos;