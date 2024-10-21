using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class UsuarioController : Controller
    {
        public IActionResult Index()
        {
            UsuarioDAO dao = new UsuarioDAO();
            List<UsuarioViewModel> listModel = new List<UsuarioViewModel>();
            listModel = dao.Listagem();
            return View(listModel);
        }

        public IActionResult Create()
        {
            try
            {
                UsuarioViewModel usuario = new UsuarioViewModel();
                UsuarioDAO dao = new UsuarioDAO();
                usuario.Id = dao.ProximoId();
                return View("Form", usuario);
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }


        public IActionResult Salvar(UsuarioViewModel usuario)
        {
            try
            {
                UsuarioDAO dao = new UsuarioDAO();
                usuario.DataRegistro = DateTime.Now;
                if (dao.Search(usuario.Id) == null)
                    dao.Insert(usuario);
                else
                    dao.Update(usuario);
                return RedirectToAction("index");
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
                UsuarioDAO dao = new UsuarioDAO();
                UsuarioViewModel usuario = dao.Search(id);
                if (usuario == null)
                    return RedirectToAction("index");
                else
                    return View("Form", usuario);
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
                UsuarioDAO dao = new UsuarioDAO();
                dao.Delete(id);
                return RedirectToAction("index");
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }
        public IActionResult ConsultaAvancada()
        {
            return View("ConsultaAvancada");
        }
    }
}
