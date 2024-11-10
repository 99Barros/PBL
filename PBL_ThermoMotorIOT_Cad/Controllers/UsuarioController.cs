using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class UsuarioController : PadraoController<UsuarioViewModel>
    {
        public UsuarioController()
        {
            DAO = new UsuarioDAO();
            GeraProximoId = true;
        }
        protected override void PreencheDadosParaView(string Operacao, UsuarioViewModel model)
        {
            model.DataNascimento = DateTime.Now;
            base.PreencheDadosParaView(Operacao, model);
        }

        public override IActionResult Save(UsuarioViewModel model, string Operacao)
        {            
            model.DataRegistro = DateTime.Now;
            return base.Save(model, Operacao);
        }

        public IActionResult ConsultaAvancada()
        {
            return View("ConsultaAvancada");
        }
    }
}
