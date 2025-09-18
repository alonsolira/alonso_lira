using app.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Data;
using System.Diagnostics;

namespace app.Controllers
{
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

        public string Login(string nombre, string contra)
        {
            try
            {
                if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(contra))
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "El usuario y la contraseña son obligatorios." });
                }

                if (nombre != "alonso" || contra != "111")
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "Credenciales incorrectas." });
                }
                else
                {
                    // Si las credenciales son correctas, puedes redirigir al usuario a la página de inicio
                    HttpContext.Session.SetString("nombre", nombre);
                    return JsonConvert.SerializeObject(new { success = true, message = "Inicio de sesión exitoso." });
                }
            }
            catch (Exception exception)
            {
                return JsonConvert.SerializeObject(new { success = false, message = exception.Message });
            }
        }
    
        public IActionResult Inicio(string nombre)
        {
            if (string.IsNullOrEmpty(nombre))
            {
                // Si no hay nombre, muestra la vista de inicio
                return View("Index", "Home");
            }

            HttpContext.Session.SetString("nombre", nombre);
            // Redirige solo si el nombre es válido y la vista existe
            return View("Registro_Compra", "Home");
        }
        public IActionResult Registro_Compra()
        {
            return View();
        }

        public IActionResult Estado_Cuenta()
        {
            return View();
        }
        public IActionResult Mi_Cuenta()
        {
            return View();
        }
        public IActionResult Registrar_Usuario()
        {
           return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
