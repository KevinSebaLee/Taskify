public class TaskifyService{
    private Usuario User {get; set;}
    
    public static List<Task> ObtenerTasks(){
        return BD.ObtenerTasks();
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

}