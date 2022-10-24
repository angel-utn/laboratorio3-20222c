Use ModeloExamenIntegrador
go

-- Hacer un trigger que al cargar un crédito verifique que el importe del mismo sumado a los importes de los créditos que actualmente solicitó esa persona no supere al triple de la declaración de ganancias. Sólo deben tenerse en cuenta en la sumatoria los créditos que no se encuentren cancelados. De no poder otorgar el crédito aclararlo con un mensaje.

Create Trigger TR_Nuevo_Credito on Creditos
After Insert
As
Begin

    Declare @DNI varchar(10)
    Declare @SumaTotal money, @DeclaracionGanancias money

    Select @DNI = DNI from inserted
    Select @SumaTotal = Sum(Importe) From Creditos Where DNI = @DNI And Cancelado = 0
    Select @DeclaracionGanancias = DeclaracionGanancias From Personas Where DNI = @DNI

    If @SumaTotal > @DeclaracionGanancias * 3 Begin
        Rollback Transaction
        RAISERROR('No se puede otorgar crédito', 16, 1)
    End

End
Go
Create Trigger TR_Nuevo_Credito_2 on Creditos
Instead Of Insert
As
Begin

    Declare @DNI varchar(10)
    Declare @SumaTotal money, @DeclaracionGanancias money, @ImporteCredito money

    Select @DNI = DNI, @ImporteCredito = Importe from inserted
    Select @SumaTotal = IsNull(Sum(Importe), 0) From Creditos Where DNI = @DNI And Cancelado = 0
    Select @DeclaracionGanancias = DeclaracionGanancias From Personas Where DNI = @DNI

    If @SumaTotal+@ImporteCredito > @DeclaracionGanancias * 3 Begin
        RAISERROR('No se puede otorgar crédito', 16, 1)
    End
    Else Begin
        Insert into Creditos (IDBanco, DNI, Fecha, Importe, Plazo, Cancelado)
        Select IDBanco, DNI, Fecha, Importe, Plazo, Cancelado from inserted
    End

End
Go

-- Hacer un trigger que al eliminar un crédito realice la cancelación del mismo.
Create Trigger TR_CancelarCredito ON Creditos
Instead Of Delete
As
Begin
    Update Creditos SET Cancelado = 1 Where ID IN (Select ID from deleted)
End
Go

-- Hacer un trigger que no permita otorgar créditos con un plazo de 20 o más años a personas cuya declaración de ganancias sea menor al promedio de declaración de ganancias.
Create Trigger TR_ValidacionPromedioDeclaracionGanancias ON Creditos
After Insert
As
Begin
    Declare @DNI varchar(10)
    Declare @DeclaracionGanancias money, @PromedioDG money
    Declare @Plazo smallint

    Select @DNI = DNI, @Plazo = Plazo From inserted 
    Select @DeclaracionGanancias = DeclaracionGanancias From Personas Where DNI = @DNI
    Select @PromedioDG = AVG(DeclaracionGanancias) From Personas

    If @Plazo >= 20 And @DeclaracionGanancias < @PromedioDG Begin
        Rollback TRANSACTION
        RAISERROR('Plazo no válido para esa declaración de ganancias', 16, 1)
    End

End

Go

-- Hacer un procedimiento almacenado que reciba dos fechas y liste todos los créditos otorgados entre esas fechas. Debe listar el apellido y nombre del solicitante, el nombre del banco, el tipo de banco, la fecha del crédito y el importe solicitado.
Create Procedure SP_CreditosOtorgadosEntreFechas(
    @Inicio date,
    @Fin date
)
as
begin
    Select P.Apellidos, P.Nombres, B.Nombre as NombreBanco, B.Tipo, C.Fecha, C.Importe 
    From Creditos C
    Inner Join Personas P ON P.DNI = C.DNI
    Inner Join Bancos B ON B.ID = C.IDBanco
    Where C.Fecha between @Inicio and @Fin
end











