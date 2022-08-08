Create Database Ejemplo_PK_Compuesta
go
Use Ejemplo_PK_Compuesta
go
Create Table Examenes(
    Legajo varchar(10) not null,
    IDMateria varchar(5) not null,
    Fecha date not null,
    Nota decimal(4,2) null
)
go
Alter Table Examenes
Add Constraint PK_Examenes Primary Key (Legajo, IDMateria, Fecha)
go
Alter Table Examenes
Add Constraint CHK_Nota Check (Nota >= 0 AND Nota <= 10)
