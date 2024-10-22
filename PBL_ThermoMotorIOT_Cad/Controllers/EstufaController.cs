using Microsoft.AspNetCore.Mvc; 
using Microsoft.AspNetCore.Mvc.Rendering;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class EstufaController : Controller
    {
        public IActionResult Index()
        {
            EstufaDAO dao = new EstufaDAO();
            List<EstufaViewModel> listModel = new List<EstufaViewModel>();
            listModel = dao.Listagem();
            EmpresaDAO daoEmpresa = new();
            if (listModel != null)
            {
                foreach (EstufaViewModel model in listModel)
                {
                    ViewData[model.IdEmpresa.ToString()] = daoEmpresa.Search(model.IdEmpresa).NomeEmpresa;
                }
            }          
            return View(listModel);
        }

        public IActionResult Create()
        {
            try
            {
                PreparaListaEmpresasParaCombo();
                PreparaListaUsuariosParaCombo();
                EstufaViewModel estufa = new EstufaViewModel();
                EstufaDAO dao = new EstufaDAO();
                estufa.id = dao.ProximoId();
                return View("Form", estufa);
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }

        public IActionResult Salvar(EstufaViewModel estufa)
        {
            try
            {
                EstufaDAO dao = new EstufaDAO();
                estufa.DataCadastro = DateTime.Now;
                if (dao.Search(estufa.id) == null)
                    dao.Insert(estufa);
                else
                    dao.Update(estufa);
                return RedirectToAction("Index");
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }

        public IActionResult Edit(int id)
        {
            try
            {
                EstufaDAO dao = new EstufaDAO();
                EstufaViewModel estufa = dao.Search(id);
                if (estufa == null)
                    return RedirectToAction("Index");
                else
                {
                    PreparaListaEmpresasParaCombo();
                    PreparaListaUsuariosParaCombo();
                    return View("Form", estufa);
                }
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }

        public IActionResult Delete(int id)
        {
            try
            {
                EstufaDAO dao = new EstufaDAO();
                dao.Delete(id);
                return RedirectToAction("Index");
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
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
