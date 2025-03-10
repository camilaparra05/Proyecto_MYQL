
-- Creación de la base de datos
CREATE DATABASE los_ambientales;
USE los_ambientales;

-- Tabla Entidad Responsable
CREATE TABLE entidad_responsable (
    id_entidad_responsable INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    tipo ENUM('pública', 'privada', 'mixta') NOT NULL,
    contacto VARCHAR(100) NOT NULL
);

-- Tabla Departamento
CREATE TABLE departamento (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_entidad_responsable INT NOT NULL,
    FOREIGN KEY (id_entidad_responsable) REFERENCES entidad_responsable(id_entidad_responsable) ON DELETE CASCADE
);

-- Tabla Parque Natural
CREATE TABLE parque (
    id_parque INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha_declaracion DATE NOT NULL,
    superficie_total DECIMAL(10,2) NOT NULL
);

-- Relación Muchos a Muchos entre Departamento y Parque
CREATE TABLE departamento_parque (
    id_departamento INT NOT NULL,
    id_parque INT NOT NULL,
    PRIMARY KEY (id_departamento, id_parque),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE CASCADE,
    FOREIGN KEY (id_parque) REFERENCES parque(id_parque) ON DELETE CASCADE
);

-- Tabla Área
CREATE TABLE area (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    id_parque INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    extension DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_parque) REFERENCES parque(id_parque) ON DELETE CASCADE
);

-- Tabla Especie
CREATE TABLE especie (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cientifico VARCHAR(150) NOT NULL,
    nombre_vulgar VARCHAR(150) NOT NULL,
    tipo ENUM('vegetal', 'animal', 'mineral') NOT NULL
);

-- Relación Muchos a Muchos entre Área y Especie
CREATE TABLE area_especie (
    id_area INT NOT NULL,
    id_especie INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    PRIMARY KEY (id_area, id_especie),
    FOREIGN KEY (id_area) REFERENCES area(id_area) ON DELETE CASCADE,
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie) ON DELETE CASCADE
);

-- Tabla Tipo Personal
CREATE TABLE tipo_personal (
    id_tipo_personal INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

-- Tabla Personal
CREATE TABLE personal (
    id_personal INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    sueldo DECIMAL(10,2) NOT NULL CHECK (sueldo > 0),
    id_tipo_personal INT NOT NULL,
    id_parque INT NOT NULL,
    FOREIGN KEY (id_tipo_personal) REFERENCES tipo_personal(id_tipo_personal),
    FOREIGN KEY (id_parque) REFERENCES parque(id_parque) ON DELETE CASCADE
);

-- Tabla Vehículo (Solo para Personal de Vigilancia)
CREATE TABLE vehiculo (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_personal INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    placa VARCHAR(15) NOT NULL UNIQUE,
    FOREIGN KEY (id_personal) REFERENCES personal(id_personal) ON DELETE CASCADE
);

-- Tabla Proyecto de Investigación
CREATE TABLE proyecto_investigacion (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    presupuesto DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('en curso', 'finalizado', 'cancelado') DEFAULT 'en curso',
    CHECK (fecha_inicio < fecha_fin)
);

-- Relación Muchos a Muchos entre Investigador y Proyecto
CREATE TABLE investigador_proyecto (
    id_personal INT NOT NULL,
    id_proyecto INT NOT NULL,
    PRIMARY KEY (id_personal, id_proyecto),
    FOREIGN KEY (id_personal) REFERENCES personal(id_personal) ON DELETE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto_investigacion(id_proyecto) ON DELETE CASCADE
);

-- Relación Muchos a Muchos entre Especie y Proyecto
CREATE TABLE especie_proyecto (
    id_especie INT NOT NULL,
    id_proyecto INT NOT NULL,
    PRIMARY KEY (id_especie, id_proyecto),
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie) ON DELETE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto_investigacion(id_proyecto) ON DELETE CASCADE
);

-- Tabla Visitante
CREATE TABLE visitante (
    id_visitante INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT NOT NULL,
    profesion VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50) NOT NULL
);

-- Tabla Alojamiento
CREATE TABLE alojamiento (
    id_alojamiento INT AUTO_INCREMENT PRIMARY KEY,
    id_parque INT NOT NULL,
    tipo ENUM('cabaña', 'zona de camping', 'hostal', 'hotel') NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    disponibilidad ENUM('ocupado', 'libre') DEFAULT 'libre',
    FOREIGN KEY (id_parque) REFERENCES parque(id_parque) ON DELETE CASCADE
);

-- Tabla Estancia (Visitantes en Alojamiento)
CREATE TABLE estancia (
    id_estancia INT AUTO_INCREMENT PRIMARY KEY,
    id_visitante INT NOT NULL,
    id_alojamiento INT NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    costo_total DECIMAL(10,2) DEFAULT 0,
    CHECK (fecha_ingreso < fecha_salida),
    FOREIGN KEY (id_visitante) REFERENCES visitante(id_visitante) ON DELETE CASCADE,
    FOREIGN KEY (id_alojamiento) REFERENCES alojamiento(id_alojamiento) ON DELETE CASCADE
);


SHOW TABLES;






























