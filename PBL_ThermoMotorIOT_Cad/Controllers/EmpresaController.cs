using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class EmpresaController : PadraoController<EmpresaViewModel>
    {
        public EmpresaController()
        {
            DAO = new EmpresaDAO();
            GeraProximoId = true;
        }

        public override IActionResult Save(EmpresaViewModel model, string Operacao)
        {
            model.DataCadastro = System.DateTime.Now;
            return base.Save(model, Operacao);
        }
        public IActionResult ConsultaAvancada()
        {
            return View("ConsultaAvancada");
        }
    }
}
