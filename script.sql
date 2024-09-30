CREATE DATABASE Taskify;

USE Taskify;

CREATE TABLE Roles(
    IdRol INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL
);

CREATE TABLE Rangos(
    IdRango INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL
);

CREATE TABLE Tasks(
    IdTask INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Area VARCHAR(200) NOT NULL,
);

CREATE TABLE Certificados(
    IdCertificado INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdTask INT NOT NULL FOREIGN KEY REFERENCES Tasks(IdTask),
    Nombre VARCHAR(200) NOT NULL,
    Area VARCHAR(200) NOT NULL,
);

CREATE TABLE Categorias(
    IdCategoria INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(200)
);

CREATE TABLE Proyectos(
    IdProyecto INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Roles(IdUsuario),
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES Categorias(IdCategoria),
    FechaPublicacion DATE NOT NULL,
    CantIntegrantes INT NOT NULL,
    Descripcion VARCHAR(200),
    Valoracion INT NOT NULL,
    Estado BIT
);

CREATE TABLE Usuarios(
    IdUsuario INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdRol INT NOT NULL FOREIGN KEY Roles(IdRol),
    IdRango INT NOT NULL FOREIGN KEY Rangos(IdRango),
    IdProyecto INT NOT NULL FOREIGN KEY UsuarioXProyecto(IdProyecto),
    IdCertificado INT NOT NULL FOREIGN KEY Certificados(IdCertificado),
    Nombre VARCHAR(200) NOT NULL,
    Apellido VARCHAR(200) NOT NULL,
    Contraseña VARCHAR(200) NOT NULL,
    Edad INT NOT NULL,
    Enauk VARCHAR(200) NOT NULL,
    Telefono VARCHAR(200) NOT NULL,
    Estrellas INT NOT NULL,
);

CREATE TABLE UsuarioXProyecto(
    IdProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyectos(IdProyecto),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario)
);



