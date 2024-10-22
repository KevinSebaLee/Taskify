CREATE DATABASE Taskify;

USE Taskify;

CREATE TABLE Roles(
    IdRol INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(200),
    Imagen VARCHAR(200)
);

CREATE TABLE Rangos(
    IdRango INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200) NOT NULL,
    Color VARCHAR(200) NOT NULL
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
    IdProyecto INT NOT NULL PRIMARY KEY IDENTITY(1, 1) ,
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES Categorias(IdCategoria),
    IdRol INT NOT NULL FOREIGN KEY REFERENCES Roles(IdRol),
    Nombre VARCHAR(200),
    NombreEmpresa VARCHAR(200),
    Ubicacion VARCHAR(200),
    FechaPublicacion DATE NOT NULL,
    CantIntegrantes INT NOT NULL,
    Descripcion VARCHAR(200),
    Valoracion INT NOT NULL,
    Estado BIT
);

CREATE TABLE Generos(
    IdGenero INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(200)
);

CREATE TABLE Paises(
    IdPais INT NOT NULL  PRIMARY KEY IDENTITY(1, 1),
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
    DECLARE @Edad INT;
    DECLARE @AñoActual DATE;
    DECLARE @Puntaje INT = 0;
    DECLARE @IdRango INT = 1;

    SET @AñoActual = GETDATE();
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, @AñoActual);

    IF (MONTH(@FechaNacimiento) > MONTH(@AñoActual) OR
        (MONTH(@FechaNacimiento) = MONTH(@AñoActual) AND DAY(@FechaNacimiento) > DAY(@AñoActual)))
    BEGIN
        SET @Edad = @Edad - 1;
    END;

    INSERT INTO Usuarios(Nombre, Apellido, IdGenero, IdPais, FechaNacimiento, Telefono, Email, Contraseña, Edad, IdRol, IdRango, Puntaje)
    VALUES(@Nombre, @Apellido, @Genero, @Pais, @FechaNacimiento, @NumeroTelefono, @Email, @Contraseña, @Edad, @IdRol, @IdRango, @Puntaje);
END;

CREATE PROCEDURE SP_CrearProyecto
    @Nombre VARCHAR(200),
    @NombreEmpresa VARCHAR(200),
    @IdCategoria INT,
    @IdRol INT,
    @Ubicacion VARCHAR(200),
    @FechaPublicacion DATE,
    @Descripcion VARCHAR(200)
AS
BEGIN
    DECLARE @CantIntegrantes INT = 1;
    DECLARE @Valoracion INT = 0;

    INSERT INTO Proyectos(IdCategoria, IdRol, Nombre, NombreEmpresa, Ubicacion, FechaPublicacion, CantIntegrantes, Valoracion, Descripcion)
    VALUES(@IdCategoria, @IdRol, @Nombre, @NombreEmpresa, @Ubicacion, @FechaPublicacion, @CantIntegrantes, @Valoracion, @Descripcion);
END

CREATE PROCEDURE SP_Login
    @Email VARCHAR(200),
    @Contraseña VARCHAR(200)
AS
BEGIN
    SELECT Usuarios.*
    FROM Usuarios
    WHERE Email = @Email AND Contraseña = @Contraseña;
END

INSERT INTO Generos(Nombre) VALUES
('Masculino'),
('Femenino')

INSERT INTO Rangos(Nombre, Color) VALUES
('Bronce I', '#c0620a'),
('Bronce II', '#c0620a'),
('Bronce III', '#c0620a'),
('Plata I', '#c7c7c7'),
('Plata II', '#c7c7c7'),
('Plata III', '#c7c7c7'),
('Platino I', '#797878'),
('Platino II', '#797878'),
('Platino III', '#797878'),
('Diamante I', '#10cdc2'),
('Diamante II', '#10cdc2'),
('Diamante III', '#10cdc2')

INSERT INTO Categorias(Nombre) VALUES
('Desarrollo de Software'),
('Inteligencia Artificial'),
('Desarrollo Web'),
('Big Data'),
('Ciberseguridad'),
('IoT (Internet de las Cosas)'),
('Aplicaciones Móviles'),
('Realidad Aumentada y Virtual'),
('Blockchain'),
('Automatización de Procesos');

INSERT INTO Roles(Nombre, Imagen) VALUES
('Desarrollador', 'https://img.icons8.com/?size=256w&id=2264&format=png'),
('Administrador de Sistemas', 'https://img.icons8.com/?size=256w&id=9bjHQ56ezpj1&format=png'),
('Ingeniero DevOps', 'https://img.icons8.com/?size=256w&id=9VkgHjEOTadU&format=png'),
('Analista de Seguridad', 'https://img.icons8.com/?size=256w&id=39138&format=png'),
('Administrador de Base de Datos', 'https://img.icons8.com/?size=256w&id=11360&format=png'),
('Ingeniero de Soporte Técnico', 'https://img.icons8.com/?size=256w&id=6yWJYXNVngAT&format=png'),
('Analista de Datos', 'https://img.icons8.com/?size=256w&id=1476&format=png'),
('Tester/QA', 'https://img.icons8.com/?size=256w&id=IUz2CWOWjp51&format=png'),
('Especialista en UX/UI', 'https://img.icons8.com/?size=256w&id=53451&format=png'),
('Full-Stack Developer', 'https://img.icons8.com/?size=256w&id=wWh3KNXLFm0y&format=png'),
('Back-End Developer', 'https://img.icons8.com/?size=256w&id=SBEjRDmczSCC&format=png'),
('Front-End Developer', 'https://img.icons8.com/?size=256w&id=SBEjRDmczSCC&format=png')

INSERT INTO Paises(Nombre) VALUES
('Afganistán Emirato Islámico'),
('Afganistán República Islámica'),
('Albania'),
('Alemania'),
('Andorra'),
('Angola'),
('Antigua y Barbuda'),
('Arabia Saudita'),
('Argelia'),
('Argentina'),
('Armenia'),
('Australia'),
('Austria'),
('Azerbaiyán'),
('Bahamas'),
('Barbados'),
('Baréin'),
('Bélgica'),
('Belice'),
('Benín'),
('Bielorrusia'),
('Bolivia'),
('Bosnia y Herzegovina'),
('Botsuana'),
('Brasil'),
('Brunéi'),
('Bulgaria'),
('Burkina Faso'),
('Burundi'),
('Cabo Verde'),
('Camboya'),
('Camerún'),
('Canadá'),
('Catar'),
('Chile'),
('China'),
('Chipre'),
('Colombia'),
('Comoras'),
('Congo, República del'),
('Congo, República Democrática del'),
('Corea del Norte'),
('Corea del Sur'),
('Costa Rica'),
('Croacia'),
('Cuba'),
('Dinamarca'),
('Dominica'),
('Dominicana, República'),
('Ecuador'),
('Egipto'),
('El Salvador'),
('Emiratos Árabes Unidos'),
('Eslovaquia'),
('Eslovenia'),
('España'),
('Estonia'),
('Eswatini'),
('Etiopía'),
('Fiji'),
('Filipinas'),
('Finlandia'),
('Francia'),
('Gambia'),
('Georgia'),
('Ghana'),
('Grecia'),
('Guatemala'),
('Guyana'),
('Haití'),
('Holanda'),
('Honduras'),
('Hungría'),
('India'),
('Indonesia'),
('Irak'),
('Irán'),
('Irlanda'),
('Isla de Man'),
('Islas Marshall'),
('Islas Salomón'),
('Islandia'),
('Islas Vírgenes, Estados Unidos'),
('Islas Vírgenes, Reino Unido'),
('Italia'),
('Jamaica'),
('Japón'),
('Jordania'),
('Kazajistán'),
('Kenia'),
('Kirguistán'),
('Kiribati'),
('Kuwait'),
('Laos'),
('Lesoto'),
('Letonia'),
('Líbano'),
('Liberia'),
('Libia'),
('Lituania'),
('Luxemburgo'),
('Malasia'),
('Malaui'),
('Maldivas'),
('Malta'),
('Marruecos'),
('México'),
('Micronesia'),
('Mónaco'),
('Mongolia'),
('Mozambique'),
('Namibia'),
('Nauru'),
('Nepal'),
('Nicaragua'),
('Níger'),
('Nigeria'),
('Noruega'),
('Nueva Zelanda'),
('Omán'),
('Pakistán'),
('Palaos'),
('Panamá'),
('Papúa Nueva Guinea'),
('Paraguay'),
('Perú'),
('Polonia'),
('Portugal'),
('Reino Unido'),
('República Centroafricana'),
('República Checa'),
('República del Congo'),
('República Dominicana'),
('Rumanía'),
('Rusia'),
('Sáhara Occidental'),
('Samoa'),
('San Cristóbal y Nieves'),
('San Marino'),
('Santa Lucía'),
('Santo Tomé y Príncipe'),
('Senegal'),
('Serbia'),
('Seychelles'),
('Sierra Leona'),
('Singapur'),
('Eslovenia'),
('Somalia'),
('Sudáfrica'),
('Sudán'),
('Suecia'),
('Suiza'),
('Siria'),
('Tailandia'),
('Tanzania'),
('Timor Oriental'),
('Togo'),
('Tonga'),
('Trinidad y Tobago'),
('Túnez'),
('Turkmenistán'),
('Turquía'),
('Tuvalu'),
('Ucrania'),
('Uganda'),
('Uruguay'),
('Vanuatu'),
('Vaticano'),
('Venezuela'),
('Vietnam'),
('Yemen'),
('Zambia'),
('Zimbabue')