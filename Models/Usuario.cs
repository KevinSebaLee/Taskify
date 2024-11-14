public class Usuario{
    public int IdUsuario { get; set; }
    public int IdRol { get; set; }
    public int IdRango { get; set; }
    public int IdCertificado {get; set;}
    public int IdGenero {get; set;}
    public int IdPais {get; set;}
    public string Nombre { get; set; }
    public string Apellido { get; set; }
    public string Contrasenia { get; set; }
    public int Edad {get; set;}
    public string Email { get; set; }
    public string NumeroTelefono { get; set;}
    public int Puntaje {get; set;}
    public string FotoPerfil { get; set; }
    public string Descripcion { get; set; }
    public DateTime FechaNacimiento {get; set;}
}