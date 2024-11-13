using System.Data.SqlClient;
using Dapper;

public class BD{
    private static string _connectionString = @"Server=localhost; DataBase=Taskify; Trusted_Connection=True;";

    public static List<Pais> ObtenerPais(){
        string query = "SELECT * FROM Paises";
        List<Pais> Paises = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Paises = db.Query<Pais>(query).ToList();
        }

        return Paises;
    }

    public static Rango ObtenerRangoUsuario(int idUsuario){
        string query = "SELECT Rangos.* FROM Usuarios INNER JOIN Rangos ON Usuarios.IdRango = Rangos.IdRango WHERE Usuarios.IdUsuario = @IdUsuario";
        Rango rangoUsuario = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            rangoUsuario = db.QueryFirstOrDefault<Rango>(query, new{@IdUsuario = idUsuario});
        }

        return rangoUsuario;
    }

    public static Usuario ObtenerUsuario(int idUsuario){
        string query = "SELECT * FROM Usuarios WHERE Usuarios.IdUsuario = @id";
        Usuario user = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            user = db.QueryFirstOrDefault<Usuario>(query, new{@id = idUsuario});
        }

        return user;
    }

    public static List<Rol> ObtenerRolUsuario(int idUsuario){
        string query = "SELECT Roles.* FROM Usuarios INNER JOIN Roles ON Usuarios.IdRol = Roles.IdRol WHERE Usuarios.IdUsuario = @IdUsuario";
        List<Rol> rolUsuario = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            rolUsuario = db.Query<Rol>(query, new{@IdUsuario = idUsuario}).ToList();
        }

        return rolUsuario;
    }

    public static List<Genero> ObtenerGeneros(){
        string query = "SELECT * FROM Generos";
        List<Genero> Generos = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Generos = db.Query<Genero>(query).ToList();
        }

        return Generos;
    }

    public static List<Categoria> ObtenerCategorias(){
        string query = "SELECT * FROM Categorias";
        List<Categoria> Categorias = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Categorias = db.Query<Categoria>(query).ToList();
        }

        return Categorias;
    }

    public static List<Rol> ObtenerRoles(){
        string query = "SELECT * FROM Roles";
        List<Rol> Roles = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Roles = db.Query<Rol>(query).ToList();
        }

        return Roles;
    }

    public static List<Task> ObtenerTasks()
    {
        string query = "SELECT * FROM Tasks";
        List<Task> Tasks = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Tasks = db.Query<Task>(query).ToList();
        }

        return Tasks;
    }

    public static List<Proyecto> ObtenerEmpleos()
    {
        string query = "SELECT * FROM Proyectos";
        List<Proyecto> proyectos = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            proyectos = db.Query<Proyecto>(query).ToList();
        }

        return proyectos;
    }

    public static List<Proyecto> ObtenerProyectos(){
        string query = "SELECT * FROM Proyectos";
        List<Proyecto> Proyectos = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Proyectos = db.Query<Proyecto>(query).ToList();
        }

        return Proyectos;
    }

    public static List<Pregunta> ObtenerPreguntas(){
        string query = "SELECT * FROM Preguntas";
        List<Pregunta> Preguntas = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Preguntas = db.Query<Pregunta>(query).ToList();
        }

        return Preguntas;
    }

    public static List<string> ObtenerMail()
    {
        string query = "SELECT Email FROM Usuarios";
        List<string> Email = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Email = db.Query<string>(query).ToList();
        }

        return Email;
    }

    public static Task ObtenerTaskSeleccionado(int IdTask)
    {
        string query ="SELECT * FROM Tasks WHERE Tasks.IdTask = @id";
        Task tasksSeleccionado = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            tasksSeleccionado = db.QueryFirstOrDefault<Task>(query, new {@id = IdTask});
        }

        return tasksSeleccionado;
    }

    public static Proyecto ObtenerEmpleoSeleccionado(int IdProyecto)
    {
        string query ="SELECT * FROM Proyectos WHERE Proyectos.IdProyecto = @id";
        Proyecto empleoSeleccionado = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            empleoSeleccionado = db.QueryFirstOrDefault<Proyecto>(query, new {@id = IdProyecto});
        }

        return empleoSeleccionado;
    }

    public static Pregunta ObtenerPreguntaSeleccionada(int IdPregunta)
    {
        string query ="SELECT * FROM Preguntas WHERE Preguntas.IdPregunta = @id";
        Pregunta empleoSeleccionado = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            empleoSeleccionado = db.QueryFirstOrDefault<Pregunta>(query, new {@id = IdPregunta});
        }

        return empleoSeleccionado;
    }

    public static List<RespuestaChat> ObtenerRespuestasSeleccionadas(int IdPregunta)
    public static List<RespuestaChat> ObtenerRespuestasSeleccionadas(int IdPregunta)
    {
        string query ="SELECT RespuestaChat.* FROM RespuestaChat INNER JOIN Preguntas ON Preguntas.IdPregunta = RespuestaChat.IdPregunta WHERE Preguntas.IdPregunta = @id";
        List<RespuestaChat> Respuestas = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Respuestas = db.Query<RespuestaChat>(query, new {@id = IdPregunta}).ToList();
            Respuestas = db.Query<RespuestaChat>(query, new {@id = IdPregunta}).ToList();
        }

        return Respuestas;
    }

    public static Proyecto CrearProyecto(string Nombre, string NombreEmpresa, int IdCategoria, int IdRol, int IdCreadorUsuario, string Ubicacion, DateTime fechaPublicacion, string Descripcion){
        Proyecto proyectoNuevo = null;
        string sp = "SP_CrearProyecto";
        using (SqlConnection db = new SqlConnection(_connectionString))
        {
            proyectoNuevo = db.QuerySingleOrDefault<Proyecto>(sp, new
            {
                @Nombre = Nombre,
                @NombreEmpresa = NombreEmpresa,
                @IdCategoria = IdCategoria,
                @IdRol = IdRol,
                @IdCreadorUsuario = IdCreadorUsuario,
                @Ubicacion = Ubicacion,
                @FechaPublicacion = fechaPublicacion,
                @Descripcion = Descripcion,
            }, commandType: System.Data.CommandType.StoredProcedure);
        }

        return proyectoNuevo;
    }

    public static Usuario CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol)
    {
        Usuario userNuevo = null;
        string sp = "SP_CrearPerfil";
        using (SqlConnection db = new SqlConnection(_connectionString))
        {
            userNuevo = db.QuerySingleOrDefault<Usuario>(sp, new
            {
                @Nombre = Nombre,
                @Apellido = Apellido,
                @Genero = Genero,
                @Pais = Pais,
                @FechaNacimiento = FechaNacimiento,
                @NumeroTelefono = NumeroTelefono,
                @Email = Email,
                @Contraseña = Contraseña,
                @IdRol = IdRol
            }, commandType: System.Data.CommandType.StoredProcedure);
        }

        return userNuevo;
    }

    public static Pregunta CrearPregunta(string Pregunta, int IdUsuarioCreador, string Titulo){
        Pregunta preguntaNueva = null;
        string sp = "SP_CrearPregunta";
        using (SqlConnection db = new SqlConnection(_connectionString)){
            preguntaNueva = db.QuerySingleOrDefault<Pregunta>(sp, new
            {
                @IdUsuarioCreador = IdUsuarioCreador,
                @Titulo = Titulo,
                @Pregunta = Pregunta
            }, commandType: System.Data.CommandType.StoredProcedure);
        }

        return preguntaNueva;
    }

    public static RespuestaChat CrearRespuesta(string Respuesta, int IdUsuarioCreador, int IdPregunta){
        RespuestaChat respuestNueva = null;
        string sp = "SP_CrearRespuesta";
        using (SqlConnection db = new SqlConnection(_connectionString)){
            respuestNueva = db.QuerySingleOrDefault<RespuestaChat>(sp, new
            respuestNueva = db.QuerySingleOrDefault<RespuestaChat>(sp, new
            {
                @IdUsuarioPregunta = IdUsuarioCreador,
                @IdPregunta = IdPregunta,
                @RespuestaPregunta = Respuesta
            }, commandType: System.Data.CommandType.StoredProcedure);
        }

        return respuestNueva;
    }

    public static Usuario LogIN(string Email, string Contraseña)
    {
        Usuario usuario = null;
        string sp = "SP_Login";

        using (SqlConnection db = new SqlConnection(_connectionString))
        {
            usuario = db.QueryFirstOrDefault<Usuario>(sp, new { @Email = Email, @Contraseña = Contraseña }, commandType: System.Data.CommandType.StoredProcedure);
        }

        return usuario;
    }

    public static List<Consigna> ObtenerConsignasXTask(int IdTask){
        List<Consigna> ConsignasXTask = null;
        string query ="SELECT IdConsigna, IdTask, Pregunta FROM Consigna WHERE Consigna.IdTask = @id";
        using(SqlConnection db = new SqlConnection(_connectionString)){
            ConsignasXTask = db.Query<Consigna>(query, new {@id = IdTask}).ToList();
        }

        return ConsignasXTask;
    }

    public static List<Task> ObtenerTask (){
        string query = "SELECT * FROM Tasks";
        List<Task> ListTask = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            ListTask = db.Query<Task>(query).ToList();
        }
        return ListTask;
    }

    public static List<Respuesta> RespuestasXConsigna(int IdConsigna)
    {
        List<Respuesta> respuestas = null;
        string query = "SELECT * FROM RespuestaPregunta WHERE IdConsigna = @IdConsigna";

        using (SqlConnection db = new SqlConnection(_connectionString))
        {
            respuestas = db.Query<Respuesta>(query, new { IdConsigna }).ToList();
        }
        return respuestas;
    }


}