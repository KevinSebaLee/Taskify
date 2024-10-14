public class TaskifyService{
    public static Usuario User;
    
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

    public static Task ObtenerTaskSeleccionado(int IdTask){
        return BD.ObtenerTaskSeleccionado(IdTask);
    }

    public static List<Empleo> ObtenerEmpleos(){
        return BD.ObtenerEmpleos();
    }

    public static Empleo ObtenerEmpleoSeleccionado(int idProyecto){
        return BD.ObtenerEmpleoSeleccionado(idProyecto);
    }

    public static Usuario CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol){
        return BD.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
    }

    public static Usuario LogIN(string Email, string Contraseña){
        return BD.LogIN(Email, Contraseña);
    }
}