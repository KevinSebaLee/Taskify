using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Taskify.Models;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;

namespace Taskify.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IWebHostEnvironment _hostingEnvironment;

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
        ViewBag.Eventos = TaskifyService.ObtenerEventos();
        return View();
    }

    public IActionResult CerrarSesion(){
        TaskifyService.User = null;

        return View("Index");
    }

    public IActionResult Community()
    {
        ViewBag.Preguntas = TaskifyService.ObtenerPreguntas();
        ViewBag.Usuarios = new List<Usuario>();

        foreach (Pregunta a in ViewBag.Preguntas)
        {
            Usuario userNuevo = TaskifyService.ObtenerUsuario(a.IdUsuarioCreador);
            ViewBag.Usuarios.Add(userNuevo);
        }

        return View();
    }

    public IActionResult Empleos()
    {
        ViewBag.Proyectos = TaskifyService.ObtenerEmpleos();
        
        return View();
    }

    public IActionResult Proyecto(int IdProyecto)
    {
        ViewBag.ProyectoElegido = TaskifyService.ObtenerEmpleoSeleccionado(IdProyecto);
        
        return View();
    }

    public IActionResult PreguntaSeleccionada(int IdPregunta)
    {
        ViewBag.PreguntaElegida = TaskifyService.ObtenerPreguntaSeleccionada(IdPregunta);
        ViewBag.Respuestas = TaskifyService.ObtenerRespuestas(IdPregunta);

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

    public IActionResult PublicarPregunta()
    {
        return View();
    }

    public IActionResult PublicarRespuesta(int IdPregunta)
    {
        ViewBag.IdPregunta = IdPregunta;
        return View();
    }

    public IActionResult PublicarProyecto(){
        ViewBag.Roles = TaskifyService.ObtenerRoles();
        ViewBag.Categorias = TaskifyService.ObtenerCategorias();

        return View();
    }

    public IActionResult CrearProyecto(string Nombre, string NombreEmpresa, int IdCategoria, int IdRol, int IdCreadorUsuario, string Ubicacion, DateTime fechaPublicacion, string Descripcion){
        Proyecto proyectoNuevo = BD.CrearProyecto(Nombre, NombreEmpresa, IdCategoria, IdRol, IdCreadorUsuario, Ubicacion, fechaPublicacion, Descripcion);

        return RedirectToAction("Empleos");
    }

    public IActionResult CrearPerfil(string Nombre, string Apellido, int Genero, int Pais, DateTime FechaNacimiento, string NumeroTelefono, string Email, string Contraseña, int IdRol, string ConfirmarContraseña, int IdFiltro){
        List<string> Mail = TaskifyService.ObtenerMail();
        
        if(Contraseña == ConfirmarContraseña && !(Mail.Contains(Email)) && TaskifyService.VerificarContraseña(Contraseña)){
            Usuario userNuevo = TaskifyService.CrearPerfil(Nombre, Apellido, Genero, Pais, FechaNacimiento, NumeroTelefono, Email, Contraseña, IdRol);
            Usuario usuario = TaskifyService.LogIN(Email, Contraseña);
            TaskifyService.User = usuario;
            TaskifyService.RangoUser = TaskifyService.ObtenerRangoUsuario(usuario.IdUsuario);
            TaskifyService.RolUser = TaskifyService.ObtenerRolUsuario(usuario.IdUsuario);

            return RedirectToAction("Index");
        }
        else{
            if(Mail.Contains(Email)){
                ViewBag.Error = "El mail ya esta registrado";
            }
            else{
                ViewBag.Error = "No ingreso la misma contraseña las 2 veces.";
            }

            ViewBag.Paises = TaskifyService.ObtenerPaises();
            ViewBag.Generos = TaskifyService.ObtenerGeneros();
            ViewBag.Roles = TaskifyService.ObtenerRoles();
            return View("Register");
        }
    }

    [HttpPost]
    public IActionResult CrearPregunta(string Pregunta, int IdUsuarioCreador, string Titulo)
    {
        Pregunta nuevaPregunta = BD.CrearPregunta(Pregunta, IdUsuarioCreador, Titulo);

        return RedirectToAction("Community");
    }
    
    [HttpPost]
    public IActionResult CrearRespuesta(string Respuesta, int IdUsuarioCreador, int IdPregunta){
        RespuestaChat nuevaRespuesta = BD.CrearRespuesta(Respuesta, IdUsuarioCreador, IdPregunta);
        ViewBag.PreguntaElegida = TaskifyService.ObtenerPreguntaSeleccionada(IdPregunta);
        ViewBag.Respuestas = TaskifyService.ObtenerRespuestas(IdPregunta);
        
        return View("PreguntaSeleccionada");
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

    public IActionResult Tasks()
    {
        ViewBag.ListaTask = TaskifyService.ObtenerTask();
        return View();
    }

    public IActionResult TaskSeleccionado(int IdTask)
    {
        Console.WriteLine(IdTask);
        ViewBag.TaskSeleccionado = TaskifyService.ObtenerTask()[IdTask - 1];
        List<Consigna> consignasXTask = TaskifyService.ConsignasXTask(IdTask);
        ViewBag.ConsignasXTask = consignasXTask;

        Dictionary<int, List<Respuesta>> respuestasPorConsigna = new Dictionary<int, List<Respuesta>>();

        foreach (Consigna consigna in consignasXTask)
        {
            List<Respuesta> respuestas = TaskifyService.RespuestaXConsigna(consigna.IdConsigna);

            if (respuestasPorConsigna.ContainsKey(consigna.IdConsigna))
            {
                respuestasPorConsigna[consigna.IdConsigna].AddRange(respuestas);
            }
            else
            {
                respuestasPorConsigna.Add(consigna.IdConsigna, respuestas);
            }
        }

        ViewBag.RespuestasPorConsigna = respuestasPorConsigna;
        Console.WriteLine(ViewBag.RespuestasPorConsigna.Count);

        return View("TaskSeleccionado");
    }
    
    [HttpPost]
    public IActionResult CambiarFotoPerfil(IFormFile profilePic, int IdUsuario){
        BD.CambiarPerfil(profilePic, IdUsuario);

        return View("Perfil");
    }

    [HttpPost]
    public ActionResult Resultados(Dictionary<int, int> answers) 
    {
        int correctAnswers = 0;

        Dictionary<int, int> correctAnswersDict = TaskifyService.GetCorrectAnswers(); 

        if (correctAnswersDict == null || correctAnswersDict.Count == 0)
        {
            ViewBag.CorrectAnswers = 0;
            ViewBag.TotalQuestions = 0;
            return View();
        }

        int totalQuestions = correctAnswersDict.Count;

        foreach (var answer in answers)
        {
            int consignaId = answer.Key;
            int selectedAnswerId = answer.Value;

            if (correctAnswersDict.ContainsKey(consignaId) && correctAnswersDict[consignaId] == selectedAnswerId)
            {
                correctAnswers++;
            }
        }

        ViewBag.CorrectAnswers = correctAnswers;
        ViewBag.TotalQuestions = totalQuestions;

        return View();
    }
        
    [HttpPost]
    public IActionResult CrearEvento([FromBody] Evento eventModel) {
        Console.WriteLine($"Received Data - IdUsuario: {eventModel.IdUsuario}, Nombre: {eventModel.Nombre}, Descripcion: {eventModel.Descripcion}, FechaInicio: {eventModel.FechaInicio}, FechaFin: {eventModel.FechaFin}");
        BD.CrearEvento(eventModel.IdUsuario, eventModel.IdContacto, eventModel.Nombre, eventModel.Descripcion, eventModel.FechaInicio, eventModel.FechaFin);

        return View("Agenda");
    }
}
