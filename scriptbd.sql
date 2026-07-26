
    create database db_biblioteca
go

Use db_biblioteca
go



create table Autores
(
    idAutor int primary key identity,
    nombre varchar(100),
    nacionalidad varchar(50)
)
go

create table Libros
(
    idLibro int primary key identity,
    titulo varchar(200),
    idAutor int references Autores,
    anio_publicacion int,
    estado int default 1
)
go

create table Clientes
(
    idCliente int primary key identity,
    nombres varchar(100),
    apellidos varchar(100),
    numeroDocumento varchar(8) unique,
    email varchar(150) unique,
    celular varchar(9),
    estado int default 1
)
go

create table Prestamos
(
    idPrestamo int primary key identity,
    idCliente int references Clientes,
    idLibro int references Libros,
    fechaPrestamo date,
    fechaDevolucion date,
    estado int default 1
)
go

create or alter procedure sp_listar_prestamos_x_anio
    @year int
as
begin
    select 
        p.idPrestamo,
        c.nombres + ' ' + c.apellidos as nombre_cliente,
        l.titulo as nombre_libro,
        p.fechaPrestamo
    from Prestamos p
    inner join Clientes c on p.idCliente = c.idCliente
    inner join Libros l on p.idLibro = l.idLibro
    where year(p.fechaPrestamo) = @year
    order by p.fechaPrestamo desc
end
go

-- =====================
-- INSERTS DE PRUEBA
-- =====================

-- Autores
insert into Autores(nombre, nacionalidad) values
('Gabriel Garc\xeda M\xe1rquez', 'Colombiana'),
('Mario Vargas Llosa', 'Peruana'),
('Julio Cort\xe1zar', 'Argentina'),
('Isabel Allende', 'Chilena'),
('Jorge Luis Borges', 'Argentina'),
('Laura Esquivel', 'Mexicana'),
('Carlos Fuentes', 'Mexicana'),
('Pablo Neruda', 'Chilena');

-- Libros
insert into Libros(titulo, idAutor, anio_publicacion) values
('Cien A\xf1os de Soledad', 1, 1967),
('El Amor en los Tiempos del C\xf3lera', 1, 1985),
('La Ciudad y los Perros', 2, 1963),
('Conversaci\xf3n en La Catedral', 2, 1969),
('Rayuela', 3, 1963),
('La Casa de los Esp\xedritus', 4, 1982),
('El Aleph', 5, 1949),
('Ficciones', 5, 1944),
('Como Agua para Chocolate', 6, 1989),
('La Silla del \xc1guila', 7, 2003),
('Veinte Poemas de Amor', 8, 1924),
('Confieso que he Vivido', 1, 1974),
('Travesuras de la Ni\xf1a Mala', 2, 2006),
('Los Jefes', 2, 1959),
('Bestiario', 3, 1951);

-- Clientes
insert into Clientes(nombres, apellidos, numeroDocumento, email, celular) values
('Juan', 'P\xe9rez L\xf3pez', '12345678', 'jperez@mail.com', '987654321'),
('Mar\xeda', 'Garc\xeda Torres', '23456789', 'mgarcia@mail.com', '987654322'),
('Carlos', 'Ram\xedrez Soto', '34567890', 'cramirez@mail.com', '987654323'),
('Ana', 'Mart\xednez Ruiz', '45678901', 'amartinez@mail.com', '987654324'),
('Luis', 'Fern\xe1ndez D\xedaz', '56789012', 'lfernandez@mail.com', '987654325'),
('Rosa', 'Vargas Luna', '67890123', 'rvargas@mail.com', '987654326'),
('Pedro', 'Castillo R\xedos', '78901234', 'pcastillo@mail.com', '987654327'),
('Carmen', 'Torres Paredes', '89012345', 'ctorres@mail.com', '987654328'),
('Jos\xe9', 'Flores Campos', '90123456', 'jflores@mail.com', '987654329'),
('Sof\xeda', 'D\xedaz Romero', '01234567', 'sdiaz@mail.com', '987654330');

-- Pr\xe9stamos (distribuidos en 2024, 2025 y 2026 para probar el filtro)
insert into Prestamos(idCliente, idLibro, fechaPrestamo, fechaDevolucion) values
(1, 1, '2024-03-10', '2024-03-20'),
(2, 3, '2024-05-15', '2024-05-25'),
(3, 5, '2024-07-20', '2024-08-01'),
(4, 2, '2024-09-05', '2024-09-15'),
(5, 7, '2024-11-12', '2024-11-22'),
(1, 4, '2025-01-10', '2025-01-20'),
(2, 6, '2025-02-14', '2025-02-24'),
(6, 8, '2025-04-18', '2025-04-28'),
(7, 9, '2025-06-22', '2025-07-02'),
(3, 10, '2025-08-30', '2025-09-09'),
(8, 11, '2025-10-05', '2025-10-15'),
(9, 12, '2025-11-20', '2025-11-30'),
(10, 13, '2026-01-15', '2026-01-25'),
(4, 14, '2026-02-20', '2026-03-02'),
(5, 15, '2026-03-10', '2026-03-20'),
(6, 1, '2026-04-05', '2026-04-15'),
(7, 2, '2026-05-18', '2026-05-28'),
(8, 3, '2026-06-22', '2026-07-02'),
(9, 5, '2026-07-10', '2026-07-20'),
(10, 8, '2026-08-14', '2026-08-24'),
-- 2024
(2, 6, '2024-01-15', '2024-01-25'),
(5, 9, '2024-02-20', '2024-03-01'),
(7, 11, '2024-04-10', '2024-04-20'),
(9, 13, '2024-06-05', '2024-06-15'),
(10, 14, '2024-08-18', '2024-08-28'),
(8, 4, '2024-10-22', '2024-11-01'),
-- 2025
(3, 1, '2025-01-05', '2025-01-15'),
(4, 7, '2025-03-12', '2025-03-22'),
(5, 10, '2025-05-25', '2025-06-04'),
(6, 12, '2025-07-30', '2025-08-09'),
(7, 14, '2025-09-15', '2025-09-25'),
(10, 15, '2025-12-01', '2025-12-11'),
-- 2026
(1, 6, '2026-01-02', '2026-01-12'),
(2, 9, '2026-02-28', '2026-03-10'),
(3, 11, '2026-03-25', '2026-04-04'),
(4, 4, '2026-05-08', '2026-05-18'),
(8, 13, '2026-06-15', '2026-06-25'),
(9, 7, '2026-07-20', '2026-07-30');

go

drop procedure if exists sp_listar_autores
drop procedure if exists sp_listar_libros
drop procedure if exists sp_insertar_libro
go

create procedure sp_listar_autores
as
begin
    select idAutor, nombre, nacionalidad
    from Autores
    order by nombre
end
go

create procedure sp_listar_libros
as
begin
    select l.idLibro, l.titulo, l.idAutor, l.anio_publicacion, l.estado,
           a.nombre as nombre_autor
    from Libros l
    inner join Autores a on l.idAutor = a.idAutor
    order by l.titulo
end
go

create procedure sp_insertar_libro
    @titulo varchar(200),
    @idAutor int,
    @anio_publicacion int
as
begin
    insert into Libros(titulo, idAutor, anio_publicacion)
    values(@titulo, @idAutor, @anio_publicacion)

    if @@rowcount > 0
        select 'Libro registrado correctamente' as mensaje
    else
        select 'Error al registrar el libro' as mensaje
end
go

