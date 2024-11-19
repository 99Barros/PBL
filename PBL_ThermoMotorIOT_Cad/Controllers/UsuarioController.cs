using Microsoft.AspNetCore.Mvc;
using PBL_ThermoMotorIOT_Cad.DAO;
using PBL_ThermoMotorIOT_Cad.Models;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class UsuarioController : PadraoController<UsuarioViewModel>
    {
        public UsuarioController()
        {
            ExigeAutenticacao = false;
            DAO = new UsuarioDAO();
            GeraProximoId = true;
            //NomeViewForm = "Registro";
            //NomeViewIndex = "Home";
        }
        protected override void PreencheDadosParaView(string Operacao, UsuarioViewModel model)
        {
            model.DataNascimento = DateTime.Now;
            base.PreencheDadosParaView(Operacao, model);
        }

        public IActionResult Login()
        {
            ViewBag.Logado = TempData["logado"];
            ViewBag.NomeUsuario = TempData["nomeUsuario"];
            return View("Login");
        }
        public override IActionResult Create()
        {
            ViewBag.Logado = false;
            ViewBag.NomeUsuario = "Visitante";
            return base.Create();
        }
        public override IActionResult Save(UsuarioViewModel model, string Operacao)
        {
            try

            {
                ValidaDados(model, Operacao);
                if (ModelState.IsValid == false)
                {
                    ViewBag.Operacao = Operacao;
                    PreencheDadosParaView(Operacao, model);
                    return View(NomeViewForm, model);
                }
                else
                {
                    if (Operacao == "I")
                    {
                        model.DataRegistro = DateTime.Now;
                        DAO.Insert(model);
                    }
                    else
                        DAO.Update(model);
                    FazLogin(model.Login, model.Senha);
                    return RedirectToAction("index", "Home");
                }
            }
            catch (Exception erro)
            {
                return View("Error", new ErrorViewModel(erro.ToString()));
            }
        }

        public IActionResult FazLogin(string login, string senha)
        {
            var user = new UsuarioDAO().ChecaUsuario(login, senha);
            if (user != null)
            {
                HttpContext.Session.SetString("Logado", "true");
                HttpContext.Session.SetString("NomeUsuario", user.Nome);
                TempData["logado"] = true;
                TempData["nomeUsuario"] = user.Nome;
                return RedirectToAction("index", "Home");
            }
            else
            {
                ViewBag.Erro = "Usuário ou senha inválidos!";
                return View("Login");
            }
        }

        public IActionResult LogOff()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("index", "Home");
        }

        protected override void ValidaDados(UsuarioViewModel model, string operacao)
        {
            base.ValidaDados(model, operacao);
            if (model.Senha != model.SenhaConfirmacao)
                ModelState.AddModelError("Senha", "Senhas não conferem!");
        }

        public IActionResult ConsultaAvancada()
        {
            return View("ConsultaAvancada");
        }
    }
}
