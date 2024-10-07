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
    [HttpPost]
    public IActionResult Login(string email, string contrasenia)
    {
        var usuario = usuarios.FirstOrDefault(u => u.Email == email && u.Contrasenia == contrasenia);

        if (usuario != null)
        {
            return RedirectToAction("Perfil");
        }
        else
        {
            return View();
        }
    }    

    public IActionResult Tasks()
    {
        return View();
    }
    private static List<Usuario> usuarios = new List<Usuario>();
    [HttpPost]
    public IActionResult CrearPerfil(Usuario usuario)
    {
        usuarios.Add(usuario);
        return RedirectToAction("Perfil");
    }
}
