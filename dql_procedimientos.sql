use los_ambientales;

-- Procedimientos

delimiter $$

-- 1. registrar un nuevo parque
create procedure registrar_parque(
    in nombre varchar(100),
    in fecha_declaracion date,
    in superficie_total decimal(10,2)
)
begin
    insert into parque (nombre, fecha_declaracion, superficie_total)
    values (nombre, fecha_declaracion, superficie_total);
end $$

-- 2. actualizar datos de un parque
create procedure actualizar_parque(
    in id_parque int,
    in nombre varchar(100),
    in fecha_declaracion date,
    in superficie_total decimal(10,2)
)
begin
    update parque
    set nombre = nombre, fecha_declaracion = fecha_declaracion, superficie_total = superficie_total
    where id_parque = id_parque;
end $$

-- 3. eliminar un parque (solo si no tiene áreas asociadas)
create procedure eliminar_parque(
    in id_parque int
)
begin
    if not exists (select 1 from area where id_parque = id_parque) then
        delete from parque where id_parque = id_parque;
    else
        signal sqlstate '45000' set message_text = 'no se puede eliminar el parque porque tiene áreas asociadas.';
    end if;
end $$

-- 4. registrar un área dentro de un parque
create procedure registrar_area(
    in id_parque int,
    in nombre varchar(100),
    in extension decimal(10,2)
)
begin
    insert into area (id_parque, nombre, extension)
    values (id_parque, nombre, extension);
end $$

-- 5. actualizar datos de un área
create procedure actualizar_area(
    in id_area int,
    in id_parque int,
    in nombre varchar(100),
    in extension decimal(10,2)
)
begin
    update area
    set id_parque = id_parque, nombre = nombre, extension = extension
    where id_area = id_area;
end $$

-- 6. registrar una nueva especie
create procedure registrar_especie(
    in nombre_cientifico varchar(100),
    in nombre_vulgar varchar(100),
    in tipo varchar(100)
)
begin
    insert into especie (nombre_cientifico, nombre_vulgar, tipo)
    values (nombre_cientifico, nombre_vulgar, tipo);
end $$

-- 7. actualizar datos de una especie
create procedure actualizar_especie(
    in id_especie int,
    in nombre_cientifico varchar(100),
    in nombre_vulgar varchar(100),
    in tipo varchar(100)
)
begin
    update especie
    set nombre_cientifico = nombre_cientifico, nombre_vulgar = nombre_vulgar, tipo = tipo
    where id_especie = id_especie;
end $$

-- 8. eliminar una especie
create procedure eliminar_especie(
    in id_especie int
)
begin
    delete from especie where id_especie = id_especie;
end $$

-- 9. obtener el número total de especies en un parque
create procedure total_especies_en_parque(
    in id_parque int,
    out total_especies int
)
begin
    select count(*) into total_especies
    from especie e
    join area a on e.id_area = a.id_area
    where a.id_parque = id_parque;
end $$

-- 10. registrar una nueva visita a un parque
create procedure registrar_visita(
    in id_parque int,
    in fecha date,
    in cantidad_visitantes int
)
begin
    insert into visita (id_parque, fecha, cantidad_visitantes)
    values (id_parque, fecha, cantidad_visitantes);
end $$

-- 11. obtener el total de visitas a un parque en un rango de fechas
create procedure total_visitas_parque(
    in id_parque int,
    in fecha_inicio date,
    in fecha_fin date,
    out total_visitas int
)
begin
    select sum(cantidad_visitantes) into total_visitas
    from visita
    where id_parque = id_parque and fecha between fecha_inicio and fecha_fin;
end $$

-- 12. obtener el parque con más visitas en un rango de fechas
create procedure parque_mas_visitado(
    in fecha_inicio date,
    in fecha_fin date,
    out id_parque int,
    out total_visitas int
)
begin
    select id_parque, sum(cantidad_visitantes) as total_visitas
    into id_parque, total_visitas
    from visita
    where fecha between fecha_inicio and fecha_fin
    group by id_parque
    order by total_visitas desc
    limit 1;
end $$

-- 13. redistribuir especies en áreas dentro de un parque
create procedure redistribuir_especies(
    in id_parque int
)
begin
    declare done int default 0;
    declare id_area int;
    declare id_especie int;
    declare cur cursor for select id_especie from especie where id_area in (select id_area from area where id_parque = id_parque);
    declare continue handler for not found set done = 1;
    open cur;
    redistribute_loop: loop
        fetch cur into id_especie;
        if done then leave redistribute_loop; end if;
        select id_area into id_area from area where id_parque = id_parque order by rand() limit 1;
        update especie set id_area = id_area where id_especie = id_especie;
    end loop;
    close cur;
end $$

-- 14. obtener todas las áreas de un parque
create procedure obtener_areas_parque(
    in id_parque int
)
begin
    select id_area, nombre, extension
    from area
    where id_parque = id_parque;
end $$

-- 15. contar la cantidad de especies por tipo en un parque
create procedure contar_especies_por_tipo(
    in id_parque int
)
begin
    select e.tipo, count(*) as cantidad
    from especie e
    join area a on e.id_area = a.id_area
    where a.id_parque = id_parque
    group by e.tipo;
end $$

-- 16. registrar una donación para un parque
create procedure registrar_donacion(
    in id_parque int,
    in monto decimal(10,2),
    in fecha date
)
begin
    insert into donacion (id_parque, monto, fecha)
    values (id_parque, monto, fecha);
end $$

-- 17. obtener la suma total de donaciones por parque
create procedure total_donaciones_parque()
begin
    select p.nombre as parque, sum(d.monto) as total_donaciones
    from parque p
    join donacion d on p.id_parque = d.id_parque
    group by p.nombre;
end $$

-- 18. obtener los parques más visitados en un año
create procedure parques_mas_visitados(
    in anio int
)
begin
    select p.nombre as parque, sum(v.cantidad_visitantes) as total_visitantes
    from parque p
    join visita v on p.id_parque = v.id_parque
    where year(v.fecha) = anio
    group by p.nombre
    order by total_visitantes desc
    limit 3;
end $$

-- 19. obtener las especies más comunes en todas las áreas
create procedure especies_mas_comunes()
begin
    select nombre_vulgar, count(*) as cantidad
    from especie
    group by nombre_vulgar
    order by cantidad desc
    limit 5;
end $$

-- 20. obtener la cantidad de visitas de un parque en un mes y año específico
create procedure visitas_por_mes(
    in id_parque int,
    in anio int,
    in mes int
)
begin
    select sum(cantidad_visitantes) as total_visitantes
    from visita
    where id_parque = id_parque 
          and year(fecha) = anio 
          and month(fecha) = mes;
end $$


delimiter ;
