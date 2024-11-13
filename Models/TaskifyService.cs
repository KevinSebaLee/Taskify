using System.Text.RegularExpressions;

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

    public static List<Pregunta> ObtenerPreguntas(){
        return BD.ObtenerPreguntas();
    }

    public static Task ObtenerTaskSeleccionado(int IdTask){
        return BD.ObtenerTaskSeleccionado(IdTask);
    }

    public static Usuario ObtenerUsuario(int idUsuario){
        return BD.ObtenerUsuario(idUsuario);
    }

    public static List<Proyecto> ObtenerEmpleos(){
        return BD.ObtenerEmpleos();
    }

    public static Proyecto ObtenerEmpleoSeleccionado(int idProyecto){
        return BD.ObtenerEmpleoSeleccionado(idProyecto);
    }

    public static Pregunta ObtenerPreguntaSeleccionada(int IdPregunta){
        return BD.ObtenerPreguntaSeleccionada(IdPregunta);
    }

    public static Usuario CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol){
        return BD.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
    }

    public static Pregunta CrearPregunta(string Pregunta, int IdUsuarioCreador, string Titulo){
        return BD.CrearPregunta(Pregunta, IdUsuarioCreador, Titulo);
    }

    public static RespuestaChat CrearRespuesta(string Respuesta, int IdPregunta, int IdUsuarioCreador){
        return BD.CrearRespuesta(Respuesta, IdUsuarioCreador, IdPregunta);
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

    public static List<RespuestaChat> ObtenerRespuestas(int IdPregunta){
        return BD.ObtenerRespuestasSeleccionadas(IdPregunta);
    }

    public static bool VerificarContraseña (string contraseña){
        Regex validateGuidRegex  = new Regex("^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$");

        return validateGuidRegex.IsMatch(contraseña);
    }

    public static List<Consigna> ConsignasXTask (int IdTask){
        return BD.ObtenerConsignasXTask(IdTask);
    }

    public static List<Task> ObtenerTask (){
        return BD.ObtenerTask();
    }

    public static List<Respuesta> RespuestaXConsigna (int IdConsigna){
        return BD.RespuestasXConsigna(IdConsigna);
    }
}