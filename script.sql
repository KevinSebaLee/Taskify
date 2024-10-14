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

CREATE TABLE Generos(
    IdGenero INT NOT NULL,
    Nombre VARCHAR(200)
);

CREATE TABLE Paises(
    IdPais INT NOT NULL,
    Nombre VARCHAR(200)
)

CREATE TABLE Usuarios(
    IdUsuario INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdRol INT NOT NULL FOREIGN KEY REFERENCES Roles(IdRol),
	IdRango INT NOT NULL FOREIGN KEY REFERENCES Rangos(IdRango),
	IdCertificado INT FOREIGN KEY REFERENCES Certificados(IdCertificado),
    IdGenero INT NOT NULL FOREIGN KEY REFERENCES Generos(IdGenero),
    IdPais INT NOT NULL FOREIGN KEY REFERENCES Paises(IdPais),
    Nombre VARCHAR(200) NOT NULL,
    Apellido VARCHAR(200) NOT NULL,
    Contraseña VARCHAR(200) NOT NULL,
    Edad INT NOT NULL,
    Email VARCHAR(200) NOT NULL,
    Telefono VARCHAR(200) NOT NULL,
    Puntaje INT NOT NULL,
    FotoPerfil VARCHAR(200),
    Descripcion VARCHAR(200),
    FechaNacimiento DATE
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

CREATE PROCEDURE SP_CrearPerfil
    @Nombre VARCHAR(200),
    @Apellido VARCHAR(200),
    @Genero INT,
    @Pais INT,
    @FechaNacimiento DATE,
    @NumeroTelefono VARCHAR(200),
    @Email VARCHAR(200),
    @Contraseña VARCHAR(200),
    @IdRol INT
AS
BEGIN
    DECLARE @Edad INT,
    DECLARE @AñoActual DATE,
    DECLARE @Puntaje INT,
    DECLARE @IdRango INT

    SET @AñoActual = GETDATE();
    SET @Puntaje = 0;
    SET @IdRango = 1;
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, @AñoActual);

    IF (MONTH(@FechaNacimiento) > MONTH(AñoActual) OR
        (MONTH(@FechaNacimiento) = MONTH(AñoActual) AND DAY(@FechaNacimiento) > DAY(@AñoActual)))
    BEGIN
        SET @Edad = @Edad - 1;
    END;

    INSERT INTO Usuarios(Nombre, Apellido, IdGenero, IdPais, FechaNacimiento, NumeroTelefono, Email, Contraseña, Edad, IdRol, IdRango)
    VALUES(@Nombre, @Apellido, @Genero, @Pais, @FechaNacimiento, @NumeroTelefono, @Email, @Contraseña, @Edad, @IdRol, @IdRango);
END