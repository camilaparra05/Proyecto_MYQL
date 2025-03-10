use los_ambientales;

\

DELIMITER $$

-- 1. evitar eliminación de un parque si tiene áreas registradas
create table areas_registradass (
    id_area int auto_increment primary key,
    id_parque int,
    nombre varchar(100)
) $$

create trigger prevenir_eliminacion_parque
before delete on parque
for each row
begin
    if exists (select 1 from areas_registradass where id_parque = old.id_parque) then
        signal sqlstate '45000' 
        set message_text = 'no se puede eliminar un parque con áreas registradas.';
    end if;
end $$

DELIMITER ;

-- 2. registrar cambios en áreas
DELIMITER $$
create table cambios_areas (
    id_cambio int auto_increment primary key,
    id_area int,
    accion varchar(50),
    fecha timestamp default current_timestamp
) $$

create trigger registrar_cambios_areas
after update on areas
for each row
begin
    insert into cambios_areas (id_area, accion, fecha)
    values (old.id_area, 'modificación', now());
end $$

DELIMITER ;

-- 3. registrar eliminación de áreas

DELIMITER $$
create table eliminacion_area (
    id_eliminacion int auto_increment primary key,
    id_area int,
    accion varchar(50),
    fecha timestamp default current_timestamp
);

create trigger registrar_eliminacion_area
after delete on area
for each row
begin
    insert into eliminacion_area (id_area, accion, fecha)
    values (old.id_area, 'eliminación', now());
end;
DELIMITER ;
-- 4. evitar más de 500 especies en un área
DELIMITER $$
create table especies_area (
    id_registro int auto_increment primary key,
    id_area int,
    cantidad_especies int,
    fecha timestamp default current_timestamp
);

create trigger limitar_especies_por_area
before insert on especie
for each row
begin
    if (select count(*) from especie where id_area = new.id_area) >= 500 then
        signal sqlstate '45000' 
        set message_text = 'el área ha alcanzado el límite de especies registradas.';
    end if;
end;
DELIMITER ;
-- 5. evitar número negativo de visitantes en una visita
DELIMITER $$
create table visitas (
    id_visita int auto_increment primary key,
    cantidad_visitantes int,
    fecha timestamp default current_timestamp
);

create trigger prevenir_cantidad_negativa_visitas
before insert on visita
for each row
begin
    if new.cantidad_visitantes < 0 then
        signal sqlstate '45000' 
        set message_text = 'la cantidad de visitantes no puede ser negativa.';
    end if;
end;
DELIMITER ;
-- 6. registrar cambios salariales del personal
DELIMITER $$
create table sueldos (
    id_sueldo int auto_increment primary key,
    id_personal int,
    sueldo_anterior decimal(10,2),
    nuevo_sueldo decimal(10,2),
    fecha_modificacion timestamp default current_timestamp
);

create trigger registrar_cambio_sueldo
after update on personal
for each row
begin
    if old.sueldo <> new.sueldo then
        insert into sueldos (id_personal, sueldo_anterior, nuevo_sueldo, fecha_modificacion)
        values (old.id_personal, old.sueldo, new.sueldo, now());
    end if;
end;
DELIMITER ;
-- 7. evitar visitas con fecha futura
DELIMITER $$
create table fechas_visitas (
    id_registro int auto_increment primary key,
    id_visi
    ta int,
    fecha_visita date,
    fecha_registro timestamp default current_timestamp
);

create trigger prevenir_fecha_futura_visita
before insert on visita
for each row
begin
    if new.fecha > now() then
        signal sqlstate '45000' 
        set message_text = 'no se puede registrar una visita con fecha futura.';
    end if;
end;

DELIMITER ;
-- 8. no modificar nombre científico de una especie
DELIMITER $$
create table nombres_especies (
    id_registro int auto_increment primary key,
    id_especie int,
    nombre_anterior varchar(255),
    nombre_nuevo varchar(255),
    fecha timestamp default current_timestamp
);

create trigger prevenir_actualizacion_nombre_especie
before update on especie
for each row
begin
    if old.nombre_cientifico <> new.nombre_cientifico then
        signal sqlstate '45000' 
        set message_text = 'no se puede modificar el nombre científico de una especie.';
    end if;
end;

DELIMITER ;
-- 9. eliminar especies si se elimina un área
DELIMITER $$
create table eliminacion_especies (
    id_registro int auto_increment primary key,
    id_area int,
    fecha timestamp default current_timestamp
);

create trigger eliminar_especies_al_eliminar_area
after delete on area
for each row
begin
    delete from especie where id_area = old.id_area;
end;

DELIMITER ;
-- 10. evitar que un área tenga una extensión mayor a su parque
DELIMITER $$
create table extension_areas (
    id_registro int auto_increment primary key,
    id_area int,
    extension decimal(10,2),
    fecha timestamp default current_timestamp
);

create trigger restringir_extension_area
before insert on area
for each row
begin
    if new.extension > (select superficie_total from parque where id_parque = new.id_parque) then
        signal sqlstate '45000' 
        set message_text = 'el área no puede ser más grande que el parque.';
    end if;
end;

DELIMITER ;
-- 11. registrar creación de especies
DELIMITER $$
create table creacion_especies (
    id_registro int auto_increment primary key,
    id_especie int,
    nombre_cientifico varchar(255),
    fecha_registro timestamp default current_timestamp
);

create trigger registro_creacion_especie
after insert on especie
for each row
begin
    insert into creacion_especies (id_especie, nombre_cientifico, fecha_registro)
    values (new.id_especie, new.nombre_cientifico, now());
end;

DELIMITER ;
