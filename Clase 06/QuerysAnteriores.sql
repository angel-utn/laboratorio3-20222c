-- Resoluciones de TP Anteriores

-- 2.1
-- Apellidos, nombres y medio de contacto de todos los clientes. Si tiene celular debe figurar literalmente 'Celular'. Si no tiene celular pero tiene teléfono fijo debe figurar 'Teléfono fijo' de lo contrario y si tiene Mail debe figurar 'Email'. Si no posee ninguno de los tres debe figurar NULL.

Select 
Cli.Apellidos, 
Cli.Nombres,
Case
    When Celular is not null then 'Celular'
    When Telefono is not null then 'Telefono fijo'
    When Mail is not null then 'Email'
End as MedioContacto,
Coalesce(Celular, Telefono, Mail) as ValorContacto
From Clientes Cli

-- Todos los datos de todos los productos con su precio aumentado en un 20%
Select *, Precio*1.2 as PrecioFinal From Productos


