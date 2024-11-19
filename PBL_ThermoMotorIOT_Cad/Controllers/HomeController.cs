﻿using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.Models;
using System.Diagnostics;

namespace PBL_ThermoMotorIOT_Cad.Controllers
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
            ViewBag.Logado = TempData["logado"];
            ViewBag.NomeUsuario = TempData["nomeUsuario"];
            return View();
        }

        public IActionResult Privacy()
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
