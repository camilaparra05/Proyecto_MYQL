use los_ambientales;
-- consultas
-- 1.Consultar el número total de parques por departamento
SELECT d.nombre AS departamento, COUNT(dp.id_parque) AS total_parques
FROM departamento d
LEFT JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY d.nombre
ORDER BY total_parques DESC;

-- 2.Obtener la superficie total protegida por departamento
SELECT d.nombre AS departamento, SUM(p.superficie_total) AS superficie_protegida
FROM departamento d
LEFT JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
LEFT JOIN parque p ON dp.id_parque = p.id_parque
GROUP BY d.nombre
ORDER BY superficie_protegida DESC;

-- 3 Listar todas las especies y cuántos individuos hay en total por tipo
SELECT e.tipo, SUM(ae.cantidad) AS total_individuos
FROM especie e
JOIN area_especie ae ON e.id_especie = ae.id_especie
GROUP BY e.tipo;

-- 4 Consultar cuántos visitantes han reservado alojamiento
SELECT COUNT(DISTINCT id_visitante) AS total_visitantes_hospedados
FROM estancia;

-- 5 Obtener la cantidad de personal por tipo
SELECT tp.descripcion AS tipo_personal, COUNT(p.id_personal) AS total_personal
FROM tipo_personal tp
LEFT JOIN personal p ON tp.id_tipo_personal = p.id_tipo_personal
GROUP BY tp.descripcion
ORDER BY total_personal DESC;

-- 6 Mostrar el promedio de sueldos por tipo de personal
SELECT tp.descripcion AS tipo_personal, ROUND(AVG(p.sueldo), 2) AS sueldo_promedio
FROM tipo_personal tp
JOIN personal p ON tp.id_tipo_personal = p.id_tipo_personal
GROUP BY tp.descripcion
ORDER BY sueldo_promedio DESC;

-- 7Listar los proyectos de investigación con su presupuesto ordenado de mayor a menor
SELECT nombre, presupuesto, estado
FROM proyecto_investigacion
ORDER BY presupuesto DESC;

-- 8 Mostrar los alojamientos ocupados actualmente
SELECT a.id_alojamiento, a.tipo, a.capacidad, e.id_visitante, e.fecha_ingreso, e.fecha_salida
FROM alojamiento a
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
WHERE CURDATE() BETWEEN e.fecha_ingreso AND e.fecha_salida;

-- 9  Mostrar cuántos visitantes hay por nacionalidad
SELECT nacionalidad, COUNT(*) AS total_visitantes
FROM visitante
GROUP BY nacionalidad
ORDER BY total_visitantes DESC;

-- 10 Listar los proyectos en los que trabaja cada investigador
SELECT p.nombre AS investigador, pi.nombre AS proyecto
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
JOIN proyecto_investigacion pi ON ip.id_proyecto = pi.id_proyecto
WHERE p.id_tipo_personal = 4
ORDER BY p.nombre;

-- 11 Listar los 5 parques más grandes
SELECT nombre, superficie_total
FROM parque
ORDER BY superficie_total DESC
LIMIT 5;
-- 12 Mostrar los 5 alojamientos con mayor capacidad
SELECT id_alojamiento, tipo, capacidad
FROM alojamiento
ORDER BY capacidad DESC
LIMIT 5;

-- 13 Consultar el total de proyectos por estado (en curso, finalizado, cancelado)
SELECT estado, COUNT(*) AS total_proyectos
FROM proyecto_investigacion
GROUP BY estado;

-- 14 Listar los investigadores con la mayor cantidad de proyectos asignados
 SELECT p.nombre, COUNT(ip.id_proyecto) AS total_proyectos
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
WHERE p.id_tipo_personal = 4
GROUP BY p.nombre
ORDER BY total_proyectos DESC;

-- 15 Mostrar el visitante con más estancias en el sistema
SELECT v.nombre, COUNT(e.id_estancia) AS total_estancias
FROM visitante v
JOIN estancia e ON v.id_visitante = e.id_visitante
GROUP BY v.nombre
ORDER BY total_estancias DESC LIMIT 1;

-- 16 Obtener el parque con más áreas registradas
SELECT p.nombre AS parque, COUNT(a.id_area) AS total_areas
FROM parque p
JOIN area a ON p.id_parque = a.id_parque
GROUP BY p.nombre
ORDER BY total_areas DESC LIMIT 1;

-- 17  Consultar la cantidad de especies por tipo en cada parque
SELECT p.nombre AS parque, e.tipo, COUNT(DISTINCT e.id_especie) AS total_especies
FROM parque p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
GROUP BY p.nombre, e.tipo
ORDER BY p.nombre, e.tipo;

-- 18 Obtener el total recaudado en estancias por parque
SELECT p.nombre AS parque, SUM(e.costo_total) AS total_recaudado
FROM parque p
JOIN alojamiento a ON p.id_parque = a.id_parque
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY p.nombre
ORDER BY total_recaudado DESC;

-- 19 XListar los departamentos con más visitantes hospedados
SELECT d.nombre AS departamento, COUNT(e.id_visitante) AS total_visitantes
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
JOIN parque p ON dp.id_parque = p.id_parque
JOIN alojamiento a ON p.id_parque = a.id_parque
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY d.nombre
ORDER BY total_visitantes DESC;

-- 20 Mostrar las especies estudiadas en más proyectos
SELECT e.nombre_cientifico, COUNT(ep.id_proyecto) AS total_proyectos
FROM especie e
JOIN especie_proyecto ep ON e.id_especie = ep.id_especie
GROUP BY e.nombre_cientifico
ORDER BY total_proyectos DESC
LIMIT 5;


-- 21 Listar los visitantes que han gastado más en estancias
SELECT v.nombre, SUM(e.costo_total) AS total_gastado
FROM visitante v
JOIN estancia e ON v.id_visitante = e.id_visitante
GROUP BY v.nombre
ORDER BY total_gastado DESC
LIMIT 5;

-- 22  Mostrar los proyectos con el mayor número de especies involucradas
SELECT p.nombre, COUNT(ep.id_especie) AS total_especies
FROM proyecto_investigacion p
JOIN especie_proyecto ep ON p.id_proyecto = ep.id_proyecto
GROUP BY p.nombre
ORDER BY total_especies DESC
LIMIT 5;

-- 23 Obtener el promedio de duración de los proyectos (en días)
SELECT ROUND(AVG(DATEDIFF(fecha_fin, fecha_inicio)), 2) AS promedio_duracion_dias
FROM proyecto_investigacion;

-- 24 Listar los aslojamientos mas ocupados (por numero de estancia)
SELECT a.tipo, COUNT(e.id_estancia) AS total_estancias
FROM alojamiento a
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY a.tipo
ORDER BY total_estancias DESC
LIMIT 5;

-- 25 Mostrar los 3 departamentos con mayor superficie protegida

SELECT d.nombre AS departamento, SUM(p.superficie_total) AS superficie_protegida
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
JOIN parque p ON dp.id_parque = p.id_parque
GROUP BY d.nombre
ORDER BY superficie_protegida DESC
LIMIT 3;

-- 26  Consultar qué tipo de personal tiene el sueldo promedio más alto
SELECT tp.descripcion, ROUND(AVG(p.sueldo), 2) AS sueldo_promedio
FROM tipo_personal tp
JOIN personal p ON tp.id_tipo_personal = p.id_tipo_personal
GROUP BY tp.descripcion
ORDER BY sueldo_promedio DESC
LIMIT 1;

-- 27 Listar los investigadores que trabajan en más de un proyecto
SELECT p.nombre, COUNT(ip.id_proyecto) AS total_proyectos
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
WHERE p.id_tipo_personal = 4
GROUP BY p.nombre
HAVING total_proyectos > 1
ORDER BY total_proyectos DESC;

-- 28 consultar el total de visitantes que han usado cada tipo de alojamiento
SELECT a.tipo, COUNT(DISTINCT e.id_visitante) AS total_visitantes
FROM alojamiento a
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY a.tipo
ORDER BY total_visitantes DESC;

-- 29  Mostrar los 5 parques con más visitantes hospedados

SELECT p.nombre, COUNT(e.id_visitante) AS total_visitantes
FROM parque p
JOIN alojamiento a ON p.id_parque = a.id_parque
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY p.nombre
ORDER BY total_visitantes DESC
LIMIT 5;

-- 30  Calcular el total de presupuesto asignado a proyectos en curso

SELECT SUM(p.presupuesto) AS presupuesto_total
FROM proyecto_investigacion p
WHERE p.estado = 'en curso';


-- 31  Mostrar los proyectos con más especies investigadas y su presupuesto
SELECT p.nombre AS proyecto, COUNT(ep.id_especie) AS total_especies, p.presupuesto
FROM proyecto_investigacion p
JOIN especie_proyecto ep ON p.id_proyecto = ep.id_proyecto
GROUP BY p.nombre, p.presupuesto
ORDER BY total_especies DESC, p.presupuesto DESC
LIMIT 5;

-- 32 Listar los investigadores que han trabajado en el mayor número de proyectos

SELECT p.nombre AS investigador, COUNT(ip.id_proyecto) AS total_proyectos
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
WHERE p.id_tipo_personal = 4
GROUP BY p.nombre
ORDER BY total_proyectos DESC
LIMIT 5;

-- 33 Mostrar los parques con mayor cantidad de investigaciones activas
SELECT pa.nombre AS parque, COUNT(ip.id_proyecto) AS total_proyectos
FROM parque pa
JOIN departamento_parque dp ON pa.id_parque = dp.id_parque
JOIN investigador_proyecto ip ON dp.id_parque = ip.id_proyecto
GROUP BY pa.nombre
ORDER BY total_proyectos DESC
LIMIT 5;

-- 34 Determinar qué tipo de especies son más investigadas
SELECT e.tipo, COUNT(ep.id_proyecto) AS total_proyectos
FROM especie e
JOIN especie_proyecto ep ON e.id_especie = ep.id_especie
GROUP BY e.tipo
ORDER BY total_proyectos DESC;

-- 35 Mostrar el promedio de duración de los proyectos finalizados
SELECT ROUND(AVG(DATEDIFF(fecha_fin, fecha_inicio)), 2) AS promedio_dias
FROM proyecto_investigacion
WHERE estado = 'finalizado';

-- 36 Consultar cuál es el investigador con mayor presupuesto en proyectos
SELECT p.nombre AS investigador, SUM(pi.presupuesto) AS presupuesto_total
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
JOIN proyecto_investigacion pi ON ip.id_proyecto = pi.id_proyecto
WHERE p.id_tipo_personal = 4
GROUP BY p.nombre
ORDER BY presupuesto_total DESC
LIMIT 1;

-- 37  Mostrar qué especies están siendo estudiadas en más de un proyecto
SELECT e.nombre_cientifico, COUNT(ep.id_proyecto) AS total_proyectos
FROM especie e
JOIN especie_proyecto ep ON e.id_especie = ep.id_especie
GROUP BY e.nombre_cientifico
HAVING total_proyectos > 1
ORDER BY total_proyectos DESC;

-- 38 Mostrar qué especies no han sido investigadas en ningún proyecto
SELECT e.nombre_cientifico
FROM especie e
LEFT JOIN especie_proyecto ep ON e.id_especie = ep.id_especie
WHERE ep.id_proyecto IS NULL;

-- 39 Identificar el tipo de personal más involucrado en proyectos de investigación
SELECT tp.descripcion AS tipo_personal, COUNT(ip.id_proyecto) AS total_proyectos
FROM tipo_personal tp
JOIN personal p ON tp.id_tipo_personal = p.id_tipo_personal
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
GROUP BY tp.descripcion
ORDER BY total_proyectos DESC;

-- 40 Consultar el porcentaje de proyectos en curso, finalizados y cancelados
SELECT estado, COUNT(*) AS total_proyectos, 
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM proyecto_investigacion)), 2) AS porcentaje
FROM proyecto_investigacion
GROUP BY estado;

-- 41 ¿Cuál es el parque más investigado y qué porcentaje de los proyectos están en él?
SELECT p.nombre AS parque, COUNT(ip.id_proyecto) AS total_proyectos,
       ROUND((COUNT(ip.id_proyecto) * 100.0 / (SELECT COUNT(*) FROM proyecto_investigacion)), 2) AS porcentaje_total
FROM parque p
JOIN departamento_parque dp ON p.id_parque = dp.id_parque
JOIN investigador_proyecto ip ON dp.id_parque = ip.id_proyecto
GROUP BY p.nombre
ORDER BY total_proyectos DESC
LIMIT 1;

-- 42  ¿Qué investigador ha trabajado con la mayor diversidad de especies?
SELECT p.nombre AS investigador, COUNT(DISTINCT ep.id_especie) AS especies_diferentes
FROM personal p
JOIN investigador_proyecto ip ON p.id_personal = ip.id_personal
JOIN especie_proyecto ep ON ip.id_proyecto = ep.id_proyecto
WHERE p.id_tipo_personal = 4
GROUP BY p.nombre
ORDER BY especies_diferentes DESC
LIMIT 1;

-- 43  ¿Hay una relación entre los visitantes y los proyectos de investigación en un parque?
SELECT p.nombre AS parque, COUNT(DISTINCT e.id_visitante) AS total_visitantes, COUNT(DISTINCT ip.id_proyecto) AS total_proyectos
FROM parque p
LEFT JOIN alojamiento a ON p.id_parque = a.id_parque
LEFT JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
LEFT JOIN departamento_parque dp ON p.id_parque = dp.id_parque
LEFT JOIN investigador_proyecto ip ON dp.id_parque = ip.id_proyecto
GROUP BY p.nombre
ORDER BY total_proyectos DESC, total_visitantes DESC;

-- 44 ¿Qué especies tienen más impacto en proyectos de alto presupuesto?
SELECT e.nombre_cientifico, SUM(pi.presupuesto) AS total_presupuesto
FROM especie e
JOIN especie_proyecto ep ON e.id_especie = ep.id_especie
JOIN proyecto_investigacion pi ON ep.id_proyecto = pi.id_proyecto
GROUP BY e.nombre_cientifico
ORDER BY total_presupuesto DESC
LIMIT 5;

-- 45 ¿Qué parque tiene la mayor biodiversidad en especies registradas?
SELECT p.nombre AS parque, COUNT(DISTINCT e.id_especie) AS total_especies
FROM parque p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
GROUP BY p.nombre
ORDER BY total_especies DESC
LIMIT 1;

-- 46  ¿Cuál es el mejor mes para alojamientos según ingresos de estancias?
SELECT MONTH(e.fecha_ingreso) AS mes, SUM(e.costo_total) AS ingresos
FROM estancia e
GROUP BY mes
ORDER BY ingresos DESC
LIMIT 1;

-- 47 ¿Cuánto cuesta en promedio alojarse en cada tipo de alojamiento?
SELECT a.tipo, ROUND(AVG(e.costo_total), 2) AS costo_promedio
FROM alojamiento a
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY a.tipo
ORDER BY costo_promedio DESC;

-- 48 ¿Qué porcentaje del personal es investigador?
SELECT 
    (SELECT COUNT(*) FROM personal WHERE id_tipo_personal = 4) * 100.0 / COUNT(*) AS porcentaje_investigadores
FROM personal;

-- 49  ¿Cuáles son los parques con más ingresos por alojamiento y qué porcentaje representan?
SELECT p.nombre AS parque, SUM(e.costo_total) AS ingresos,
       ROUND((SUM(e.costo_total) * 100.0 / (SELECT SUM(costo_total) FROM estancia)), 2) AS porcentaje_total
FROM parque p
JOIN alojamiento a ON p.id_parque = a.id_parque
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
GROUP BY p.nombre
ORDER BY ingresos DESC
LIMIT 5;

-- 50 ¿Cuántos días en promedio se hospedan los visitantes según su nacionalidad?
SELECT v.nacionalidad, ROUND(AVG(DATEDIFF(e.fecha_salida, e.fecha_ingreso)), 2) AS promedio_estancia
FROM visitante v
JOIN estancia e ON v.id_visitante = e.id_visitante
GROUP BY v.nacionalidad
ORDER BY promedio_estancia DESC;

-- 51 obtener la cantidad total de áreas por parque
select p.nombre as parque, count(a.id_area) as total_areas
from parque p
left join area a on p.id_parque = a.id_parque
group by p.nombre
order by total_areas desc;

-- 52 listar los parques que tienen al menos una especie en peligro de extinción
select distinct p.nombre as parque
from parque p
join area a on p.id_parque = a.id_parque
join area_especie ae on a.id_area = ae.id_area
join especie e on ae.id_especie = e.id_especie
where e.estado_conservacion = 'en peligro';

-- 53 obtener el parque con el mayor número de visitantes en el último año
select p.nombre as parque, count(e.id_visitante) as total_visitantes
from parque p
join alojamiento a on p.id_parque = a.id_parque
join estancia e on a.id_alojamiento = e.id_alojamiento
where e.fecha_ingreso >= date_sub(curdate(), interval 1 year)
group by p.nombre
order by total_visitantes desc
limit 1;

-- 54 consultar el mes con más proyectos de investigación iniciados
select month(fecha_inicio) as mes, count(*) as total_proyectos
from proyecto_investigacion
group by mes
order by total_proyectos desc
limit 1;

-- 55 obtener el total de ingresos por parque en los últimos seis meses
select p.nombre as parque, sum(e.costo_total) as ingresos_totales
from parque p
join alojamiento a on p.id_parque = a.id_parque
join estancia e on a.id_alojamiento = e.id_alojamiento
where e.fecha_ingreso >= date_sub(curdate(), interval 6 month)
group by p.nombre
order by ingresos_totales desc;

-- 56 listar los parques con más alojamientos de tipo "cabaña"
select p.nombre as parque, count(a.id_alojamiento) as total_cabanas
from parque p
join alojamiento a on p.id_parque = a.id_parque
where a.tipo = 'cabaña'
group by p.nombre
order by total_cabanas desc;

-- 57 consultar los investigadores que han trabajado en al menos tres proyectos
select p.nombre as investigador, count(ip.id_proyecto) as total_proyectos
from personal p
join investigador_proyecto ip on p.id_personal = ip.id_personal
where p.id_tipo_personal = 4
group by p.nombre
having total_proyectos >= 3
order by total_proyectos desc;

-- 58 obtener el porcentaje de visitantes nacionales e internacionales
select 
    (select count(*) from visitante where nacionalidad = 'nacional') * 100.0 / count(*) as porcentaje_nacionales,
    (select count(*) from visitante where nacionalidad <> 'nacional') * 100.0 / count(*) as porcentaje_internacionales
from visitante;


-- 60 consultar la cantidad de especies por estado de conservación
select e.estado_conservacion, count(*) as total_especies
from especie e
order by total_especies desc;

-- 61 mostrar los 10 visitantes con más estancias en los últimos dos años
select v.nombre, count(e.id_estancia) as total_estancias
from visitante v
join estancia e on v.id_visitante = e.id_visitante
where e.fecha_ingreso >= date_sub(curdate(), interval 2 year)
group by v.nombre
order by total_estancias desc
limit 10;

-- 62 identificar las áreas con más especies registradas
select a.nombre as area, count(ae.id_especie) as total_especies
from area a
join area_especie ae on a.id_area = ae.id_area
group by a.nombre
order by total_especies desc
limit 5;

-- 63 calcular la edad promedio de los visitantes
select round(avg(year(curdate()) - year(fecha_nacimiento)), 2) as edad_promedio
from visitante;

-- 64 listar los tipos de alojamiento que han generado más ingresos
select a.tipo, sum(e.costo_total) as ingresos
from alojamiento a
join estancia e on a.id_alojamiento = e.id_alojamiento
group by a.tipo
order by ingresos desc;

-- 65 obtener los 3 parques con más alojamientos disponibles actualmente
select p.nombre, count(a.id_alojamiento) as alojamientos_disponibles
from parque p
join alojamiento a on p.id_parque = a.id_parque
left join estancia e on a.id_alojamiento = e.id_alojamiento
where e.id_estancia is null
group by p.nombre
order by alojamientos_disponibles desc
limit 3;

-- 66 consultar el promedio de tiempo que un investigador trabaja en proyectos
select round(avg(datediff(fecha_fin, fecha_inicio)), 2) as promedio_duracion_dias
from investigador_proyecto ip
join proyecto_investigacion pi on ip.id_proyecto = pi.id_proyecto;


-- 68 listar los visitantes que han estado en más de un parque
select v.nombre, count(distinct p.id_parque) as total_parques
from visitante v
join estancia e on v.id_visitante = e.id_visitante
join alojamiento a on e.id_alojamiento = a.id_alojamiento
join parque p on a.id_parque = p.id_parque
group by v.nombre
having total_parques > 1
order by total_parques desc;

-- 69 mostrar el porcentaje de especies registradas por parque
select p.nombre as parque, 
       count(distinct ae.id_especie) * 100.0 / (select count(*) from especie) as porcentaje_especies
from parque p
join area a on p.id_parque = a.id_parque
join area_especie ae on a.id_area = ae.id_area
group by p.nombre
order by porcentaje_especies desc;


-- 71 listar los proyectos de investigación en curso con más de un investigador asignado
select p.nombre as proyecto, count(ip.id_personal) as total_investigadores
from proyecto_investigacion p
join investigador_proyecto ip on p.id_proyecto = ip.id_proyecto
where p.fecha_fin is null
group by p.nombre
having total_investigadores > 1
order by total_investigadores desc;

-- 72 obtener la cantidad de visitantes por parque en el último trimestre
select p.nombre as parque, count(e.id_visitante) as total_visitantes
from parque p
join alojamiento a on p.id_parque = a.id_parque
join estancia e on a.id_alojamiento = e.id_alojamiento
where e.fecha_ingreso >= date_sub(curdate(), interval 3 month)
group by p.nombre
order by total_visitantes desc;

-- 73 identificar las especies con menos registros en las áreas naturales
select e.nombre as especie, count(ae.id_area) as total_areas
from especie e
left join area_especie ae on e.id_especie = ae.id_especie
order by total_areas asc
limit 10;

-- 74 consultar los investigadores con proyectos activos y su fecha de inicio más antigua
select p.nombre as investigador, min(pi.fecha_inicio) as primer_proyecto
from personal p
join investigador_proyecto ip on p.id_personal = ip.id_personal
join proyecto_investigacion pi on ip.id_proyecto = pi.id_proyecto
where pi.fecha_fin is null
group by p.nombre
order by primer_proyecto asc;

-- 75 obtener los parques con más reservas de alojamiento para los próximos tres meses
select p.nombre as parque, count(e.id_estancia) as total_reservas
from parque p
join alojamiento a on p.id_parque = a.id_parque
join estancia e on a.id_alojamiento = e.id_alojamiento
where e.fecha_ingreso between curdate() and date_add(curdate(), interval 3 month)
group by p.nombre
order by total_reservas desc;



-- 78 obtener el promedio de duración de estancia de los visitantes
select round(avg(datediff(e.fecha_salida, e.fecha_ingreso)), 2) as duracion_promedio
from estancia e
where e.fecha_salida is not null;

-- 79 listar las especies más observadas en los parques
select e.nombre as especie, count(o.id_observacion) as total_observaciones
from especie e
join observacion o on e.id_especie = o.id_especie
group by e.nombre
order by total_observaciones desc
limit 10;

-- 80 identificar los investigadores con más publicaciones científicas
select p.nombre as investigador, count(pub.id_publicacion) as total_publicaciones
from personal p
join publicacion pub on p.id_personal = pub.id_autor
group by p.nombre
order by total_publicaciones desc
limit 5;

-- 81 consultar el parque con mayor porcentaje de ocupación de alojamiento
select p.nombre as parque, 
       round(count(e.id_estancia) * 100.0 / count(a.id_alojamiento), 2) as porcentaje_ocupacion
from parque p
join alojamiento a on p.id_parque = a.id_parque
left join estancia e on a.id_alojamiento = e.id_alojamiento
group by p.nombre
order by porcentaje_ocupacion desc
limit 1;

-- 85 listar las áreas naturales con el menor número de especies registradas
select a.nombre as area, count(ae.id_especie) as total_especies
from area a
left join area_especie ae on a.id_area = ae.id_area
group by a.nombre
order by total_especies asc
limit 5;





