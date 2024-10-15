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
        string query = "SELECT * FROM Usuarios INNER JOIN Rangos ON Usuarios.IdRango = Rangos.IdRango WHERE Usuarios.IdUsuario = @IdUsuario";
        Rango rangoUsuario = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            rangoUsuario = db.QueryFirstOrDefault<Rango>(query, new{@IdUsuario = idUsuario});
        }

        return rangoUsuario;
    }

    public static Rol ObtenerRolUsuario(int idUsuario){
        string query = "SELECT * FROM Usuarios INNER JOIN Roles ON Usuarios.IdRol = Roles.IdRol WHERE Usuarios.IdUsuario = @IdUsuario";
        Rol rolUsuario = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            rolUsuario = db.QueryFirstOrDefault<Rol>(query, new{@IdUsuario = idUsuario});
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

    public static List<Empleo> ObtenerEmpleos()
    {
        string query = "SELECT * FROM Proyectos";
        List<Empleo> Empleos = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            Empleos = db.Query<Empleo>(query).ToList();
        }

        return Empleos;
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

    public static Empleo ObtenerEmpleoSeleccionado(int IdProyecto)
    {
        string query ="SELECT * FROM Proyectos WHERE Proyectos.IdProyecto = @id";
        Empleo empleoSeleccionado = null;
        using(SqlConnection db = new SqlConnection(_connectionString)){
            empleoSeleccionado = db.QueryFirstOrDefault<Empleo>(query, new {@id = IdProyecto});
        }

        return empleoSeleccionado;
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

    public static Usuario LogIN(string Email, string Contraseña)
    {
        Usuario LogIn = null;
        string sp = "SP_Login";

        using (SqlConnection db = new SqlConnection(_connectionString))
        {
            LogIn = db.QueryFirstOrDefault<Usuario>(sp, 
                new { @Email = Email, @Contraseña = Contraseña }, 
                commandType: System.Data.CommandType.StoredProcedure);
        }

        return LogIn;
    }

}