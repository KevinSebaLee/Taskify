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

CREATE TABLE Respuesta(
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
    FechaPublicacion DATE NOT NULL,
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
    IdContacto INT NOT NULL FOREIGN KEY REFERENCES Contactos(IdContacto),
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

CREATE TABLE RespuestaPregunta(
	IdRespuesta INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	IdPregunta INT NOT NULL FOREIGN KEY REFERENCES Preguntas(IdPregunta),
	IdUsuarioPregunta INT NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
	Respuesta NVARCHAR(200) NOT NULL
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
    @FechaPublicacion DATE,
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

CREATE PROCEDURE SP_CrearRespuesta
	@IdPregunta INT,
	@IdUsuarioPregunta INT,
	@Respuesta NVARCHAR(200)
AS
BEGIN
	INSERT INTO RespuestaPregunta(IdPregunta, IdUsuarioPregunta, Respuesta)
	VALUES(@IdPregunta, @IdUsuarioPregunta, @Respuesta)
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
(14, '¿Cómo puedes utilizar Python para automatizar tareas repetitivas en tu sistema?'),
(14, '¿Qué librerías de Python son más populares para realizar scraping web?'),
(14, 'Explica cómo usar Python para crear un script que recupere datos de una API pública.'),
(14, '¿Qué es el módulo `os` en Python y cómo puede ayudarte en la automatización de tareas?'),
(14, 'Menciona al menos tres casos de uso donde Python sea ideal para automatización de procesos.'),
(14, '¿Cómo puedes automatizar el envío de correos electrónicos con Python?'),
(14, 'Explica cómo puedes programar tareas recurrentes en Python utilizando el módulo `schedule`.'),
(14, '¿Qué es `Selenium` y cómo puede ayudarte a automatizar interacciones con un navegador web?'),
(14, '¿Cuál es la importancia de los `cron jobs` en combinación con Python para la automatización de procesos?'),
(14, '¿Cómo puedes usar Python para procesar archivos CSV de manera automática?'),
(14, '¿Qué ventajas tiene la automatización de tareas con Python frente a otras herramientas de programación?'),
(14, '¿Cómo puedes utilizar Python para organizar y mover archivos automáticamente en un directorio?'),
(14, '¿Qué consideraciones de seguridad debes tener en cuenta al automatizar tareas en Python?'),
(14, '¿Cómo puedes crear un script en Python para generar informes automáticos a partir de datos de bases de datos?'),
(14, '¿Qué es `pyautogui` y cómo puede ayudarte a automatizar la interacción con la interfaz gráfica del sistema operativo?'),
(14, '¿Cómo puedes usar Python para monitorear un directorio y ejecutar acciones automáticamente cuando cambien los archivos?'),
(14, 'Explica cómo utilizar `BeautifulSoup` y `requests` para automatizar la recolección de datos desde un sitio web.'),
(14, '¿Qué desafíos pueden surgir al automatizar tareas complejas en Python y cómo podrías abordarlos?'),
(14, '¿Cómo puedes usar Python para crear un archivo de log que registre las acciones realizadas por tus scripts de automatización?'),
(14, '¿Qué es un “web scraper” y cómo lo puedes construir utilizando Python?');

-- Tópico 2: JavaScript - Desarrollo Web
INSERT INTO consigna (IdTask, Pregunta) VALUES
(15, '¿Cómo JavaScript mejora la interactividad de las páginas web?'),
(15, '¿Qué es el modelo de objetos del documento (DOM) y cómo interactúa JavaScript con él?'),
(15, 'Explica la diferencia entre `var`, `let` y `const` en JavaScript.'),
(15, '¿Cómo puedes manejar eventos en JavaScript y cuáles son los tipos de eventos más comunes?'),
(15, '¿Cómo puedes realizar una petición HTTP usando JavaScript para obtener datos de un servidor?'),
(15, '¿Qué es AJAX y cómo se utiliza en JavaScript para cargar contenido de manera asíncrona?'),
(15, 'Explica qué es la promesa en JavaScript y cómo se utiliza para manejar operaciones asincrónicas.'),
(15, '¿Cómo puedes manipular los estilos de una página web usando JavaScript?'),
(15, '¿Qué son las funciones flecha (`arrow functions`) y cómo se diferencian de las funciones tradicionales en JavaScript?'),
(15, '¿Cómo puedes validar formularios en el lado del cliente usando JavaScript?'),
(15, 'Explica qué es un "callback" en JavaScript y cómo se utilizan en la programación asincrónica.'),
(15, '¿Cuál es la importancia de `localStorage` y `sessionStorage` en JavaScript para almacenar datos en el navegador?'),
(15, '¿Cómo puedes gestionar errores y excepciones en JavaScript usando `try`, `catch`, y `finally`?'),
(15, '¿Qué es una SPA (Single Page Application) y cómo JavaScript facilita su desarrollo?'),
(15, 'Explica el concepto de "closure" en JavaScript y da un ejemplo práctico.'),
(15, '¿Cómo puedes realizar una redirección en JavaScript a otra página web o URL?'),
(15, '¿Qué es `fetch` en JavaScript y cómo puedes usarlo para hacer peticiones HTTP?'),
(15, '¿Cómo se pueden crear animaciones y transiciones en JavaScript para mejorar la experiencia de usuario?'),
(15, 'Explica el uso de `setTimeout` y `setInterval` en JavaScript y da un ejemplo de cada uno.'),
(15, '¿Qué son las plantillas literales (template literals) y cómo facilitan la creación de cadenas de texto en JavaScript?');

-- Tópico 3: Ruby on Rails - Desarrollo de Software
INSERT INTO consigna (IdTask, Pregunta) VALUES
(16, '¿Qué es Ruby on Rails y por qué se considera un framework eficiente para el desarrollo web?'),
(16, '¿Cómo puedes crear un nuevo proyecto de Ruby on Rails desde cero?'),
(16, 'Explica el patrón de arquitectura MVC en el contexto de Ruby on Rails.'),
(16, '¿Qué son los "migraciones" en Ruby on Rails y cómo se utilizan para modificar la base de datos?'),
(16, '¿Cómo puedes manejar relaciones entre modelos en Ruby on Rails, como "has_many" y "belongs_to"?'),
(16, 'Explica cómo crear una ruta personalizada en Ruby on Rails y qué archivo se debe modificar para hacerlo.'),
(16, '¿Qué son los "scaffolds" en Rails y cómo ayudan a acelerar el desarrollo de una aplicación?'),
(16, '¿Qué es ActiveRecord en Ruby on Rails y cómo se utiliza para interactuar con bases de datos?'),
(16, '¿Cómo puedes validar los datos de un formulario en Ruby on Rails?'),
(16, 'Explica cómo se implementa la autenticación de usuarios en Ruby on Rails.'),
(16, '¿Qué son las "seeds" en Rails y cómo se utilizan para poblar la base de datos con datos de prueba?'),
(16, '¿Cómo puedes realizar una consulta compleja en Rails utilizando ActiveRecord?'),
(16, 'Explica cómo Rails maneja la autenticación de sesiones y cookies.'),
(16, '¿Cómo puedes optimizar el rendimiento de una aplicación Ruby on Rails?'),
(16, '¿Cómo se maneja el enrutamiento en Rails y qué es el archivo `routes.rb`?'),
(16, 'Explica el uso de los "partials" en Rails para reutilizar código en vistas.'),
(16, '¿Qué son los "concerns" en Ruby on Rails y cómo pueden ayudar a organizar mejor el código?'),
(16, '¿Cómo puedes generar una nueva migración en Rails para agregar un campo a una tabla existente?'),
(16, 'Explica cómo configurar un entorno de pruebas en Ruby on Rails utilizando RSpec o MiniTest.');

-- Tópico 4: R - Ciencia de Datos
INSERT INTO consigna (IdTask, Pregunta) VALUES
(17, '¿Cómo puedes cargar un conjunto de datos en R utilizando la función `read.csv`?'),
(17, 'Explica qué son los data frames en R y cómo se utilizan para almacenar datos tabulares.'),
(17, '¿Cómo puedes manejar valores faltantes (NA) en un conjunto de datos en R?'),
(17, '¿Qué es una variable categórica en R y cómo se puede representar visualmente?'),
(17, '¿Cómo puedes realizar un análisis exploratorio de datos en R utilizando el paquete `ggplot2`?'),
(17, 'Explica cómo crear y manipular una serie temporal en R utilizando el paquete `zoo`.'),
(17, '¿Qué son las funciones de agregación en R y cómo puedes utilizarlas para resumir datos?'),
(17, '¿Cómo puedes aplicar un modelo de regresión lineal en R usando el paquete `lm`?'),
(17, '¿Qué son las "funciones anónimas" en R y en qué situaciones pueden ser útiles?'),
(17, 'Explica cómo realizar una validación cruzada para un modelo de machine learning en R.'),
(17, '¿Cómo puedes visualizar la distribución de una variable numérica en R usando `hist()`?'),
(17, '¿Qué es la "normalización" de datos y cómo se puede realizar en R?'),
(17, '¿Cómo puedes realizar un análisis de correlación entre dos variables en R?'),
(17, 'Explica el concepto de "overfitting" y cómo prevenirlo al construir modelos predictivos en R.'),
(17, '¿Cómo se puede usar el paquete `dplyr` para manipular y transformar datos en R?'),
(17, '¿Qué es un modelo de clasificación en R y cómo se entrena uno con `rpart`?'),
(17, 'Explica cómo crear una matriz de confusión en R y qué información nos proporciona.'),
(17, '¿Cómo puedes aplicar un análisis de componentes principales (PCA) en R para reducción de dimensionalidad');