public class Proyecto
{
    public int IdProyecto { get; set; }
    public int IdCategoria { get; set; }
    public DateTime FechaPublicacion { get; set; }
    public int CantIntegrantes { get; set; }
    public string Descripcion { get; set; }
    public decimal Valoracion { get; set; }
    public bool Estado { get; set; }
}