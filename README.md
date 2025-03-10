# Los Ambientales 🌿

 Proyecto MYSQL

 
Desarrollado por: María Camila Parra Sierra

Los Ambientales es un sistema de gestión de parques naturales basado en MySQL. Su propósito es facilitar el registro, administración y análisis de datos relacionados con parques, especies, visitantes y alojamientos.

El sistema permite:
✔ Gestionar parques y sus áreas.
✔ Registrar y controlar especies.
✔ Administrar visitantes y reservas en alojamientos.
✔ Consultar estadísticas e informes.
✔ Automatizar tareas mediante procedimientos, funciones, triggers y eventos.

🖥 Requisitos del Sistema

Para ejecutar este proyecto necesitas:
✅ MySQL Server (versión recomendada: 8.0 o superior).
✅ Un editor de código compatible con SQL (como VS Code o DBeaver).

📂 Estructura del Proyecto
ddl.sql →(Creación de base de datos con tabls y relaciones)
dml.sql →(inserciones de datos)
dql_select.sql →(Consultas)
dql_procedimientos.sql →(procedimientos almacenados)
dql_funciones.sql →(funciones)
dql. triggers.sql →(triggers)
dql. eventos.sql →(eventos)
Readme.md
Diagrama.jpg →(Modelo de datos)


📊 Estructura de la Base de Datos

👥 Roles de Usuario y Permisos

Rol	Permisos
Administrador	:Acceso total a la base de datos.
Gestor de parques:	Administración de parques, áreas y especies.
Investigador	:Consulta de datos de especies y proyectos.
Auditor:	Acceso a reportes y estadísticas.
Encargado de visitantes	:Gestión de visitantes y alojamientos.
