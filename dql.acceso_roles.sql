use los_ambientales;
--  CONTROL DE ACCESO Y ROLES

-- 1. CREAR USUARIOS Y ASIGNARLES ROLES
create user 'user_admin'@'%' identified by 'admin123';
create user 'user_gestor'@'%' identified by 'gestor123';
create user 'user_investigador'@'%' identified by 'invest123';
create user 'user_auditor'@'%' identified by 'auditor123';
create user 'user_visitantes'@'%' identified by 'visit123';

-- 2. CREAR ROLES
create role admin;
create role gestor_parques;
create role investigador;
create role auditor;
create role encargado_visitantes;

-- 3. ASIGNAR ROLES A LOS USUARIOS
grant admin to 'user_admin'@'%';
grant gestor_parques to 'user_gestor'@'%';
grant investigador to 'user_investigador'@'%';
grant auditor to 'user_auditor'@'%';
grant encargado_visitantes to 'user_visitantes'@'%';

-- 4. DEFINIR PERMISOS PARA CADA ROL

-- Administrador: acceso total
grant all privileges on *.* to admin with grant option;

-- Gestor de parques: gestión de parques, áreas y especies
grant select, insert, update, delete on parque to gestor_parques;
grant select, insert, update, delete on area to gestor_parques;
grant select, insert, update, delete on especie to gestor_parques;

-- Investigador: acceso a datos de proyectos y especies
grant select on proyecto to investigador;
grant select on especie to investigador;

-- Auditor: acceso a reportes financieros
grant select on reportes_financieros to auditor;

-- Encargado de visitantes: gestión de visitantes y alojamientos
grant select, insert, update, delete on visitante to encargado_visitantes;
grant select, insert, update, delete on alojamiento to encargado_visitantes;

-- 5. APLICAR CAMBIOS
flush privileges;
