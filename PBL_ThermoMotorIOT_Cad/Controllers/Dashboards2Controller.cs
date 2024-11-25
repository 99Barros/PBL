using DAO;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.Models;
using System.Data.SqlClient;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class Dashboards2Controller : Controller
    {
        public IActionResult Index()
        {
            try
            {
                using (SqlConnection connection = ConexaoBD.GetConexao())
                {
                    // Chamada da stored procedure para obter os totais
                    var totais = connection.QueryFirstOrDefault("spObterTotais", commandType: System.Data.CommandType.StoredProcedure);

                    // Passando os dados para a View via ViewBag
                    ViewBag.Labels = new[] { "Usuários", "Empresas", "Estufas" };
                    ViewBag.Values = new[] { totais.TotalUsuarios, totais.TotalEmpresas, totais.TotalEstufas };
                }

                return View();
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }
    }
}
