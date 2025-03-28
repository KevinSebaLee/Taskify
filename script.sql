CREATE DATABASE Taskify;

USE Taskify;

CREATE TABLE Roles(
    IdRol INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(200),
    Imagen NVARCHAR(200)
);

CREATE TABLE Rangos(
    IdRango INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200) NOT NULL,
    Color NVARCHAR(200) NOT NULL
);

CREATE TABLE Lenguajes(
    IdLenguaje INt NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(200) NOT NULL
);

CREATE TABLE Tasks(
    IdTask INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdLenguaje INT NOT NULL FOREIGN KEY REFERENCES Lenguajes(IdLenguaje),
    Area NVARCHAR(200) NOT NULL,
    Titulo NVARCHAR(200) NOT NULL,
    FechaPubli Date NOT NULL,
    Progreso INT NOT NULL
);

CREATE TABLE Consigna(
    IdConsigna INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdTask INT NOT NULL FOREIGN KEY REFERENCES Tasks(IdTask),
    Pregunta NVARCHAR(200) NOT NULL,
    Foto NVARCHAR(200)
);

CREATE TABLE RespuestaPregunta(
    IdRespuesta INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdConsigna INT NOT NULL FOREIGN KEY REFERENCES Consigna(IdConsigna),
    Contenido NVARCHAR(200) NOT NULL,
    Opcion INT NOT NULL,
    EsCorrecta BIT NOT NULL
);

CREATE TABLE Certificados(
    IdCertificado INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdTask INT NOT NULL FOREIGN KEY REFERENCES Tasks(IdTask),
    Nombre NVARCHAR(200) NOT NULL,
    Area NVARCHAR(200) NOT NULL,
);

CREATE TABLE Categorias(
    IdCategoria INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(200)
);

CREATE TABLE Generos(
    IdGenero INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200)
);

CREATE TABLE Paises(
    IdPais INT NOT NULL  PRIMARY KEY IDENTITY(1, 1),
    Nombre NVARCHAR(200)
)

CREATE TABLE Usuarios(
    IdUsuario INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdRol INT NOT NULL FOREIGN KEY REFERENCES Roles(IdRol),
	IdRango INT NOT NULL FOREIGN KEY REFERENCES Rangos(IdRango),
	IdCertificado INT FOREIGN KEY REFERENCES Certificados(IdCertificado),
    IdGenero INT NOT NULL FOREIGN KEY REFERENCES Generos(IdGenero),
    IdPais INT NOT NULL FOREIGN KEY REFERENCES Paises(IdPais),
    Nombre NVARCHAR(200) NOT NULL,
    Apellido NVARCHAR(200) NOT NULL,
    Contraseña NVARCHAR(200) NOT NULL,
    Edad INT NOT NULL,
    Email NVARCHAR(200) NOT NULL,
    Telefono NVARCHAR(200) NOT NULL,
    Puntaje INT NOT NULL,
    FotoPerfil NVARCHAR(200),
    Descripcion NVARCHAR(200),
    FechaNacimiento DATE
);

CREATE TABLE Proyectos(
    IdProyecto INT NOT NULL PRIMARY KEY IDENTITY(1, 1) ,
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES Categorias(IdCategoria),
    IdCreadorUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    Nombre NVARCHAR(200),
    NombreEmpresa NVARCHAR(200),
    Ubicacion NVARCHAR(200),
    FechaPublicacion DATETIME NOT NULL,
    CantIntegrantes INT NOT NULL,
    Descripcion NVARCHAR(200),
    Valoracion INT NOT NULL,
    Estado BIT
);

CREATE TABLE ProyectosXRol(
    IdProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyectos(IdProyecto),
    IdRol INT NOT NULL FOREIGN KEY REFERENCES Roles(IdRol)
);

CREATE TABLE UsuarioXProyecto(
    IdProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyectos(IdProyecto),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario)
);

CREATE TABLE Chats(
    IdChat INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Nombrechat NVARCHAR(200) NOT NULL,
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
    Contenido NVARCHAR(700) NOT NULL,
    Hora DATE NOT NULL,
    EsLeido BIT
);

CREATE TABLE Contactos(
    IdContacto INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    Nombre NVARCHAR(200) NOT NULL,
    Telefono NVARCHAR(200) NOT NULL,
    Email NVARCHAR(200) NOT NULL,
);

CREATE TABLE Eventos(
    IdEvento INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
    IdContacto INT FOREIGN KEY REFERENCES Contactos(IdContacto),
    Nombre NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(200) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL
);

CREATE TABLE Preguntas(
	IdPregunta INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	IdUsuarioCreador INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
	Titulo NVARCHAR(200) NOT NULL,
	Preguntas NVARCHAR(200) NOT NULL
);

CREATE TABLE RespuestaChat(
	IdRespuesta INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	IdPregunta INT NOT NULL FOREIGN KEY REFERENCES Preguntas(IdPregunta),
	IdUsuarioPregunta INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
	RespuestaCommunity NVARCHAR(200) NOT NULL
);

CREATE PROCEDURE [dbo].[SP_CrearPerfil]
    @Nombre NVARCHAR(200),
    @Apellido NVARCHAR(200),
    @Genero INT,
    @Pais INT,
    @FechaNacimiento DATE,
    @NumeroTelefono NVARCHAR(200),
    @Email NVARCHAR(200),
    @Contraseña NVARCHAR(200),
    @IdRol INT
AS
BEGIN
    DECLARE @Edad INT;
    DECLARE @AñoActual DATE;
    DECLARE @Puntaje INT = 0;
    DECLARE @IdRango INT = 1;
	DECLARE @HashedPassword NVARCHAR(64);

	SET @HashedPassword = CONVERT(NVARCHAR(64), HASHBYTES('SHA2_256', @Contraseña), 2);

    SET @AñoActual = GETDATE();
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, @AñoActual);

    IF (MONTH(@FechaNacimiento) > MONTH(@AñoActual) OR
        (MONTH(@FechaNacimiento) = MONTH(@AñoActual) AND DAY(@FechaNacimiento) > DAY(@AñoActual)))
    BEGIN
        SET @Edad = @Edad - 1;
    END;

    INSERT INTO Usuarios(Nombre, Apellido, IdGenero, IdPais, FechaNacimiento, Telefono, Email, Contraseña, Edad, IdRol, IdRango, Puntaje)
    VALUES(@Nombre, @Apellido, @Genero, @Pais, @FechaNacimiento, @NumeroTelefono, @Email, @HashedPassword, @Edad, @IdRol, @IdRango, @Puntaje);
END;

CREATE PROCEDURE SP_CrearProyecto
    @Nombre NVARCHAR(200),
    @NombreEmpresa NVARCHAR(200),
    @IdCategoria INT,
    @IdRol INT,
	@IdCreadorUsuario INT,
    @Ubicacion NVARCHAR(200),
    @FechaPublicacion DATETIME,
    @Descripcion NVARCHAR(200)
AS
BEGIN
    DECLARE @CantIntegrantes INT = 1;
    DECLARE @Valoracion INT = 0;

    INSERT INTO Proyectos(IdCategoria, IdCreadorUsuario, Nombre, NombreEmpresa, Ubicacion, FechaPublicacion, CantIntegrantes, Valoracion, Descripcion)
    VALUES(@IdCategoria, @IdCreadorUsuario, @Nombre, @NombreEmpresa, @Ubicacion, @FechaPublicacion, @CantIntegrantes, @Valoracion, @Descripcion);
END

CREATE PROCEDURE SP_CrearPregunta
	@IdUsuarioCreador INT,
	@Titulo NVARCHAR(200),
	@Pregunta NVARCHAR(200)
AS
BEGIN
	INSERT INTO Preguntas(IdUsuarioCreador, Titulo, Preguntas)
	VALUES(@IdUsuarioCreador, @Titulo, @Pregunta)
END

CREATE PROCEDURE [dbo].[SP_CrearRespuesta]
	@IdPregunta INT,
	@IdUsuarioPregunta INT,
	@RespuestaPregunta NVARCHAR(200)
AS
BEGIN
	INSERT INTO RespuestaChat(IdPregunta, IdUsuarioPregunta, RespuestaCommunity)
	VALUES(@IdPregunta, @IdUsuarioPregunta, @RespuestaPregunta)
END

CREATE PROCEDURE SP_Login
    @Email NVARCHAR(200),
    @Contraseña NVARCHAR(200)
AS
BEGIN
	DECLARE @HashedPassword NVARCHAR(64);
    SET @HashedPassword = CONVERT(NVARCHAR(64), HASHBYTES('SHA2_256', @Contraseña), 2);

    SELECT Usuarios.* FROM Usuarios WHERE Email = @Email AND Contraseña = @HashedPassword;
END

INSERT INTO Generos(Nombre) VALUES
('Masculino'),
('Femenino'),
('Otros')

INSERT INTO Rangos(Nombre, Color) VALUES
('Bronce I', '#c0620a'),
('Bronce II', '#c0620a'),
('Bronce III', '#c0620a'),
('Plata I', '#c7c7c7'),
('Plata II', '#c7c7c7'),
('Plata III', '#c7c7c7'),
('Oro I', '#ffd700'),
('Oro II', '#ffd700'),
('Oro III', '#ffd700'),
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

INSERT INTO lenguajes (NOMBRE, DESCRIPCION) VALUES
('Python', 'Lenguaje de programación interpretado, de alto nivel y con énfasis en la legibilidad del código. Muy popular en ciencia de datos, desarrollo web y automatización.'),
('JavaScript', 'Lenguaje de programación interpretado utilizado principalmente en desarrollo web para crear páginas interactivas y dinámicas.'),
('Java', 'Lenguaje de programación orientado a objetos, ampliamente utilizado en aplicaciones empresariales, desarrollo de Android y sistemas grandes.'),
('C', 'Lenguaje de programación de bajo nivel que permite la manipulación directa de memoria. Es base de otros lenguajes como C++ y C#.'),
('C++', 'Lenguaje de programación basado en C, pero con características de programación orientada a objetos. Se usa en desarrollo de videojuegos, sistemas y aplicaciones de alto rendimiento.'),
('Ruby', 'Lenguaje de programación dinámico y de alto nivel, conocido por su simplicidad y elegancia. Popular en el desarrollo web con Ruby on Rails.'),
('Go', 'Lenguaje de programación de código abierto creado por Google. Es conocido por su eficiencia en concurrencia y alto rendimiento en sistemas distribuidos.'),
('Swift', 'Lenguaje de programación desarrollado por Apple para crear aplicaciones en sus plataformas como iOS, macOS, watchOS y tvOS.'),
('PHP', 'Lenguaje de programación de código abierto, utilizado principalmente en el desarrollo web del lado del servidor. Es especialmente popular en el desarrollo de aplicaciones dinámicas.'),
('R', 'Lenguaje de programación y entorno de software para la estadística y el análisis de datos, ampliamente utilizado en investigación y ciencia de datos.');

INSERT INTO tasks (IdLenguaje, Area, Titulo, FechaPubli, Progreso) VALUES
(1, 'Automatización de Tareas', 'Automatizar la recolección de datos con Python', '2024-09-05', 50),
(2, 'Desarrollo Web', 'Desarrollar una aplicación de chat en tiempo real con Node.js y Socket.io', '2024-10-12', 80),
(5, 'Desarrollo de Software', 'Crear un sistema de gestión de inventarios con Ruby on Rails', '2024-07-30', 10),
(6, 'Ciencia de Datos', 'Análisis de grandes volúmenes de datos usando R para la predicción de ventas', '2024-10-15', 60);

-- Tópico 1: Python - Automatización de Tareas
INSERT INTO consigna (IdTask, Pregunta) VALUES
(1, '¿Cómo puedes utilizar Python para automatizar tareas repetitivas en tu sistema?'),
(1, '¿Qué librerías de Python son más populares para realizar scraping web?'),
(1, 'Explica cómo usar Python para crear un script que recupere datos de una API pública.'),
(1, '¿Qué es el módulo `os` en Python y cómo puede ayudarte en la automatización de tareas?'),
(1, 'Menciona al menos tres casos de uso donde Python sea ideal para automatización de procesos.'),
(1, '¿Cómo puedes automatizar el envío de correos electrónicos con Python?'),
(1, 'Explica cómo puedes programar tareas recurrentes en Python utilizando el módulo `schedule`.'),
(1, '¿Qué es `Selenium` y cómo puede ayudarte a automatizar interacciones con un navegador web?'),
(1, '¿Cuál es la importancia de los `cron jobs` en combinación con Python para la automatización de procesos?'),
(1, '¿Cómo puedes usar Python para procesar archivos CSV de manera automática?'),
(1, '¿Qué ventajas tiene la automatización de tareas con Python frente a otras herramientas de programación?'),
(1, '¿Cómo puedes utilizar Python para organizar y mover archivos automáticamente en un directorio?'),
(1, '¿Qué consideraciones de seguridad debes tener en cuenta al automatizar tareas en Python?'),
(1, '¿Cómo puedes crear un script en Python para generar informes automáticos a partir de datos de bases de datos?'),
(1, '¿Qué es `pyautogui` y cómo puede ayudarte a automatizar la interacción con la interfaz gráfica del sistema operativo?'),
(1, '¿Cómo puedes usar Python para monitorear un directorio y ejecutar acciones automáticamente cuando cambien los archivos?'),
(1, 'Explica cómo utilizar `BeautifulSoup` y `requests` para automatizar la recolección de datos desde un sitio web.'),
(1, '¿Qué desafíos pueden surgir al automatizar tareas complejas en Python y cómo podrías abordarlos?'),
(1, '¿Cómo puedes usar Python para crear un archivo de log que registre las acciones realizadas por tus scripts de automatización?'),
(1, '¿Qué es un “web scraper” y cómo lo puedes construir utilizando Python?');

-- Tópico 2: JavaScript - Desarrollo Web
INSERT INTO consigna (IdTask, Pregunta) VALUES
(2, '¿Cómo JavaScript mejora la interactividad de las páginas web?'),
(2, '¿Qué es el modelo de objetos del documento (DOM) y cómo interactúa JavaScript con él?'),
(2, 'Explica la diferencia entre `var`, `let` y `const` en JavaScript.'),
(2, '¿Cómo puedes manejar eventos en JavaScript y cuáles son los tipos de eventos más comunes?'),
(2, '¿Cómo puedes realizar una petición HTTP usando JavaScript para obtener datos de un servidor?'),
(2, '¿Qué es AJAX y cómo se utiliza en JavaScript para cargar contenido de manera asíncrona?'),
(2, 'Explica qué es la promesa en JavaScript y cómo se utiliza para manejar operaciones asincrónicas.'),
(2, '¿Cómo puedes manipular los estilos de una página web usando JavaScript?'),
(2, '¿Qué son las funciones flecha (`arrow functions`) y cómo se diferencian de las funciones tradicionales en JavaScript?'),
(2, '¿Cómo puedes validar formularios en el lado del cliente usando JavaScript?'),
(2, 'Explica qué es un "callback" en JavaScript y cómo se utilizan en la programación asincrónica.'),
(2, '¿Cuál es la importancia de `localStorage` y `sessionStorage` en JavaScript para almacenar datos en el navegador?'),
(2, '¿Cómo puedes gestionar errores y excepciones en JavaScript usando `try`, `catch`, y `finally`?'),
(2, '¿Qué es una SPA (Single Page Application) y cómo JavaScript facilita su desarrollo?'),
(2, 'Explica el concepto de "closure" en JavaScript y da un ejemplo práctico.'),
(2, '¿Cómo puedes realizar una redirección en JavaScript a otra página web o URL?'),
(2, '¿Qué es `fetch` en JavaScript y cómo puedes usarlo para hacer peticiones HTTP?'),
(2, '¿Cómo se pueden crear animaciones y transiciones en JavaScript para mejorar la experiencia de usuario?'),
(2, 'Explica el uso de `setTimeout` y `setInterval` en JavaScript y da un ejemplo de cada uno.'),
(2, '¿Qué son las plantillas literales (template literals) y cómo facilitan la creación de cadenas de texto en JavaScript?');

-- Tópico 3: Ruby on Rails - Desarrollo de Software
INSERT INTO consigna (IdTask, Pregunta) VALUES
(3, '¿Qué es Ruby on Rails y por qué se considera un framework eficiente para el desarrollo web?'),
(3, '¿Cómo puedes crear un nuevo proyecto de Ruby on Rails desde cero?'),
(3, 'Explica el patrón de arquitectura MVC en el contexto de Ruby on Rails.'),
(3, '¿Qué son los "migraciones" en Ruby on Rails y cómo se utilizan para modificar la base de datos?'),
(3, '¿Cómo puedes manejar relaciones entre modelos en Ruby on Rails, como "has_many" y "belongs_to"?'),
(3, 'Explica cómo crear una ruta personalizada en Ruby on Rails y qué archivo se debe modificar para hacerlo.'),
(3, '¿Qué son los "scaffolds" en Rails y cómo ayudan a acelerar el desarrollo de una aplicación?'),
(3, '¿Qué es ActiveRecord en Ruby on Rails y cómo se utiliza para interactuar con bases de datos?'),
(3, '¿Cómo puedes validar los datos de un formulario en Ruby on Rails?'),
(3, 'Explica cómo se implementa la autenticación de usuarios en Ruby on Rails.'),
(3, '¿Qué son las "seeds" en Rails y cómo se utilizan para poblar la base de datos con datos de prueba?'),
(3, '¿Cómo puedes realizar una consulta compleja en Rails utilizando ActiveRecord?'),
(3, 'Explica cómo Rails maneja la autenticación de sesiones y cookies.'),
(3, '¿Cómo puedes optimizar el rendimiento de una aplicación Ruby on Rails?'),
(3, '¿Cómo se maneja el enrutamiento en Rails y qué es el archivo `routes.rb`?'),
(3, 'Explica el uso de los "partials" en Rails para reutilizar código en vistas.'),
(3, '¿Qué son los "concerns" en Ruby on Rails y cómo pueden ayudar a organizar mejor el código?'),
(3, '¿Cómo puedes generar una nueva migración en Rails para agregar un campo a una tabla existente?'),
(3, 'Explica cómo configurar un entorno de pruebas en Ruby on Rails utilizando RSpec o MiniTest.');

-- Tópico 4: R - Ciencia de Datos
INSERT INTO consigna (IdTask, Pregunta) VALUES
(4, '¿Cómo puedes cargar un conjunto de datos en R utilizando la función `read.csv`?'),
(4, 'Explica qué son los data frames en R y cómo se utilizan para almacenar datos tabulares.'),
(4, '¿Cómo puedes manejar valores faltantes (NA) en un conjunto de datos en R?'),
(4, '¿Qué es una variable categórica en R y cómo se puede representar visualmente?'),
(4, '¿Cómo puedes realizar un análisis exploratorio de datos en R utilizando el paquete `ggplot2`?'),
(4, 'Explica cómo crear y manipular una serie temporal en R utilizando el paquete `zoo`.'),
(4, '¿Qué son las funciones de agregación en R y cómo puedes utilizarlas para resumir datos?'),
(4, '¿Cómo puedes aplicar un modelo de regresión lineal en R usando el paquete `lm`?'),
(4, '¿Qué son las "funciones anónimas" en R y en qué situaciones pueden ser útiles?'),
(4, 'Explica cómo realizar una validación cruzada para un modelo de machine learning en R.'),
(4, '¿Cómo puedes visualizar la distribución de una variable numérica en R usando `hist()`?'),
(4, '¿Qué es la "normalización" de datos y cómo se puede realizar en R?'),
(4, '¿Cómo puedes realizar un análisis de correlación entre dos variables en R?'),
(4, 'Explica el concepto de "overfitting" y cómo prevenirlo al construir modelos predictivos en R.'),
(4, '¿Cómo se puede usar el paquete `dplyr` para manipular y transformar datos en R?'),
(4, '¿Qué es un modelo de clasificación en R y cómo se entrena uno con `rpart`?'),
(4, 'Explica cómo crear una matriz de confusión en R y qué información nos proporciona.'),
(4, '¿Cómo puedes aplicar un análisis de componentes principales (PCA) en R para reducción de dimensionalidad');

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta) VALUES 
( 1, N'Usando bibliotecas como `os`, `shutil` y `subprocess` para automatizar tareas del sistema', 1, 1),
( 1, N'Usando Python únicamente para crear interfaces gráficas', 2, 0),
( 1, N'Automatizando tareas con herramientas como Task Scheduler o Cron', 3, 0),
( 1, N'Utilizando Python para generar documentación de código automáticamente', 4, 0),
( 2, N'Las librerías más populares son `BeautifulSoup`, `Scrapy` y `Selenium`', 1, 1),
( 2, N'Las librerías más populares son `NumPy` y `Pandas`', 2, 0),
( 2, N'La librería más popular es `os`', 3, 0),
( 2, N'No es posible hacer scraping con Python', 4, 0),
( 3, N'Utilizando `requests` para hacer solicitudes HTTP y `json` para procesar los datos', 1, 1),
( 3, N'Usando `matplotlib` para representar los datos de la API', 2, 0),
( 3, N'Usando `tkinter` para crear una interfaz gráfica que consuma la API', 3, 0),
( 3, N'Creando una API RESTful con Flask para consumir los datos', 4, 0),
( 4, N'El módulo `os` permite interactuar con el sistema operativo, manejar archivos y directorios, y ejecutar comandos del sistema', 1, 1),
( 4, N'El módulo `os` permite crear interfaces gráficas', 2, 0),
( 4, N'El módulo `os` está diseñado para la automatización de redes', 3, 0),
( 4, N'El módulo `os` es utilizado solo para crear aplicaciones web', 4, 0),
( 5, N'Automatización de tareas repetitivas, procesamiento de datos en lote y envío de correos electrónicos', 1, 1),
( 5, N'Automatización de gráficos 3D en videojuegos', 2, 0),
( 5, N'Automatización de transacciones bancarias', 3, 0),
( 5, N'Automatización de tareas exclusivamente para servidores web', 4, 0),
( 6, N'Usando la librería `smtplib` para enviar correos con un script en Python', 1, 1),
( 6, N'Usando `matplotlib` para crear gráficos en los correos', 2, 0),
( 6, N'Utilizando `requests` para interactuar con servicios de correo', 3, 0),
( 6, N'No es posible automatizar el envío de correos en Python', 4, 0),
( 7, N'Utilizando el módulo `schedule` para ejecutar funciones en intervalos regulares', 1, 1),
( 7, N'Usando `tkinter` para crear una interfaz que permita programar tareas', 2, 0),
( 7, N'Utilizando `flask` para crear una API que controle la programación de tareas', 3, 0),
( 7, N'Usando `pygame` para crear una interfaz de usuario para tareas programadas', 4, 0),
( 8, N'Selenium es una herramienta para automatizar navegadores web y realizar pruebas de interfaz de usuario', 1, 1),
( 8, N'Selenium es una librería de Python para crear interfaces gráficas', 2, 0),
( 8, N'Selenium es una herramienta para crear APIs RESTful', 3, 0),
( 8, N'Selenium es utilizado para crear bases de datos en Python', 4, 0),
( 9, N'Los `cron jobs` son procesos programados en el sistema operativo que permiten ejecutar scripts de Python automáticamente', 1, 1),
( 9, N'Los `cron jobs` se utilizan únicamente para tareas en servidores web', 2, 0),
( 9, N'Los `cron jobs` son una característica exclusiva de Windows', 3, 0),
( 9, N'No se puede usar `cron jobs` para la automatización con Python', 4, 0),
( 10, N'Utilizando la librería `csv` de Python para leer y escribir archivos CSV automáticamente', 1, 1),
( 10, N'Utilizando `flask` para crear un servidor web que gestione los archivos CSV', 2, 0),
( 10, N'Usando `matplotlib` para visualizar los archivos CSV', 3, 0),
( 10, N'Automatizando el procesamiento de archivos CSV con `pygame`', 4, 0),
( 12, N'Puedes usar la librería `shutil` para mover archivos, y `os` para renombrarlos o eliminarlos', 1, 1),
( 12, N'Utilizando solo `tkinter` para organizar archivos en una interfaz gráfica', 2, 0),
( 12, N'Puedes usar `pygame` para mover archivos', 3, 0),
( 12, N'No es posible mover archivos con Python', 4, 0),
( 13, N'Debes tener en cuenta el manejo de permisos de archivos, la validación de datos y la protección contra inyecciones de código', 1, 1),
( 13, N'La seguridad no es un aspecto relevante en la automatización con Python', 2, 0),
( 13, N'La seguridad es solo importante en aplicaciones web, no en scripts de automatización', 3, 0),
( 13, N'No es necesario implementar ningún tipo de seguridad en tus scripts de automatización', 4, 0),
( 14, N'Puedes usar `pandas` para procesar los datos y `matplotlib` para generar gráficos automáticamente', 1, 1),
( 14, N'Es necesario usar `tkinter` para crear la interfaz gráfica para la generación de informes', 2, 0),
( 14, N'Utilizando `pygame` para crear gráficos interactivos a partir de los datos de la base de datos', 3, 0),
( 14, N'No es posible generar informes con Python', 4, 0),
( 15, N'`pyautogui` permite automatizar interacciones con la interfaz gráfica del sistema operativo, como hacer clic y escribir texto', 1, 1),
( 15, N'`pyautogui` se utiliza solo para crear gráficos interactivos', 2, 0),
( 15, N'`pyautogui` es una librería para interactuar con bases de datos', 3, 0),
( 15, N'No es posible automatizar interacciones con la interfaz gráfica en Python', 4, 0),
( 16, N'Usando `watchdog` para monitorear el directorio y ejecutar un script cuando cambian los archivos', 1, 1),
( 16, N'Usando `tkinter` para crear una interfaz gráfica que monitoree los cambios en un directorio', 2, 0),
( 16, N'Usando `pygame` para monitorear directorios', 3, 0),
( 16, N'Todas son correctas', 4, 0),
( 17, N'Usando `subprocess` para ejecutar comandos en el sistema', 1, 1),
( 17, N'Usando `random` para crear interfaces gráficas', 2, 0),
( 17, N'Usando `collections` para monitorear directorios', 3, 0),
( 17, N'Todas son correctas', 4, 0),
( 11, N'Usando `schedule` para programar tareas en intervalos de tiempo', 1, 1),
( 11, N'Usando `unittest` para monitorear directorios', 2, 0),
( 11, N'Usando `csv` para enviar correos electrónicos', 3, 0),
( 11, N'Todas son correctas', 4, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (18, 'Implementar herramientas para gestionar procesos de automatización', 1, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (18, 'Monitorear recursos y optimizar su uso en tiempo real', 2, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (18, 'Integrar estrategias para manejar errores de forma eficiente', 3, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (18, 'Todas las anteriores', 4, 1);


INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (19, 'Utilizar módulos para registrar eventos en archivos de texto', 1, 1);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (19, 'Diseñar reportes personalizados basados en las actividades del script', 2, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (19, 'Ejecutar pruebas automatizadas y documentar los resultados', 3, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (19, 'Generar datos históricos para análisis futuros', 4, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (20, 'Es una herramienta que extrae datos de páginas web', 1, 1);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (20, 'Permite acceder a bases de datos directamente desde el navegador', 2, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (20, 'Facilita la creación de interfaces gráficas complejas', 3, 0);

INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta)
VALUES (20, 'Es una técnica para procesar imágenes web de forma dinámica', 4, 0);


INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta) VALUES 

( 21, N'El DOM es una representación estructurada de la página web y JavaScript puede manipularlo', 1, 1),
( 21, N'El DOM es un modelo de datos que solo puede ser leído por el navegador, no modificado por JavaScript', 2, 0),
( 21, N'El DOM es un lenguaje de programación independiente de JavaScript', 3, 0),
( 21, N'El DOM es un sistema de archivos utilizado para almacenar imágenes en el servidor', 4, 0),

( 22, N'`var` tiene un alcance de función, `let` y `const` tienen un alcance de bloque', 1, 1),
( 22, N'`var`, `let` y `const` son completamente intercambiables en su uso en JavaScript', 2, 0),
( 22, N'`let` y `const` son utilizados solo para crear funciones en JavaScript', 3, 0),
( 22, N'`var` es la forma más moderna de declarar variables en JavaScript', 4, 0),

( 23, N'Puedes usar `addEventListener` para escuchar eventos como clics o movimientos del mouse', 1, 1),
( 23, N'JavaScript no tiene soporte para eventos, solo se puede usar en funciones sin interacciones', 2, 0),
( 23, N'Los eventos en JavaScript son solo para botones y formularios', 3, 0),
( 23, N'Sólo se pueden manejar eventos dentro de funciones `onclick` y `onmouseover`', 4, 0),

( 24, N'Utilizando `fetch` o `XMLHttpRequest` puedes realizar peticiones HTTP para obtener datos', 1, 1),
( 24, N'JavaScript no soporta la realización de peticiones HTTP de manera directa', 2, 0),
( 24, N'JavaScript solo puede realizar peticiones HTTP usando la API de Node.js', 3, 0),
( 24, N'JavaScript solo puede enviar datos, pero no recibirlos de un servidor', 4, 0),

( 25, N'AJAX permite la actualización asíncrona de partes de una página web sin recargarla completamente', 1, 1),
( 25, N'AJAX solo sirve para cargar imágenes de forma asíncrona', 2, 0),
( 25, N'AJAX solo puede usarse con el servidor local y no con servidores remotos', 3, 0),
( 25, N'AJAX es una librería que reemplaza JavaScript para hacer solicitudes', 4, 0),

( 26, N'Las promesas son objetos que representan el eventual valor de una operación asincrónica', 1, 1),
( 26, N'Las promesas se usan solo para manejar eventos de clic y no operaciones asincrónicas', 2, 0),
( 26, N'Las promesas bloquean el hilo principal de ejecución hasta que se completan', 3, 0),
( 26, N'Las promesas no pueden ser utilizadas con `async` y `await` en JavaScript', 4, 0),

( 27, N'Puedes manipular estilos con `document.getElementById().style` para cambiar propiedades CSS', 1, 1),
( 27, N'JavaScript no puede manipular estilos, solo HTML', 2, 0),
( 27, N'Se utilizan herramientas como SASS o LESS para manipular estilos con JavaScript', 3, 0),
( 27, N'JavaScript puede cambiar estilos, pero solo en el lado del servidor', 4, 0),

( 28, N'Las funciones flecha son una forma más compacta de escribir funciones anónimas en JavaScript', 1, 1),
( 28, N'Las funciones flecha no pueden recibir parámetros', 2, 0),
( 28, N'Las funciones flecha no tienen contexto propio para `this`', 3, 0),
( 28, N'Las funciones flecha se usan exclusivamente en métodos de objetos', 4, 0),

( 29, N'Puedes validar formularios usando `addEventListener` con el evento `submit` y validación personalizada', 1, 1),
( 29, N'JavaScript no puede validar formularios, solo HTML5 tiene esa capacidad', 2, 0),
( 29, N'JavaScript solo valida formularios en el servidor', 3, 0),
( 29, N'Sólo se pueden validar formularios con jQuery', 4, 0),

( 30, N'Un callback es una función que se pasa como argumento a otra función y se ejecuta más tarde', 1, 1),
( 30, N'Los callbacks solo sirven para manejar errores en JavaScript', 2, 0),
( 30, N'Un callback es una función que se ejecuta antes de que termine la función que la recibe', 3, 0),
( 30, N'Los callbacks son usados para manipular variables globales', 4, 0),

( 31, N'`localStorage` y `sessionStorage` permiten almacenar datos en el navegador de forma persistente o temporal', 1, 1),
( 31, N'`localStorage` solo almacena datos durante la sesión activa, mientras que `sessionStorage` es permanente', 2, 0),
( 31, N'`localStorage` y `sessionStorage` solo funcionan en la parte del servidor', 3, 0),
( 31, N'`localStorage` y `sessionStorage` no permiten almacenar objetos o arrays', 4, 0),

( 32, N'`try`, `catch` y `finally` permiten manejar excepciones, garantizando que siempre se ejecute un bloque de código', 1, 1),
( 32, N'Los bloques `try` y `catch` sólo pueden ser utilizados con funciones sin retorno', 2, 0),
( 32, N'El bloque `finally` puede evitar que se ejecute el bloque `catch`', 3, 0),
( 32, N'`try`, `catch` y `finally` solo se usan para manejar eventos', 4, 0),

( 33, N'Una SPA (Single Page Application) carga todo su contenido en una sola página HTML y cambia dinámicamente el contenido con JavaScript', 1, 1),
( 33, N'Una SPA requiere de múltiples recargas de la página para actualizar su contenido', 2, 0),
( 33, N'Las SPA no se pueden crear con JavaScript', 3, 0),
( 33, N'Las SPA son una forma de almacenar datos sin mostrarlos al usuario', 4, 0),

( 34, N'El concepto de "closure" se refiere a una función que mantiene acceso a su contexto léxico, incluso después de que la función externa haya terminado de ejecutarse', 1, 1),
( 34, N'El "closure" solo puede usarse en funciones anónimas dentro de objetos', 2, 0),
( 34, N'El "closure" se refiere a la capacidad de una función de almacenar valores globales', 3, 0),
( 34, N'El "closure" es una propiedad exclusiva de los ciclos `for`', 4, 0),

( 35, N'Puedes usar `window.location.href` para redirigir a otra URL en JavaScript', 1, 1),
( 35, N'JavaScript no permite redirecciones, sólo lo hace el servidor', 2, 0),
( 35, N'Sólo se puede redirigir mediante el uso de HTML', 3, 0),
( 35, N'La redirección en JavaScript se realiza con el método `redirect()`', 4, 0),

( 36, N'`fetch` es una API moderna que reemplaza a `XMLHttpRequest` para hacer solicitudes HTTP de forma más sencilla y legible', 1, 1),
( 36, N'`fetch` es obsoleto y solo se utiliza en versiones anteriores de JavaScript', 2, 0),
( 36, N'`fetch` solo puede realizar solicitudes a servidores locales y no a servidores remotos', 3, 0),
( 36, N'`fetch` se usa exclusivamente en el contexto de Node.js, no en navegadores', 4, 0),

( 37, N'Puedes usar `setTimeout` para ejecutar una función después de un tiempo específico y `setInterval` para ejecutar una función repetidamente', 1, 1),
( 37, N'`setTimeout` y `setInterval` solo sirven para crear animaciones en el navegador', 2, 0),
( 37, N'`setTimeout` es sinónimo de `setInterval` y viceversa', 3, 0),
( 37, N'`setTimeout` y `setInterval` solo se pueden usar para manipular eventos de usuario', 4, 0),

( 38, N'Las plantillas literales permiten incluir expresiones dentro de cadenas de texto utilizando `${}` para interpolación', 1, 1),
( 38, N'Las plantillas literales solo permiten cadenas de texto sin ninguna interpolación de valores', 2, 0),
( 38, N'Las plantillas literales requieren una sintaxis especial que no se puede usar dentro de funciones', 3, 0),
( 38, N'Las plantillas literales se usan para declarar funciones, no para trabajar con cadenas de texto', 4, 0);


-- INSERT INTO RespuestaPregunta (IdConsigna, Contenido, Opcion, EsCorrecta) VALUES 
-- ( 22, N'JavaScript permite la manipulación del DOM para actualizar dinámicamente el contenido de las páginas', 1, 1),
-- ( 22, N'JavaScript no tiene ningún impacto en la interactividad de las páginas web', 2, 0),
-- ( 22, N'JavaScript permite solo interacciones de entrada de datos del usuario', 3, 0),
-- ( 22, N'JavaScript se utiliza para mejorar la velocidad de carga de la página web', 4, 0),

-- ( 23, N'El DOM es una representación estructurada de la página web y JavaScript puede manipularlo', 1, 1),
-- ( 23, N'El DOM es un modelo de datos que solo puede ser leído por el navegador, no modificado por JavaScript', 2, 0),
-- ( 23, N'El DOM es un lenguaje de programación independiente de JavaScript', 3, 0),
-- ( 23, N'El DOM es un sistema de archivos utilizado para almacenar imágenes en el servidor', 4, 0),

-- ( 24, N'`var` tiene un alcance de función, `let` y `const` tienen un alcance de bloque', 1, 1),
-- ( 24, N'`var`, `let` y `const` son completamente intercambiables en su uso en JavaScript', 2, 0),
-- ( 24, N'`let` y `const` son utilizados solo para crear funciones en JavaScript', 3, 0),
-- ( 24, N'`var` es la forma más moderna de declarar variables en JavaScript', 4, 0),

-- ( 25, N'Puedes usar `addEventListener` para escuchar eventos como clics o movimientos del mouse', 1, 1),
-- ( 25, N'JavaScript no tiene soporte para eventos, solo se puede usar en funciones sin interacciones', 2, 0),
-- ( 25, N'Los eventos en JavaScript son solo para botones y formularios', 3, 0),
-- ( 25, N'Sólo se pueden manejar eventos dentro de funciones `onclick` y `onmouseover`', 4, 0),

-- ( 26, N'Utilizando `fetch` o `XMLHttpRequest` puedes realizar peticiones HTTP para obtener datos', 1, 1),
-- ( 26, N'JavaScript no soporta la realización de peticiones HTTP de manera directa', 2, 0),
-- ( 26, N'JavaScript solo puede realizar peticiones HTTP usando la API de Node.js', 3, 0),
-- ( 26, N'JavaScript solo puede enviar datos, pero no recibirlos de un servidor', 4, 0),

-- ( 27, N'AJAX permite la actualización asíncrona de partes de una página web sin recargarla completamente', 1, 1),
-- ( 27, N'AJAX solo sirve para cargar imágenes de forma asíncrona', 2, 0),
-- ( 27, N'AJAX solo puede usarse con el servidor local y no con servidores remotos', 3, 0),
-- ( 27, N'AJAX es una librería que reemplaza JavaScript para hacer solicitudes', 4, 0),

-- ( 28, N'Las promesas son objetos que representan el eventual valor de una operación asincrónica', 1, 1),
-- ( 28, N'Las promesas se usan solo para manejar eventos de clic y no operaciones asincrónicas', 2, 0),
-- ( 28, N'Las promesas bloquean el hilo principal de ejecución hasta que se completan', 3, 0),
-- ( 28, N'Las promesas no pueden ser utilizadas con `async` y `await` en JavaScript', 4, 0),

-- ( 29, N'Puedes manipular estilos con `document.getElementById().style` para cambiar propiedades CSS', 1, 1),
-- ( 29, N'JavaScript no puede manipular estilos, solo HTML', 2, 0),
-- ( 29, N'Se utilizan herramientas como SASS o LESS para manipular estilos con JavaScript', 3, 0),
-- ( 29, N'JavaScript puede cambiar estilos, pero solo en el lado del servidor', 4, 0),

-- ( 30, N'Las funciones flecha son una forma más compacta de escribir funciones anónimas en JavaScript', 1, 1),
-- ( 30, N'Las funciones flecha no pueden recibir parámetros', 2, 0),
-- ( 30, N'Las funciones flecha no tienen contexto propio para `this`', 3, 0),
-- ( 30, N'Las funciones flecha se usan exclusivamente en métodos de objetos', 4, 0),

-- ( 31, N'Puedes validar formularios usando `addEventListener` con el evento `submit` y validación personalizada', 1, 1),
-- ( 31, N'JavaScript no puede validar formularios, solo HTML5 tiene esa capacidad', 2, 0),
-- ( 31, N'JavaScript solo valida formularios en el servidor', 3, 0),
-- ( 31, N'Sólo se pueden validar formularios con jQuery', 4, 0),

-- ( 32, N'Un callback es una función que se pasa como argumento a otra función y se ejecuta más tarde', 1, 1),
-- ( 32, N'Los callbacks solo sirven para manejar errores en JavaScript', 2, 0),
-- ( 32, N'Un callback es una función que se ejecuta antes de que termine la función que la recibe', 3, 0),
-- ( 32, N'Los callbacks son usados para manipular variables globales', 4, 0),

-- ( 33, N'`localStorage` y `sessionStorage` permiten almacenar datos en el navegador de forma persistente o temporal', 1, 1),
-- ( 33, N'`localStorage` solo almacena datos durante la sesión activa, mientras que `sessionStorage` es permanente', 2, 0),
-- ( 33, N'`localStorage` y `sessionStorage` solo funcionan en la parte del servidor', 3, 0),
-- ( 33, N'`localStorage` y `sessionStorage` no permiten almacenar objetos o arrays', 4, 0),

-- ( 34, N'`try`, `catch` y `finally` permiten manejar excepciones, garantizando que siempre se ejecute un bloque de código', 1, 1),
-- ( 34, N'Los bloques `try` y `catch` sólo pueden ser utilizados con funciones sin retorno', 2, 0),
-- ( 34, N'El bloque `finally` puede evitar que se ejecute el bloque `catch`', 3, 0),
-- ( 34, N'`try`, `catch` y `finally` solo se usan para manejar eventos', 4, 0),

-- ( 35, N'Una SPA (Single Page Application) carga todo su contenido en una sola página HTML y cambia dinámicamente el contenido con JavaScript', 1, 1),
-- ( 35, N'Una SPA requiere de múltiples recargas de la página para actualizar su contenido', 2, 0),
-- ( 35, N'Las SPA no se pueden crear con JavaScript', 3, 0),
-- ( 35, N'Las SPA son una forma de almacenar datos sin mostrarlos al usuario', 4, 0),

-- ( 36, N'El concepto de "closure" se refiere a una función que mantiene acceso a su contexto léxico, incluso después de que la función externa haya terminado de ejecutarse', 1, 1),
-- ( 36, N'El "closure" solo puede usarse en funciones anónimas dentro de objetos', 2, 0),
-- ( 36, N'El "closure" se refiere a la capacidad de una función de almacenar valores globales', 3, 0),
-- ( 36, N'El "closure" es una propiedad exclusiva de los ciclos `for`', 4, 0),

-- ( 37, N'Puedes usar `window.location.href` para redirigir a otra URL en JavaScript', 1, 1),
-- ( 37, N'JavaScript no permite redirecciones, sólo lo hace el servidor', 2, 0),
-- ( 37, N'Sólo se puede redirigir mediante el uso de HTML', 3, 0),
-- ( 37, N'La redirección en JavaScript se realiza con el método `redirect()`', 4, 0),

-- ( 38, N'`fetch` es una API moderna que reemplaza a `XMLHttpRequest` para hacer solicitudes HTTP de forma más sencilla y legible', 1, 1),
-- ( 38, N'`fetch` es obsoleto y solo se utiliza en versiones anteriores de JavaScript', 2, 0),
-- ( 38, N'`fetch` solo puede realizar solicitudes a servidores locales y no a servidores remotos', 3, 0),
-- ( 38, N'`fetch` se usa exclusivamente en el contexto de Node.js, no en navegadores', 4, 0),

-- ( 39, N'Puedes usar `setTimeout` para ejecutar una función después de un tiempo específico y `setInterval` para ejecutar una función repetidamente', 1, 1),
-- ( 39, N'`setTimeout` y `setInterval` solo sirven para crear animaciones en el navegador', 2, 0),
-- ( 39, N'`setTimeout` es sinónimo de `setInterval` y viceversa', 3, 0),
-- ( 39, N'`setTimeout` y `setInterval` solo se pueden usar para manipular eventos de usuario', 4, 0),

-- ( 40, N'Las plantillas literales permiten incluir expresiones dentro de cadenas de texto utilizando `${}` para interpolación', 1, 1),
-- ( 40, N'Las plantillas literales solo permiten cadenas de texto sin ninguna interpolación de valores', 2, 0),
-- ( 40, N'Las plantillas literales requieren una sintaxis especial que no se puede usar dentro de funciones', 3, 0),
-- ( 40, N'Las plantillas literales se usan para declarar funciones, no para trabajar con cadenas de texto', 4, 0);
