-- Vistas y procedimientos almacenados

-- Vista de listado de películas con duración y categoría
Create View VW_Peliculas as
Select P.Nombre, 
Cast(P.Duracion/60 as varchar(2)) + ':' + right('00' + Cast(P.Duracion % 60 as varchar(2)), 2) as Duracion, 
CAT.Codigo as Categoria
From Peliculas P
Inner Join Categorias CAT ON CAT.ID = P.IDCategoria

-- Hacer un procedimiento almacenado que reciba un ID de cliente y liste todas las funciones a las que asistió. Incluyendo el nombre de la película, el horario, el nombre de la sala, el importe de la venta y el nombre de la categoría de la película.
Go

Create Procedure SP_FuncionesxIDCliente(
    @IDCliente int
)
as
Begin
    Declare @ExisteCliente bit
    
    -- Set @ExisteCliente = (Select Count(*) From Clientes Where ID = @IDCliente)
    Select @ExisteCliente = Count(*) From Clientes Where ID = @IDCliente

    If @ExisteCliente = 1 Begin
        Select  F.Horario, 
                P.Nombre,
                S.Nombre as Sala,
                V.Importe,
                CAT.Codigo as Categoria
        From Funciones F
        Inner Join Peliculas P ON P.ID = F.IDPelicula
        Inner Join Salas S ON S.ID = F.IDSala
        Inner Join Ventas V ON F.ID = V.IDFuncion
        Inner Join Categorias CAT ON CAT.ID = P.IDCategoria
        Where V.IDCliente = @IDCliente
    End
    Else Begin
        Print 'El cliente no existe'
    End
    
End

Exec SP_FuncionesxIDCliente @IDCliente=5

go

-- Hacer un procedimiento almacenado que permita dar de alta un nuevo usuario. El estado del mismo debe ser siempre Activo (1) y no puede ser menor a 18 años.
Alter Procedure SP_NuevoCliente(
    @Apellidos varchar(100),
    @Nombres varchar(100),
    @Direccion varchar(100),
    @IDLocalidad int,
    @Nacimiento date,
    @Email varchar(120),
    @Celular varchar(120)
)
as
begin
    Declare @Edad tinyint
    
    -- Calcular la edad
    SET @Edad = Datediff(Year, @Nacimiento, getdate())
    if Month(getdate()) < Month(@Nacimiento) or (Month(getdate()) = Month(@Nacimiento) And Day(getdate()) < Day(@Nacimiento)) begin
        Set @Edad = @Edad - 1
    end

    If @Edad >= 18 Begin
        Insert into Clientes(Apellidos, Nombres, Direccion, IDLocalidad,FechaNacimiento,Email,Celular, Estado)
        Values (@Apellidos, @Nombres, @Direccion, @IDLocalidad, @Nacimiento, @Email, @Celular, 1)
    End
    Else Begin
        Raiserror('Cliente menor de edad', 16, 1)
    End

    
end
go
Set Dateformat 'dmy'
exec SP_NuevoCliente 'Simon', 'Angel', 'Angel 1234', 1, '02/10/1986', 'asimon@docentes.frgp.utn.edu.ar', '01234'

Set Dateformat 'dmy'
exec SP_NuevoCliente 'Simumson', 'Angel', 'Angel 1234', 1, '02/10/2016', 'angel@docentes.frgp.utn.edu.ar', '01234'

Select top 1 * From Clientes order by 1 desc