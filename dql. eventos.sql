
use los_ambientales;
-- eventos
-- 1. Actualizar el inventario de especies cada día

delimiter $$

create event actualizar_inventario_especies
on schedule every 1 day
do
begin
    update especie 
    set numero_inventario = numero_inventario * 0.98;
end $$

delimiter ;
-- 2 Generar un reporte semanal de visitas

delimiter $$

create event reporte_semanal_visitas
on schedule every 1 week
do
begin
    insert into visitante (fecha_reporte, total_visitas)
    select curdate(), sum(cantidad_visitantes) from visita;
end $$

delimiter ;
-- 3. Eliminar registros de visitantes antiguos (hace más de 5 años)

delimiter $$

create event limpiar_visitantes_antiguos
on schedule every 1 month
do
begin
    delete from visitante where fecha_ultima_visita < date_sub(curdate(), interval 5 year);
end $$

delimiter ;
-- 4. Notificación mensual de especies en peligro (Alta Complejidad)

delimiter $$

create event alerta_especies_peligro
on schedule every 1 month
do
begin
    insert into especie (fecha_alerta, mensaje)
    select curdate(), concat('La especie ', nombre_cientifico, ' está en peligro con solo ', numero_inventario, ' individuos.')
    from especie
    where numero_inventario < 50;
end $$

delimiter ;
-- 5. Revisión de personal con sueldos menores al mínimo cada 6 meses

delimiter $$

create event revisar_sueldos_personal
on schedule every 6 month
do
begin
    update personal
    set sueldo = sueldo * 1.10
    where sueldo < 1000;
end $$

delimiter ;
-- 6. Registro diario del número total de especies

delimiter $$

create event registrar_total_especies
on schedule every 1 day
do
begin
    insert into especies (fecha, total_especies)
    select curdate(), count(*) from especie;
end $$

delimiter ;
-- 7. Aumentar en 5% la capacidad de alojamientos en temporada alta

delimiter $$

create event aumentar_capacidad_alojamientos
on schedule every 1 year
starts '2025-06-01'
ends '2025-08-31'
do
begin
    update alojamiento
    set capacidad = capacidad * 1.05;
end $$

delimiter ;

select * from visitante;


-- 10. Registrar cada semana la cantidad de personal activo

delimiter $$

create event registrar_personal_activo
on schedule every 1 week
do
begin
    insert into persona (fecha)
    select curdate(), count(*) from personal;
end $$

delimiter ;

-- 11. Cerrar automáticamente alojamientos sin uso en 2 años

delimiter $$

create event cerrar_alojamientos_inactivos
on schedule every 1 year
do
begin
    update alojamiento
    set estado = 'CERRADO'
    where id_alojamiento not in (select distinct id_alojamiento from reserva where fecha_reserva > date_sub(curdate(), interval 2 year));
end $$

delimiter ;
-- 12. Ajustar presupuestos de proyectos en base a inflación (Alta Complejidad)

delimiter $$

create event ajustar_presupuesto_proyectos
on schedule every 1 year
do
begin
    update proyecto_investigacion
    set presupuesto = presupuesto * 1.03;
end $$

delimiter ;

-- 13. Registrar el número de alojamientos ocupados cada mes

delimiter $$

create event reporte_alojamientos_ocupados
on schedule every 1 month
do
begin
    insert into alojamiento (fecha, total_ocupados)
    select curdate(), count(*) from reserva where estado = 'OCUPADO';
end $$

delimiter ;

-- 14 Cada mes, se genera un informe con el número total de visitantes por parque.

delimiter $$

create event informe_mensual_visitantes
on schedule every 1 month
do
begin
    insert into visitantes (id_parque, mes, anio, total_visitantes)
    select v.id_parque, month(v.fecha), year(v.fecha), sum(v.cantidad_visitantes)
    from visita v
    group by v.id_parque, month(v.fecha), year(v.fecha);
end $$

delimiter ;

-- 15 cada 3 meses, se revisan las especies y aquellas con menos de 50 individuos se marcan como "en peligro".

delimiter $$

create event actualizar_especies_peligro
on schedule every 3 month
do
begin
    update especie
    set estado = 'en peligro'
    where numero_inventario < 50;
end $$

delimiter ;

-- 16 diariamente, se revisa si algún parque ha superado su capacidad de visitantes. Si es así, se genera una alerta.

delimiter $$

create event alerta_sobrecupo_parques
on schedule every 1 day
do
begin
    insert into visitante (tipo, mensaje, fecha)
    select 'sobrecupo', 
           concat('el parque ', p.nombre, ' superó su capacidad de visitantes en el día ', v.fecha), 
           now()
    from visita v
    join parque p on v.id_parque = p.id_parque
    where v.cantidad_visitantes > p.capacidad_maxima;
end $$

delimiter ;

-- 17 Cada 6 meses, se eliminan los registros de la tabla de visitas que tengan más de un año de antigüedad.
delimiter $$


create event limpiar_logs_antiguos
on schedule every 6 month
do
begin
    delete from visita where fecha < date_sub(now(), interval 1 year);
end $$

delimiter ;

-- 18 Cada año, se incrementa en un 5% el sueldo del personal encargado de la conservación.

delimiter $$

create event actualizar_sueldo_conservacion
on schedule every 1 year
do
begin
    update personal
    set sueldo = sueldo * 1.05
    where tipo = '003'; -- personal de conservación
end $$

delimiter ;

-- 19 cada ano los proyectos de investigación que siguen activos reciben un incremento del 10% en su presupuesto.

delimiter $$

create event ajustar_presupuesto
on schedule every 1 year
do
begin
    update proyecto_investigacion
    set presupuesto = presupuesto * 1.10
    where estado = 'activo';
end $$

delimiter ;