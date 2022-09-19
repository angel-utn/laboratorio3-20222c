-- 1) Las películas que tengan una duración mayor al promedio.
Select P.* From Peliculas P Where P.Duracion > (
    Select Avg(Duracion*1.0) From Peliculas
)

-- 2) Las películas que tengan una duración mayor a la de cualquier película de género Comedia.

Select P.* From Peliculas P Where P.Duracion > (
    Select Top 1 PE.Duracion From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
    Order By PE.Duracion Desc
)

Select P.* From Peliculas P Where P.Duracion > (
    Select Max(PE.Duracion) From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
)

Select P.* From Peliculas P Where P.Duracion > ALL (
    Select PE.Duracion From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
)

-- 2B) Las películas que tengan una duración mayor a la de alguna película de género Comedia.
Select P.* From Peliculas P Where P.Duracion > (
    Select Top 1 PE.Duracion From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
    Order By PE.Duracion Asc
)

Select P.* From Peliculas P Where P.Duracion > (
    Select Min(PE.Duracion) From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
)

Select P.* From Peliculas P Where P.Duracion > ANY (
    Select PE.Duracion From Peliculas PE
    Inner Join Generos_x_Pelicula GxP ON PE.ID = GxP.IDPelicula
    Inner Join Generos G ON G.ID = GxP.IDGenero
    Where G.Nombre = 'Comedia'
)


-- IN
Select P.* From Peliculas P Where IDCategoria = ANY (
    Select 1
    UNION
    Select 3
    Union
    Select 5
)

-- NOT IN
Select P.* From Peliculas P Where IDCategoria <> ALL (
    Select 1
    UNION
    Select 3
    Union
    Select 5
)

-- 3) Las películas que no hayan sido proyectadas en el año 2022

-- A
Select * From Peliculas

-- B
Select distinct IDPelicula From Funciones Where Year(Horario) = 2022

-- Las películas que están en A y no están en B

Select * From Peliculas Where ID Not In (
    Select distinct IDPelicula From Funciones Where Year(Horario) = 2022
)

-- Alternativa con NOT EXISTS
Select * From Peliculas P Where Not Exists (
    Select * From Funciones Where Year(Horario) = 2022 And IDPelicula = P.ID
)


-- 4) Por cada cliente, la cantidad de películas en idioma castellano vistas y la cantidad de películas en otro idioma vistas.

Select Cli.ID, Cli.Apellidos, Cli.Nombres, 
(
    Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre = 'Castellano' And V.IDCliente = Cli.ID
) as CantCastellano, 
(
    Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre <> 'Castellano' And V.IDCliente = Cli.ID
) as CantNoCastellano
From Clientes Cli


-- 5) Por cada película, el nombre de la película y el nombre de cada uno de los géneros separados por coma.
Select P.Nombre,
(
    Select STRING_AGG(G.Nombre, ',') From Generos G
    Inner Join Generos_x_Pelicula GxP ON G.ID = GxP.IDGenero
    Where GxP.IDPelicula = P.ID
) As Generos
From Peliculas P

-- 6) Los clientes que vieron más películas en idioma castellano que en otro idioma.

-- :-(
Select Cli.ID, Cli.Apellidos, Cli.Nombres, 
(
    Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre = 'Castellano' And V.IDCliente = Cli.ID
) as CantCastellano, 
(
    Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre <> 'Castellano' And V.IDCliente = Cli.ID
) as CantNoCastellano
From Clientes Cli
Where (
    Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre = 'Castellano' And V.IDCliente = Cli.ID
    ) > (
        Select Count(*) From Funciones F
    Inner Join Idiomas I ON I.ID = F.IDIdioma
    Inner Join Ventas V ON F.ID = V.IDFuncion
    Where I.Nombre <> 'Castellano' And V.IDCliente = Cli.ID
    )

-- <3
Select * From (
    Select Cli.ID, Cli.Apellidos, Cli.Nombres, 
    (
        Select Count(*) From Funciones F
        Inner Join Idiomas I ON I.ID = F.IDIdioma
        Inner Join Ventas V ON F.ID = V.IDFuncion
        Where I.Nombre = 'Castellano' And V.IDCliente = Cli.ID
    ) as CantCastellano, 
    (
        Select Count(*) From Funciones F
        Inner Join Idiomas I ON I.ID = F.IDIdioma
        Inner Join Ventas V ON F.ID = V.IDFuncion
        Where I.Nombre <> 'Castellano' And V.IDCliente = Cli.ID
    ) as CantNoCastellano
    From Clientes Cli
) As EstadisticaClientes
Where EstadisticaClientes.CantCastellano > EstadisticaClientes.CantNoCastellano


