using Microsoft.AspNetCore.Mvc; 
using Microsoft.AspNetCore.Mvc.Rendering;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class EstufaController : PadraoController<EstufaViewModel>
    {
        public EstufaController()
        {
            DAO = new EstufaDAO();
            GeraProximoId = true;
        }
        public override IActionResult Index()
        {
            List<EstufaViewModel> listModel = new List<EstufaViewModel>();
            EstufaDAO dao = new();
            listModel = dao.Listagem();
            EmpresaDAO daoEmpresa = new();
            foreach (EstufaViewModel model in listModel)
            {
                ViewData[model.IdEmpresa.ToString()] = daoEmpresa.Search(model.IdEmpresa).NomeEmpresa;
            }
            return base.Index(); 
        }
        public override IActionResult Create()
        {
            PreparaListaEmpresasParaCombo();
            PreparaListaUsuariosParaCombo();
            return base.Create();
        }

        public override IActionResult Save(EstufaViewModel model, string Operacao)
        {
            model.DataCadastro = System.DateTime.Now;
            return base.Save(model, Operacao);
        }
        public override IActionResult Edit(int id)
        {
            PreparaListaEmpresasParaCombo();
            PreparaListaUsuariosParaCombo();
            return base.Edit(id);
        }

        private void PreparaListaEmpresasParaCombo()        
        {
            EmpresaDAO dao = new EmpresaDAO();
            var empresas = dao.Listagem();
            List<SelectListItem> listaEmpresas = new List<SelectListItem>();

            listaEmpresas.Add(new SelectListItem("Selecione uma empresa...", "0"));
            foreach (var empresa in empresas)
            {
                SelectListItem item = new SelectListItem(empresa.NomeEmpresa, empresa.id.ToString());
                listaEmpresas.Add(item);
            }
            ViewBag.Empresas = listaEmpresas;
        }

        private void PreparaListaUsuariosParaCombo()
        {
            UsuarioDAO dao = new UsuarioDAO();
            var usuarios = dao.Listagem();
            List<SelectListItem> listaUsuarios = new List<SelectListItem>();

            listaUsuarios.Add(new SelectListItem("Selecione um usuario...", "0"));
            foreach (var usuario in usuarios)
            {
                SelectListItem item = new SelectListItem(usuario.Login, usuario.id.ToString());
                listaUsuarios.Add(item);
            }
            ViewBag.Usuarios = listaUsuarios;
        }
        public IActionResult ConsultaAvancada()
        {
            return View("ConsultaAvancada");
        }
    }
}
