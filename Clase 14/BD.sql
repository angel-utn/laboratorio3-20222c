Create Database ModeloExamenIntegrador
go
Use ModeloExamenIntegrador
go
Create Table Personas(
	DNI varchar(10) not null primary key,
	Apellidos varchar(50) not null,
	Nombres varchar(50) not null,
	DeclaracionGanancias money not null check (DeclaracionGanancias >= 0)
)
go
Create Table Bancos(
	ID int not null primary key,
	Nombre varchar(50) not null,
	Tipo char not null
)
go
Create Table Creditos(
	ID bigint not null primary key identity (1, 1),
	IDBanco int not null foreign key references Bancos(ID),
	DNI varchar(10) not null foreign key references Personas(DNI),
	Fecha date not null,
	Importe money not null check (Importe > 0),
	Plazo smallint not null check (Plazo > 0),
	Cancelado bit not null default(0)
)
go
-- Personas
Insert into Personas(DNI, Apellidos, Nombres, DeclaracionGanancias)
Values ('1111', 'Seinfeld', 'Jerry', 100000)
Insert into Personas(DNI, Apellidos, Nombres, DeclaracionGanancias)
Values ('2222', 'Benes', 'Elaine', 150000)
Insert into Personas(DNI, Apellidos, Nombres, DeclaracionGanancias)
Values ('3333', 'Costanza', 'George', 50000)
Insert into Personas(DNI, Apellidos, Nombres, DeclaracionGanancias)
Values ('4444', 'Kramer', 'Cosmo', 20000)

--Bancos
Insert into Bancos(ID, Nombre, Tipo)
Values (1, 'Klosterbank', '1')
Insert into Bancos(ID, Nombre, Tipo)
Values (2, 'Larabank', '2')
Insert into Bancos(ID, Nombre, Tipo)
Values (3, 'Banco De Amos', '1')
Insert into Bancos(ID, Nombre, Tipo)
Values (4, 'Banco Nomis', '1')

-- Creditos
set dateformat 'YMD'
Insert into Creditos(IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
Values (1, '1111', '2022/8/5', 250000, 5, 1)
Insert into Creditos(IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
Values (1, '1111', '2021/12/3', 50000, 3, 0)
Insert into Creditos(IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
Values (1, '1111', '2022/1/5', 25000, 5, 0)
Insert into Creditos(IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
Values (1, '2222', '2022/1/25', 225000, 15, 0)
Insert into Creditos(IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
Values (1, '3333', '2022/1/5', 10000, 10, 0)