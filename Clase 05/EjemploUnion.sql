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

-- Alternativa
Select 
    Nombre as Titulo,
    Duracion,
    'Cortometrajes' AS TipoDuracion
From Peliculas
Where Duracion <= 30
Union
Select 
    Nombre as Titulo,
    Duracion,
    'Mediometrajes' AS TipoDuracion
From Peliculas
Where Duracion between 31 and 75 -- > 30 AND Duracion <= 75
Union
Select 
    Nombre as Titulo,
    Duracion,
    'Largometrajes' AS TipoDuracion
From Peliculas
Where Duracion > 75