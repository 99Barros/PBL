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
            
            List<EstufaViewModel> listModel = new List<EstufaViewModel>();
            listModel = EstufaDAO.AllSearch();
            EmpresaDAO daoEmpresa = new();
            foreach (EstufaViewModel model in listModel)
            {
                ViewData[model.IdEmpresa.ToString()]= daoEmpresa.Search(model.IdEmpresa).NomeEmpresa;
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
                estufa.IdEstufa = dao.ProximoId();
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
                if (dao.Search(estufa.IdEstufa) == null)
                    EstufaDAO.Insert(estufa);
                else
                    EstufaDAO.Update(estufa);
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
                EstufaDAO.Delete(id);
                return RedirectToAction("Index");
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }
        private void PreparaListaEmpresasParaCombo()        {
            
            var empresas = EmpresaDAO.AllSearch();
            List<SelectListItem> listaEmpresas = new List<SelectListItem>();

            listaEmpresas.Add(new SelectListItem("Selecione uma empresa...", "0"));
            foreach (var empresa in empresas)
            {
                SelectListItem item = new SelectListItem(empresa.NomeEmpresa, empresa.IdEmpresa.ToString());
                listaEmpresas.Add(item);
            }
            ViewBag.Empresas = listaEmpresas;
        }

        private void PreparaListaUsuariosParaCombo()
        {

            var usuarios = UsuarioDAO.AllSearch();
            List<SelectListItem> listaUsuarios = new List<SelectListItem>();

            listaUsuarios.Add(new SelectListItem("Selecione um usuario...", "0"));
            foreach (var usuario in usuarios)
            {
                SelectListItem item = new SelectListItem(usuario.Login, usuario.IdUsuario.ToString());
                listaUsuarios.Add(item);
            }
            ViewBag.Usuarios = listaUsuarios;
        }

    }
}
