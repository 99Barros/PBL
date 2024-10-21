using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class EmpresaController : Controller
    {
        public IActionResult Index()
        {
            EmpresaDAO dao = new EmpresaDAO();
            List<EmpresaViewModel> listModel = new List<EmpresaViewModel>();
            listModel = dao.Listagem();
            return View(listModel);
        }
        public IActionResult Create()
        {
            try
            {
                EmpresaViewModel empresa = new EmpresaViewModel();
                EmpresaDAO dao = new EmpresaDAO();
                empresa.Id = dao.ProximoId();
                return View("Form", empresa);
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }


        public IActionResult Salvar(EmpresaViewModel empresa)
        {
            try
            {
                EmpresaDAO dao = new EmpresaDAO();
                empresa.DataCadastro = DateTime.Now;
                if (dao.Search(empresa.Id) == null)
                    dao.Insert(empresa);
                else
                    dao.Update(empresa);
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
                EmpresaDAO dao = new EmpresaDAO();
                EmpresaViewModel empresa = dao.Search(id);
                if (empresa == null)
                    return RedirectToAction("index");
                else
                    return View("Form", empresa);
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
                EmpresaDAO dao = new EmpresaDAO();
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
