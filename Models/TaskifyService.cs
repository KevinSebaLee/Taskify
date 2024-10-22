public class TaskifyService{
    public static Usuario User;
    public static Rango RangoUser;
    public static List<Rol> RolUser;
    
    public static List<Task> ObtenerTasks(){
        return BD.ObtenerTasks();
    }

    public static List<Genero> ObtenerGeneros(){
        return BD.ObtenerGeneros();
    }

    public static List<Rol> ObtenerRoles(){
        return BD.ObtenerRoles();
    }

    public static List<Pais> ObtenerPaises(){
        return BD.ObtenerPais();
    }

    public static List<Categoria> ObtenerCategorias(){
        return BD.ObtenerCategorias();
    }

    public static List<string> ObtenerMail(){
        return BD.ObtenerMail();
    }

    public static Task ObtenerTaskSeleccionado(int IdTask){
        return BD.ObtenerTaskSeleccionado(IdTask);
    }

    public static List<Proyecto> ObtenerEmpleos(){
        return BD.ObtenerEmpleos();
    }

    public static Proyecto ObtenerEmpleoSeleccionado(int idProyecto){
        Console.WriteLine(idProyecto);

        return BD.ObtenerEmpleoSeleccionado(idProyecto);
    }

    public static Usuario CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol){
        return BD.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
    }

    public static Usuario LogIN(string Email, string Contraseña){
        return BD.LogIN(Email, Contraseña);
    }

    public static List<Rol> ObtenerRolUsuario(int idUsuario){
        return BD.ObtenerRolUsuario(idUsuario);
    }
    
    public static Rango ObtenerRangoUsuario(int idUsuario){
        return BD.ObtenerRangoUsuario(idUsuario);
    }
}