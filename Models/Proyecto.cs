public class Proyecto
{
    public int IdProyecto { get; set; }
    public int IdCategoria { get; set; }
    public int IdFiltro {get; set; }
    public string Nombre {get; set;}
    public string NombreEmpresa {get; set;}
    public List<Rol> Roles {get; set;}
    public string Ubicacion {get; set;}
    public DateTime FechaPublicacion { get; set; }
    public int CantIntegrantes { get; set; }
    public string Descripcion { get; set; }
    public decimal Valoracion { get; set; }
    public bool Estado { get; set; }
}