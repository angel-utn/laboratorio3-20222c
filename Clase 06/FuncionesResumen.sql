-- La cantidad de clientes
Select Count(*) from Clientes

-- La cantidad de clientes con celular
Select Count(*) from Clientes where Celular is not null

Select Count(Celular) from Clientes

-- La capacidad total (de todas las salas) de todo el complejo de cine
Select Sum(Capacidad) From Salas

-- La capacidad total (de todas las salas de tipo 3D) de todo el complejo de cine
Select Sum(Capacidad) From Salas S 
Inner Join TiposSalas TS ON TS.ID = S.IDTipo
Where TS.Nombre Like '%3D%'

-- Por cada película, el nombre de la película y la cantidad total de funciones. 
Select P.ID, P.Nombre, count(*) as CantidadFunciones from Peliculas P
Inner Join Funciones F ON P.ID = F.IDPelicula
Group By P.ID, P.Nombre

-- Por cada película, el nombre de la película y la cantidad total de funciones. Si la película no tuvo funciones que figure igualmente en el listado pero contabilizando 0.
Select P.ID, P.Nombre, count(F.ID) as CantidadFunciones from Peliculas P
Left Join Funciones F ON P.ID = F.IDPelicula
Group By P.ID, P.Nombre
order by 2 asc

-- Por cada película, el nombre de la película y la cantidad de salas distintas en las que se proyectó.
Select P.ID, P.Nombre, Count(DISTINCT F.IDSala) as Cantidad
From Peliculas P
Inner Join Funciones F ON F.IDPelicula = P.ID
Group By P.ID, P.Nombre

-- Por cada película, el nombre y el costo promedio de las funciones. Sólo listar aquellas películas cuyo costo promedio por función sea menor a $300.
Select P.ID, P.Nombre, Avg(F.Costo) as Promedio
From Peliculas P
Inner Join Funciones F ON P.ID = F.IDPelicula
Group By P.ID, P.Nombre
Having Avg(F.Costo) < 300