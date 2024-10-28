using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Taskify.Models;
using System.Text.RegularExpressions;


namespace Taskify.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        return View();
    }

    public IActionResult Chat()
    {
        return View();
    }

    public IActionResult Agenda()
    {
        return View();
    }

    public IActionResult Community()
    {
        return View();
    }

    public IActionResult Empleos()
    {
        ViewBag.Proyectos = TaskifyService.ObtenerEmpleos();
        return View();
    }
    public IActionResult Proyecto(int IdProyecto)
    {
        Console.WriteLine(IdProyecto);
        ViewBag.ProyectoElegido = TaskifyService.ObtenerEmpleoSeleccionado(IdProyecto);
        
        return View();
    }

    public IActionResult Perfil()
    {
        return View();
    }
    
    public IActionResult Login()
    {
        return View();
    }
    
    public IActionResult Register()
    {
        ViewBag.Paises = TaskifyService.ObtenerPaises();
        ViewBag.Generos = TaskifyService.ObtenerGeneros();
        ViewBag.Roles = TaskifyService.ObtenerRoles();

        return View();
    }

    public IActionResult Tasks()
    {
        return View();
    }

    public IActionResult PublicarProyecto(){
        ViewBag.Roles = TaskifyService.ObtenerRoles();
        ViewBag.Categorias = TaskifyService.ObtenerCategorias();

        return View();
    }

    public IActionResult CrearProyecto(string Nombre, string NombreEmpresa, int IdCategoria, int IdRol, string Ubicacion, DateTime fechaPublicacion, string Descripcion){
        Proyecto proyectoNuevo = BD.CrearProyecto(Nombre, NombreEmpresa, IdCategoria, IdRol, Ubicacion, fechaPublicacion, Descripcion);

        return RedirectToAction("Empleos");
    }

    public IActionResult CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol, string ConfirmarContraseña, int IdFiltro){
        List<string> Mail = TaskifyService.ObtenerMail();
        
        if(Contraseña == ConfirmarContraseña && !(Mail.Contains(Email)) && verificarContraseña(Contraseña)){
            Usuario userNuevo = TaskifyService.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
            Console.WriteLine("entró aca");

            return RedirectToAction("Index");
        }
        else if(Mail.Contains(Email)){
            ViewBag.Error = "El mail ya esta registrado";
            return RedirectToAction("Register");
        }
        else{
            ViewBag.Error = "No es la misma contrasseña";
            return RedirectToAction("Register");
        }
    }

    private bool verificarContraseña (string contraseña){

        Console.WriteLine("entró");

        Regex validateGuidRegex  = new Regex("^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$");

        return validateGuidRegex.IsMatch(contraseña);

    }

    public IActionResult LogInUser(string Contraseña, string Email){
        Usuario usuario = TaskifyService.LogIN(Email, Contraseña);

        if(usuario == null){
            ViewBag.Error = "Ingreso incorrectamente el e-mail o la contraseña";
            return RedirectToAction("Login");
        }
        else{
            TaskifyService.User = usuario;
            TaskifyService.RangoUser = TaskifyService.ObtenerRangoUsuario(usuario.IdUsuario);
            TaskifyService.RolUser = TaskifyService.ObtenerRolUsuario(usuario.IdUsuario);

            return RedirectToAction("Index");
        }
    }
}
