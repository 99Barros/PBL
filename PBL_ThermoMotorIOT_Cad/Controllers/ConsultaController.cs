using DAO;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;


namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class ConsultaController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IEnumerable<dynamic> GetTabelaDados(string nomeUsuario, string nomeEmpresa = "", string nomeEstufa = "")
        {
            using (SqlConnection connection = ConexaoBD.GetConexao())
            {
                // Definindo os parâmetros como um objeto anônimo
                var parametros = new
                {
                    nomeUsuario = nomeUsuario ?? "",
                    nomeEmpresa = nomeEmpresa ?? "",
                    nomeEstufa = nomeEstufa ?? ""
                };

                // Executando a stored procedure
                var resultado = connection.Query("spConsultaAvancada", parametros, commandType: System.Data.CommandType.StoredProcedure);

                return resultado;
            }
        }
    }
}
