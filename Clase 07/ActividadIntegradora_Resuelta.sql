-- 1) Listado con Apellido y nombres de los técnicos que, en promedio, hayan demorado más de 225 minutos en la prestación de servicios.
Select T.Apellido, T.Nombre
From Tecnicos T
Inner Join Servicios S ON T.ID = S.IDTecnico
Group By T.ID, T.Apellido, T.Nombre
Having Avg(S.Duracion) > 225

-- 2) Listado con Descripción del tipo de servicio, el texto 'Particular' y la cantidad de clientes de tipo Particular. Luego añadirle un listado con descripción del tipo de servicio, el texto 'Empresa' y la cantidad de clientes de tipo Empresa.
Select TS.Descripcion, 'Particular' as TipoCliente, Count(Distinct S.IDCliente) as CantidadClientes
From TiposServicio TS
Inner Join Servicios S ON TS.ID = S.IDTipo
Inner Join Clientes CLI ON CLI.ID = S.IDCliente
Where CLI.Tipo = 'P'
Group By TS.Descripcion
Union
Select TS.Descripcion, 'Empresa' as TipoCliente, Count(Distinct S.IDCliente) as CantidadClientes
From TiposServicio TS
Inner Join Servicios S ON TS.ID = S.IDTipo
Inner Join Clientes CLI ON CLI.ID = S.IDCliente
Where CLI.Tipo = 'E'
Group By TS.Descripcion


-- Nahuel Saucedo 
SELECT DISTINCT TP.Descripcion, COUNT(DISTINCT S.IDCliente) AS 'CANTIDAD',
CASE
WHEN C.TIPO = 'P' THEN 'PARTICULAR'
ELSE 'EMPRESA'
END AS 'TIPO'
FROM TiposServicio AS TP
INNER JOIN Servicios AS S ON TP.ID = S.IDTipo
INNER JOIN Clientes AS C ON S.IDCliente = C.ID
GROUP BY TP.Descripcion, C.Tipo 

-- Verónica Carbonari
select ts.Descripcion, count(distinct c.ID) as total,	--uso el distinct para que no sume más de una vez a cada cliente
case
	when c.Tipo like 'P' then 'Particular'
    Else 'Empresa'
End as [Descr. Tipo]
from Servicios as S
inner join TiposServicio as TS on s.IDTipo = ts.ID
inner join Clientes as C on c.ID=s.IDCliente
group by  ts.Descripcion, c.Tipo
Order By Ts.Descripcion asc

-- 3) Listado con Apellidos y nombres de los clientes que hayan abonado con las cuatro formas de pago.
Select CLI.Apellido, CLI.Nombre
From Clientes CLI
Inner Join Servicios S ON CLI.Id = S.IDCliente
Group by CLI.Id, CLI.Apellido, CLI.Nombre
Having Count(Distinct S.FormaPago) = 4

-- 4) La descripción del tipo de servicio que en promedio haya brindado mayor cantidad de días de garantía.
Select Top 1 with ties TS.Descripcion
From TiposServicio TS
Inner Join Servicios S ON TS.ID = S.IDTipo
Group By TS.Descripcion
Order By Avg(S.DiasGarantia*1.0) desc

-- 5) Agregar las tablas y/o restricciones que considere necesario para permitir a un cliente que contrate a un técnico por un período determinado. Dicha contratación debe poder registrar la fecha de inicio y fin del trabajo, el costo total, el domicilio al que debe el técnico asistir y la periodicidad del trabajo (1 - Diario, 2 - Semanal, 3 - Quincenal).
Create Table Contratos(
    ID bigint not null primary key identity(1, 1),
    IDCliente int not null foreign key references Clientes(ID),
    IDTecnico int not null foreign key references Tecnicos(ID),
    Inicio date not null,
    Fin date null,
    Costo money null Check(Costo > 0),
    Domicilio varchar(500) not null,
    Periodicidad tinyint not null check(Periodicidad in (1, 2, 3)),
    Check(Fin >= Inicio)
)