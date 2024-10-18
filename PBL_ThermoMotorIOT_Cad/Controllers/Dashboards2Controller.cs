using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class Dashboards2Controller : Controller
    {
        public IActionResult Index()
        {
            return View();        
        }
    }
}
