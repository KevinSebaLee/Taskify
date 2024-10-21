using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Taskify.Models;

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
        return View();
    }

    public IActionResult CrearProyecto(string Nombre, string NombreEmpresa, int IdCategoria, int IdFiltro, string Ubicacion, DateTime fechaPublicacion, string Descripcion){
        return RedirectToAction("Empleos");
    }

    public IActionResult CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol, string ConfirmarContraseña, int IdFiltro){
        if(Contraseña == ConfirmarContraseña){
            Usuario userNuevo = TaskifyService.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
            return RedirectToAction("Index");
        }
        else{
            ViewBag.Error = "No es la misma contrasseña";
            return RedirectToAction("Register");
        }
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
