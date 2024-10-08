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

CREATE TABLE Lenguajes(
    IdLenguaje INt NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE Tasks(
    IdTask INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdLenguaje INT NOT NULL FOREIGN KEY REFERENCES Lenguajes(IdLenguaje),
    Area VARCHAR(200) NOT NULL
);

CREATE TABLE Consigna(
    IdConsigna INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Pregunta VARCHAR(200) NOT NULL,
    Foto VARCHAR(200)
);

CREATE TABLE Respuesta(
    IdRespuesta INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdConsigna INT NOT NULL FOREIGN KEY REFERENCES Consigna(IdConsigna),
    Contenido VARCHAR(200) NOT NULL,
    Opcion INT NOT NULL,
    EsCorrecta BIT NOT NULL
);

CREATE TABLE ConsignaXTask(
    IdTask INT NOT NULL FOREIGN KEY REFERENCES Tasks(IdTask),
    IdConsigna INT NOT NULL FOREIGN KEY REFERENCES Consigna(IdConsigna)
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
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES Categorias(IdCategoria),
    FechaPublicacion DATE NOT NULL,
    CantIntegrantes INT NOT NULL,
    Descripcion VARCHAR(200),
    Valoracion INT NOT NULL,
    Estado BIT
);

CREATE TABLE Usuarios(
    IdUsuario INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdRol INT NOT NULL FOREIGN KEY REFERENCES Roles(IdRol),
	IdRango INT NOT NULL FOREIGN KEY REFERENCES Rangos(IdRango),
	IdCertificado INT NOT NULL FOREIGN KEY REFERENCES Certificados(IdCertificado),
    Nombre VARCHAR(200) NOT NULL,
    Apellido VARCHAR(200) NOT NULL,
    Contraseña VARCHAR(200) NOT NULL,
    Edad INT NOT NULL,
    Email VARCHAR(200) NOT NULL,
    Telefono VARCHAR(200) NOT NULL,
    Puntaje INT NOT NULL,
    FotoPerfil VARCHAR(200),
    Descripcion VARCHAR(200)
);

CREATE TABLE UsuarioXProyecto(
    IdProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyectos(IdProyecto),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario)
);

CREATE TABLE Chats(
    IdChat INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombrechat VARCHAR(200) NOT NULL,
    EsGrupo BIT NOT NULL  
);

CREATE TABLE Participantes(
    IdChat INT NOT NULL FOREIGN KEY REFERENCES Chats(IdChat),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
);

CREATE TABLE Mensajes(
    IdMensaje INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdChat INT NOT NULL FOREIGN KEY REFERENCES Chats(IdChat),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    Contenido VARCHAR(700) NOT NULL,
    Hora DATE NOT NULL,
    EsLeido BIT
);

CREATE TABLE Contactos(
    IdContacto INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    Nombre VARCHAR(200) NOT NULL,
    Telefono VARCHAR(200) NOT NULL,
    Email VARCHAR(200) NOT NULL,
);

CREATE TABLE Eventos(
    IdEvento INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    IdContacto INT NOT NULL FOREIGN KEY REFERENCES Contactos(IdContacto),
    Nombre VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL
);