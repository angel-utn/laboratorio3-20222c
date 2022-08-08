Create Database ClaseDos
Go
Use ClaseDos
go
Create Table Empleados(
    ID Bigint not null primary key identity (1, 1),
    Apellido VARCHAR(100) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
	Genero CHAR NULL,
    IDArea smallint null
)
go
Alter Table Empleados
Add FechaNacimiento date null
go
CREATE TABLE Areas(
	ID SMALLINT NOT NULL,
	Nombre VARCHAR(40) NOT NULL,
	Presupuesto MONEY NOT NULL,
	EMail VARCHAR(120) NOT NULL UNIQUE
)
go
Alter Table Areas
Add Constraint PK_Areas Primary Key (ID)
go
Alter Table Areas
Add Constraint CHK_PresupuestoPositivo Check (Presupuesto > 0)
go
Alter Table Empleados
Add Constraint FK_Empleados_Areas Foreign key (IDArea)
references Areas(ID)
