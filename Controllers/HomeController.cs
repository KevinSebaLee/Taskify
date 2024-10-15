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
        if(TaskifyService.User != null){
            return View();
        }
        else{
            return RedirectToAction("Index");
        }
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

    public IActionResult CrearPregunta(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol, string ConfirmarContraseña){
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
        Usuario LogIN = TaskifyService.LogIN(Email, Contraseña);

        if(LogIN == null){
            ViewBag.Error = "Ingreso incorrectamente el e-mail o la contraseña";
            return RedirectToAction("Login");
        }
        else{
            TaskifyService.User = LogIN;
            TaskifyService.RangoUser = TaskifyService.ObtenerRangoUsuario(LogIN.IdUser);
            TaskifyService.RolUser = TaskifyService.ObtenerRolUsuario(LogIN.IdUser);
            
            return RedirectToAction("Index");
        }
    }
}
