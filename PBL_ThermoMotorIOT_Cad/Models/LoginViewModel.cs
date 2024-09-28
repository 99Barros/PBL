using Microsoft.AspNetCore.Mvc;

namespace PBL_ThermoMotorIOT_Cad.Models
{
    public class LoginViewModel : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
