-- Listado con todos los datos de todas las películas
Select * From Peliculas

-- Listado con todas las películas ordenadas por título ascendentemente
Select * From Peliculas Order By Nombre asc
Select * From Peliculas Order By 3 desc -- Por Fecha de Estreno DESC

-- Listado con título de la película y año de estreno
Select Nombre as Titulo, Year(FechaEstrenoMundial) as AñoEstreno From Peliculas

Select Nombre as Titulo, DatePart(Year, FechaEstrenoMundial) as AñoEstreno From Peliculas

-- Listado con título de la película, año de estreno y cuánto tiempo pasó (en días) entre el estreno y la fecha actual
Select 
    Nombre as Titulo, 
    Year(FechaEstrenoMundial) as AñoEstreno,
    DateDiff(day, FechaEstrenoMundial, GETDATE()) as DiasTranscurridos,
    cast(getdate() as date) as FechaActual
From Peliculas

-- Listado con título de la película y año de estreno ordenado por año de mayor a menor y luego por título de menor a mayor
Select Nombre as Titulo, Year(FechaEstrenoMundial) as AñoEstreno 
From Peliculas
Order by AñoEstreno desc, Nombre asc

-- Listado con título y fecha de estreno de la película más antigua
Select Top 1 Nombre as Titulo, FechaEstrenoMundial from Peliculas
Order by FechaEstrenoMundial asc

-- Listado con título y duración de la película más extensa. Si existen varias películas que cumplan esta condición, incluirlas a todas.

Select Top 1 with ties Nombre as Titulo, Duracion from Peliculas
Order by Duracion desc

-- Listado de todos los datos de las películas que tengan una duración mayor a 150 minutos
Select * From Peliculas where Duracion > 150

-- Listado de todos los datos de las películas que tengan una duración entre 60 y 120 minutos
Select * From Peliculas where Duracion >= 60 And Duracion <= 120

Select * From Peliculas where Duracion Between 60 and 120

-- Listado de todos los datos de las películas que pertenezcan a las categorías 1, 3 y  5
Select * From Peliculas Where IDCategoria = 1 Or IDCategoria = 3 Or IDCategoria = 5

Select * From Peliculas Where IDCategoria In (1, 3, 5)

-- Listado de todos los datos de las películas que no pertenezcan a las categorías 1, 3 y  5
Select * From Peliculas Where Not (IDCategoria = 1 Or IDCategoria = 3 Or IDCategoria = 5)

Select * From Peliculas Where IDCategoria <> 1 And IDCategoria <> 3 And IDCategoria <> 5

Select * From Peliculas Where IDCategoria Not In (1, 3, 5)

-- Listado con título de la película, duración y tipo de duración siendo:
    -- Cortometraje - Hasta 30 minutos
    -- Mediometraje - Hasta 75 minutos
    -- Largometraje - Mayor a 75 minutos
Select 
    Nombre as Titulo,
    Duracion,
    Case  
        When Duracion <= 30 Then 'Cortometraje'
        When Duracion <= 75 Then 'Mediometraje'
        Else 'Largometraje'
    End as TipoDuracion
From Peliculas

-- Listado de todos los datos de todos los clientes que no indicaron un celular
Select * From Clientes where Celular is null

-- Listado de todos los datos de todos los clientes que indicaron un mail pero no un celular
Select * From Clientes where Email is not null and Celular is null

-- Listado de apellidos y nombres de los clientes y su información de contacto. La información de contacto debe ser el mail en primer lugar, si no tiene mail el celular y si no tiene celular el domicilio.

Select 
Apellidos, 
Nombres,
IsNull(Email, Isnull(Celular, Direccion)) as Contacto
From Clientes

Select 
Apellidos, 
Nombres,
Coalesce(Email, Celular, Direccion) as Contacto
From Clientes
order by Apellidos asc

-- Listado de todos los clientes cuyo apellido es Smith
Select * from Clientes Where Apellidos = 'Smith'
Select * from Clientes Where Apellidos like 'Smith'

-- Listado de todos los datos de todos los clientes cuyo apellido finalice con 'Son'.
Select * from Clientes Where Apellidos like '%son'

-- Listado de todos los datos de todos los clientes cuyo apellido comience con vocal y finalice con vocal.
Select * from Clientes Where Apellidos like '[AEIOU]%[AEIOU]'

-- Listado de todos los datos de todos los clientes cuyo apellido contenga 5 carácteres.
Select * from Clientes Where Apellidos like '_____'

Select * From Clientes Where Len(Trim(Apellidos)) = 5

-- Listado de clientes con apellidos, nombres y mail de aquellos clientes que tengan un mail con dominio .jp


-- Listado de clientes con apellidos, nombres y mail de aquellos clientes que tengan un mail cuya organización comience con vocal.


-- Listado de clientes con apellidos, nombre y mail de aquellos clientes que tengan un mail cuyo nombre de usuario comience con E y tenga 9 carácteres en total pero no sea de tipo '.COM'

Select Apellidos, Nombres, Email
From Clientes
Where Email like 'E________@%' and Email not like '%.com'


-- Listado con todos los apellidos sin repetir
Select distinct Apellidos from Clientes

