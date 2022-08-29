USE MASTER
GO
-- DROP DATABASE Carpinteria
-- GO
CREATE DATABASE Carpinteria
GO
USE Carpinteria
GO
CREATE TABLE Pedidos(
    ID BIGINT NOT NULL PRIMARY KEY IDENTITY (1, 1),
    IDCliente INT NOT NULL,
    IDProducto INT NOT NULL,
    Cantidad SMALLINT NOT NULL CHECK(Cantidad > 0),
    FechaSolicitud DATE NOT NULL,
    FechaFinalizacion DATE NULL,
    Costo MONEY NOT NULL CHECK(Costo >= 0),
    Pagado BIT NOT NULL DEFAULT(0),
    Estado BIT NOT NULL DEFAULT(1)
)
GO
CREATE TABLE Clientes(
    ID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Apellidos VARCHAR(50) not null,
    Nombres VARCHAR(50) NOT NULL,
    Mail VARCHAR(200) NULL,
    Telefono VARCHAR(15) NULL,
    Celular VARCHAR(15) NULL,
    RegistroWeb BIT NOT NULL,
    Estado BIT NOT NULL DEFAULT(1)
)
GO
CREATE TABLE Productos(
    ID INT NOT NULL PRIMARY KEY IDENTITY (1, 1),
    IDCategoria INT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    DiasConstruccion TINYINT NOT NULL CHECK (DiasConstruccion > 0),
    Costo MONEY NOT NULL,
    Precio MONEY NOT NULL,
    PrecioVentaMayorista MONEY NULL,
    CantidadMayorista TINYINT NULL CHECK (CantidadMayorista > 0),
    Estado BIT NOT NULL DEFAULT(0)
)
GO
CREATE TABLE Categorias(
    ID INT NOT NULL PRIMARY KEY IDENTITY (1, 1),
    Nombre VARCHAR(100) NOT NULL
)
GO
CREATE TABLE Colaboradores(
    Legajo INT NOT NULL PRIMARY KEY,
    Apellidos VARCHAR(50) NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    ModalidadTrabajo CHAR NOT NULL CHECK (ModalidadTrabajo in ('F', 'P')),
    Sueldo MONEY NOT NULL,
    FechaNacimiento DATE NOT NULL,
    AñoIngreso SMALLINT NOT NULL CHECK (AñoIngreso > 1990)
)
GO
ALTER TABLE Productos
ADD CONSTRAINT CHK_Precios CHECK(PrecioVentaMayorista < Precio)
GO
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Clientes FOREIGN KEY (IDCliente)
REFERENCES Clientes(ID)
GO
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Productos FOREIGN KEY (IDProducto)
REFERENCES Productos(ID)
GO
ALTER TABLE Productos
ADD CONSTRAINT FK_Categoria FOREIGN KEY (IDCategoria)
REFERENCES Categorias(ID)