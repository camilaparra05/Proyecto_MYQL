
use los_ambientales;

-- FUNCIONES
-- 1 -- obtener el número total de parques
delimiter $$
create function total_parques() 
returns int
deterministic
begin
    declare total int;
    select count(*) into total from parque;
    return total;
end $$
delimiter ;

-- 2 obtener el número total de áreas en un parque
delimiter $$
create function total_areas_parque(p_id_parque int) 
returns int
deterministic
begin
    declare total int;
    select count(*) into total from area where id_parque = p_id_parque;
    return total;
end $$
delimiter ;

-- 3 calcular la superficie total de un parque
delimiter $$
create function superficie_total_parque(p_id_parque int) 
returns decimal(10,2)
deterministic
begin
    declare total decimal(10,2);
    select sum(extension) into total from area where id_parque = p_id_parque;
    return ifnull(total, 0);
end $$
delimiter ;

-- 4 contar el número de especies en un área
delimiter $$
create function total_especies_area(p_id_area int) 
returns int
deterministic
begin
    declare total int;
    select count(*) into total from especie where id_area = p_id_area;
    return total;
end $$
delimiter ;

-- 5  calcular el promedio de visitantes a un parque
delimiter $$
create function promedio_visitantes_parque(p_id_parque int) 
returns decimal(10,2)
deterministic
begin
    declare promedio decimal(10,2);
    select avg(cantidad_visitantes) into promedio from visita where id_parque = p_id_parque;
    return ifnull(promedio, 0);
end $$
delimiter ;

-- 6 obtener el nombre del parque con más visitas
delimiter $$
create function parque_mas_visitado() 
returns varchar(150)
deterministic
begin
    declare nombre_parque varchar(150);
    select p.nombre into nombre_parque 
    from parque p
    join visita v on p.id_parque = v.id_parque
    group by p.id_parque
    order by sum(v.cantidad_visitantes) desc
    limit 1;
    return nombre_parque;
end $$
delimiter ;

-- 7  calcular la densidad de especies en un área
delimiter $$
create function densidad_especies_area(p_id_area int) 
returns decimal(10,2)
deterministic
begin
    declare total_especies int;
    declare total_extension decimal(10,2);
    declare densidad decimal(10,2);
    
    select count(*) into total_especies from especie where id_area = p_id_area;
    select extension into total_extension from area where id_area = p_id_area;
    
    if total_extension > 0 then
        set densidad = total_especies / total_extension;
    else
        set densidad = 0;
    end if;
    
    return densidad;
end $$
delimiter ;

-- 8  ranking de parques según especies y visitantes
delimiter $$
create function ranking_parques() 
returns text
deterministic
begin
    declare ranking text;
    
    select group_concat(p.nombre order by (count(e.id_especie) + sum(v.cantidad_visitantes)) desc separator ', ')
    into ranking
    from parque p
    left join area a on p.id_parque = a.id_parque
    left join especie e on a.id_area = e.id_area
    left join visita v on p.id_parque = v.id_parque
    group by p.id_parque;
    
    return ranking;
end $$
delimiter ;

-- 9  obtener el total de parques con más de cierta cantidad de áreas
delimiter $$
create function parques_con_muchas_areas(p_min_areas int) 
returns int
deterministic
begin
    declare total int;
    select count(*) into total 
    from parque p
    join area a on p.id_parque = a.id_parque
    group by p.id_parque
    having count(a.id_area) >= p_min_areas;
    return total;
end $$
delimiter ;

-- 10  calcular el total de visitas en un área específica
delimiter $$
create function total_visitas_area(p_id_area int) 
returns int
deterministic
begin
    declare total int;
    select sum(v.cantidad_visitantes) into total
    from visita v
    join parque p on v.id_parque = p.id_parque
    join area a on p.id_parque = a.id_parque
    where a.id_area = p_id_area;
    return ifnull(total, 0);
end $$
delimiter ;

-- 11 verificar si un área pertenece a un parque específico
delimiter $$
create function area_pertenece_parque(p_id_area int, p_id_parque int) 
returns boolean
deterministic
begin
    declare existe boolean;
    select count(*) > 0 into existe 
    from area 
    where id_area = p_id_area and id_parque = p_id_parque;
    return existe;
end $$
delimiter ;

-- 12 obtener el nombre del área más grande en un parque
delimiter $$
create function area_mas_grande_parque(p_id_parque int) 
returns varchar(150)
deterministic
begin
    declare nombre_area varchar(150);
    select nombre into nombre_area
    from area 
    where id_parque = p_id_parque
    order by extension desc
    limit 1;
    return nombre_area;
end $$
delimiter ;

-- 13  obtener el porcentaje de áreas protegidas en relación a la superficie total
delimiter $$
create function porcentaje_areas_protegidas() 
returns decimal(5,2)
deterministic
begin
    declare total_superficie decimal(10,2);
    declare total_protegida decimal(10,2);
    declare porcentaje decimal(5,2);
    
    select sum(superficie_total) into total_superficie from parque;
    select sum(extension) into total_protegida from area;
    
    if total_superficie > 0 then
        set porcentaje = (total_protegida / total_superficie) * 100;
    else
        set porcentaje = 0;
    end if;
    
    return porcentaje;
end $$
delimiter ;

-- 14 contar el número de parques con especies en peligro
delimiter $$
create function parques_con_especies_peligro() 
returns int
deterministic
begin
    declare total int;
    select count(distinct p.id_parque) into total
    from parque p
    join area a on p.id_parque = a.id_parque
    join especie e on a.id_area = e.id_area
    where e.tipo = 'peligro';
    return total;
end $$
delimiter ;

-- 15 calcular el área promedio de todas las áreas registradas
delimiter $$
create function area_promedio() 
returns decimal(10,2)
deterministic
begin
    declare promedio decimal(10,2);
    select avg(extension) into promedio from area;
    return ifnull(promedio, 0);
end $$
delimiter ;

-- 16 contar la cantidad de especies únicas en todos los parques
delimiter $$
create function total_especies_unicas() 
returns int
deterministic
begin
    declare total int;
    select count(distinct nombre_cientifico) into total from especie;
    return total;
end $$
delimiter ;

-- 17 calcular el porcentaje de parques visitados en un año determinado
delimiter $$
create function porcentaje_parques_visitados(p_anio int) 
returns decimal(5,2)
deterministic
begin
    declare total_parques int;
    declare visitados int;
    declare porcentaje decimal(5,2);
    
    select count(*) into total_parques from parque;
    select count(distinct id_parque) into visitados from visita where year(fecha) = p_anio;
    
    if total_parques > 0 then
        set porcentaje = (visitados / total_parques) * 100;
    else
        set porcentaje = 0;
    end if;
    
    return porcentaje;
end $$
delimiter ;

-- 18 determinar el parque con mejor conservación (Alta Complejidad)
delimiter $$
create function parque_mejor_conservacion() 
returns varchar(150)
deterministic
begin
    declare mejor_parque varchar(150);
    
    select p.nombre into mejor_parque
    from parque p
    left join area a on p.id_parque = a.id_parque
    left join especie e on a.id_area = e.id_area
    left join visita v on p.id_parque = v.id_parque
    group by p.id_parque
    order by 
        (count(case when e.tipo = 'peligro' then 1 end) * -1) + 
        (p.superficie_total * 2) + 
        sum(v.cantidad_visitantes) desc
    limit 1;
    
    return mejor_parque;
end $$
delimiter ;

-- 19 Retornar el número de proyectos que están en estado activo dentro de un parque determinado.
delimiter $$
create function total_proyectos_activos(p_id_parque int) 
returns int
deterministic
begin
    declare total int;
    select count(*) into total
    from proyecto
    where id_parque = p_id_parque and estado = 'activo';
    return total;
end $$
delimiter ;

-- 20  Calcular el costo total de todos los proyectos asociados a un parque en particular.
delimiter $$
create function costo_total_proyectos(p_id_parque int) 
returns decimal(10,2)
deterministic
begin
    declare total_costos decimal(10,2);
    select sum(costo) into total_costos
    from proyecto
    where id_parque = p_id_parque;
    return ifnull(total_costos, 0);
end $$
delimiter ;

-- 21  hacer una funcion que Obtiene la cantidad de especies registradas en un área determinada, filtradas por tipo de especie (ejemplo: mamíferos, aves, en peligro, etc.).
delimiter $$
create function inventario_especies(p_id_area int, p_tipo varchar(100)) 
returns int
deterministic
begin
    declare total int;
    select count(*) into total
    from especie
    where id_area = p_id_area and tipo = p_tipo;
    return total;
end $$
delimiter ;

-- 22  Devuelve la superficie total de todos los parques que pertenecen a un departamento específico.
delimiter $$
create function superficie_total_departamento(p_id_departamento int) 
returns decimal(10,2)
deterministic
begin
    declare total_superficie decimal(10,2);
    select sum(p.superficie_total) into total_superficie
    from parque p
    where p.id_departamento = p_id_departamento;
    return ifnull(total_superficie, 0);
end $$
delimiter ;