public class Evento{
    public int IdEvento {get; set;}
    public int IdUsuario {get; set;}
    public int? IdContacto{get; set;}
    public string Nombre {get; set;}
    public string Descripcion {get; set;}
    public DateTime FechaInicio {get; set;}
    public DateTime FechaFin {get; set;}
}