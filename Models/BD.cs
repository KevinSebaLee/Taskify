using System.Data.SqlClient;
using Dapper;

public class BD{
    private static string _connectionString = @"Server=localhost; DataBase=Taskify; Trusted_Connection=True;";

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
}