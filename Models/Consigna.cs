public class Consigna{
    public int IdConsigna {get; set;}
    public int IdTask {get; set;}
    public string Pregunta {get; set;}
    public string Foto {get; set;}
    public List<RespuestaChat> Respuestas = new List<RespuestaChat>();

}
