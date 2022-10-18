-- Hacer un trigger que al eliminar un cliente realice la baja lógica del mismo en su lugar.

--------------------------------
-- Tabla        : Clientes
-- Tipo Trigger : Instead Of
-- Acción       : Delete
--------------------------------
Create Trigger TR_BAJALOGICA_CLIENTE ON Clientes
Instead Of Delete
As
Begin
    Update Clientes set Estado = 0 Where ID = (Select ID from deleted)    
End

-- Disable Trigger TR_BAJALOGICA_CLIENTE ON Clientes
-- Enable Trigger TR_BAJALOGICA_CLIENTE ON Clientes


-- Hacer un trigger que al ingresar una venta verifique que la cantidad de entradas por adquirir, sumadas a las anteriormente compradas para dicha función, no superen la capacidad de la sala.
-- En caso de superar la capacidad de la sala. Generar una excepción con un mensaje aclaratorio. De lo contrario registrar la venta.

Go

--------------------------------
-- Tabla        : Ventas
-- Tipo Trigger : After
-- Acción       : Insert
--------------------------------
Create Trigger TR_NUEVA_VENTA ON Ventas
After INSERT
As
Begin

    Declare @Capacidad smallint
    Declare @IDFuncion bigint
    Declare @TotalEntradas int

    Select @IDFuncion = IDFuncion From inserted
    
    Select @Capacidad = Capacidad From Salas
    Inner Join Funciones ON Funciones.IDSala = Salas.ID
    Where Funciones.ID = @IDFuncion

    Select @TotalEntradas = Sum(Cantidad) From Ventas
    Where IDFuncion = @IDFuncion

    If @TotalEntradas > @Capacidad begin
        ROLLBACK TRANSACTION
        RAISERROR ('Supera la capacidad de la sala', 16, 1)
    End

End

-- OK
Insert into Ventas(IDFuncion, IDCliente, Cantidad, FechaCompra, Importe)
Values (1, 1, 200, getdate(), 1)

-- Error
Insert into Ventas(IDFuncion, IDCliente, Cantidad, FechaCompra, Importe)
Values (1, 2, 80, getdate(), 1)

Go

-- Hacer un trigger que al modificar una venta no permita cambiar ningún campo salvo la cantidad de unidades. El cambio sólo admitirá que la cantidad de unidades sea inferior a la cantidad inicial. Debe recalcular el importe de la venta.

--------------------------------
-- Tabla        : Ventas
-- Tipo Trigger : Instead Of
-- Acción       : Update
--------------------------------
Create Trigger TR_DevolucionVenta on Ventas
Instead Of Update
As
Begin
    
    Declare @IDVenta bigint, @IDFuncion bigint, @CantOriginal int, @CantNueva int
    Declare @Costo money, @ImporteActualizado money

    Select @CantNueva = Cantidad from inserted
    Select @IDVenta = ID, @IDFuncion = IDFuncion, @CantOriginal = Cantidad from deleted

    Select @Costo = Costo From Funciones Where ID = @IDFuncion

    if @CantNueva < @CantOriginal begin
        SET @ImporteActualizado = @CantNueva * @Costo
        
        Update Ventas Set Importe = @ImporteActualizado, Cantidad = @CantNueva
        Where ID = @IDVenta
                        
    end

End