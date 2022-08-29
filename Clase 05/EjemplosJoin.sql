-- Listar para cada cliente, apellidos y nombres, dirección, nombre de la localidad y nombre de provincia de aquellos clientes que tengan domicilio.
select 
    C.Apellidos, 
    C.Nombres,
    C.Direccion,
    L.Nombre as Localidad,
    P.Nombre as Provincia
from Clientes As C
inner join Localidades as L on C.IDLocalidad = L.ID
inner join Provincias as P ON L.IDProvincia = P.ID

-- Listar para cada cliente, apellidos y nombres, dirección, nombre de la localidad y nombre de provincia de todos los clientes. Si el cliente no tiene registrada una localidad debe figurar con NULL los datos de localidad y provincia.
select 
    C.Apellidos, 
    C.Nombres,
    C.Direccion,
    L.Nombre as Localidad,
    P.Nombre as Provincia
from Clientes As C
left join Localidades as L on C.IDLocalidad = L.ID
left join Provincias as P ON L.IDProvincia = P.ID

-- Listar las localidades que no tienen asociado ningún cliente.
Select L.Nombre as Localidad From Localidades as L
left join Clientes as C ON L.ID = C.IDLocalidad
where C.ID is null

-- Cross Join - Producto Cartesiano
Select L.Nombre as Localidad, P.Nombre as Provincia 
From Localidades L 
Cross Join Provincias P

-- Listar todos los géneros, sin repetir, de aquellas películas de categoría R.
Select distinct G.Nombre From Generos G
Inner Join Generos_x_Pelicula GxP ON G.ID = GxP.IDGenero
Inner Join Peliculas P ON P.ID = GxP.IDPelicula
Inner Join Categorias C ON C.ID = P.IDCategoria
Where C.Codigo = 'R'

-- Listar los nombres de las películas que se hayan proyectado en alguna sala 4D. La sala debe contener el texto "4D".
Select Distinct P.Nombre as Titulo from Peliculas P
Inner Join Funciones F ON P.ID = F.IDPelicula
Inner Join Salas S ON S.ID = F.IDSala
Inner Join TiposSalas TS ON TS.ID = S.IDTipo
where TS.Nombre like '%4D%'
Order by P.Nombre asc

--Listar para cada sala, el nombre, la capacidad y el tipo de sala
 
-- Listar para cada película, el nombre de la película, su duración y su categoría
 
-- Listar para cada película, el nombre de la película y sus géneros
 
-- Listar para cada película, el nombre de la película, el nombre de la categoría, el nombre y tipo de la sala donde se proyecta, el horario y costo de cada función
 
-- Listar para cada película el nombre de la película y de cada función el horario y el nombre del idioma hablado y de subtítulo
 
-- Listar los nombres de las películas cuyo género sea Ciencia Ficción o Comedia.
