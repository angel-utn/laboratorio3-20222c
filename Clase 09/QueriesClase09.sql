-- Joins
----------

-- 10) Listar por cada producto el nombre del producto, el nombre de la categoría, el precio de venta minorista, el precio de venta mayorista y el porcentaje de ahorro que se obtiene por la compra mayorista a valor mayorista en relación al valor minorista.
Select
    PR.Descripcion, 
    CAT.Nombre as Categoria,
    PR.Precio,
    Pr.PrecioVentaMayorista,
    (Precio-PrecioVentaMayorista)/Precio*100 as Porcentaje,
    ((1-PR.PrecioVentaMayorista/PR.Precio)*100) AS "% Ahorro precio mayorista",
    (100-(PR.PrecioVentaMayorista*100/PR.Precio)) AS "% Ahorro 2"
From Productos PR
Inner Join Categorias CAT ON CAT.ID = PR.IDCategoria

-- Distinct
Select distinct PE.IDProducto, PE.IDCliente, Year(Pe.FechaSolicitud) from Pedidos PE
order by 1 asc, 2 asc

-- Distinct en la función Count
Select Count(PE.IDProducto) from Pedidos PE

Select Count(Distinct PE.IDProducto) From Pedidos PE -- Cuenta IDProducto sin repeticiones

-- TP Subconsultas

-- 1) Los pedidos que hayan sido finalizados en menor cantidad de días que la demora promedio

Select * From Pedidos Where Datediff(Day, FechaSolicitud, FechaFinalizacion) < (
    Select Avg(Datediff(Day, FechaSolicitud, FechaFinalizacion)*1.0) From Pedidos
)

-- 3) Los clientes que no hayan solicitado ningún producto de material Pino en el año 2022.

Select * From Clientes Cli Where Cli.ID Not In (
    Select Distinct PE.IDCliente From Pedidos PE
    Inner Join Productos PR ON PR.ID = PE.IDProducto
    Inner Join Materiales_x_Producto MxP ON PR.ID = MxP.IDProducto
    Inner Join Materiales M ON M.ID = MxP.IDMaterial
    Where M.Nombre = 'Pino' And Year(Pe.FechaSolicitud) = 2022 And PE.IDCliente Is Not null
)

Select * From Clientes Cli Where Not exists (
    Select * From Pedidos PE
    Inner Join Productos PR ON PR.ID = PE.IDProducto
    Inner Join Materiales_x_Producto MxP ON PR.ID = MxP.IDProducto
    Inner Join Materiales M ON M.ID = MxP.IDMaterial
    Where M.Nombre = 'Pino' And Year(Pe.FechaSolicitud) = 2022 And Cli.ID = Pe.IDCliente
)

-- Con tabla temporal (Roberto)
select distinct pd.IDCliente into #pedidos2022Pino
from Pedidos pd 
inner join Productos pr ON pr.ID = pd.IDProducto
inner join Materiales_x_Producto mxp ON mxp.IDProducto = pr.ID
inner join Materiales m on m.ID = mxp.IDMaterial
where 2022 = year(pd.FechaSolicitud) and M.Nombre = 'Pino'

Select * From Clientes Cli
Left Join  #pedidos2022Pino p2022 ON Cli.ID = p2022.IDCliente
Where p2022.IDCliente is null

drop table #pedidos2022Pino

-- Los clientes a los que les hayan enviado (no necesariamente entregado) al menos un tercio de sus pedidos.
Select * From (
    Select Cli.Apellidos, Cli.Nombres,
    (
        Select count(*) From Pedidos PE Where PE.IDCliente = Cli.ID
    ) as CantPedidos,
    (
        Select count(*) From Pedidos PE 
        Inner Join Envios E ON E.IDPedido = PE.ID
        Where PE.IDCliente = Cli.ID
    ) as CantEnviados
    From Clientes Cli
) As Tabla
Where Tabla.CantEnviados >= Tabla.CantPedidos/3.0

-- 11) Por cada pedido, listar el ID, la fecha de solicitud, el nombre del producto, los apellidos y nombres de los colaboradores que trabajaron en el pedido y la/s tareas que el colaborador haya realizado (en una celda separados por coma)
Select Pe.ID, Pe.FechaSolicitud, PR.Descripcion, COL.Apellidos, COL.Nombres, String_agg(T.Nombre, ',') as TareasRealizadas
From Pedidos PE
Inner Join Productos PR ON PE.IDProducto = PR.ID
Inner Join Tareas_x_Pedido TxP ON TxP.IDPedido = PE.ID
Inner Join Colaboradores COL ON COL.Legajo = TxP.Legajo
Inner Join Tareas T ON T.ID = TxP.IDTarea
Group By Pe.ID, Pe.FechaSolicitud, PR.Descripcion, COL.Apellidos, COL.Nombres

-- Con subconsulta
select distinct Ped.Id, ped.FechaSolicitud,Pro.Descripcion,col.Apellidos,col.Nombres, (
	select  STRING_AGG (tar.Nombre, ',') 
    from tareas as tar
    inner join Tareas_x_Pedido TP ON tar.ID = TP.IDTarea
	where  TP.Legajo = col.Legajo AND TP.IDPedido = Ped.ID
) as 'Tareas'
from Pedidos as Ped
inner join Productos as Pro on Pro.ID= Ped.IDProducto
inner join Tareas_x_Pedido as txp on txp.IDPedido= Ped.ID 
inner join Colaboradores as col on col.Legajo= txp.Legajo