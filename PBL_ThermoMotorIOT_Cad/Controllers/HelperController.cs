using Microsoft.AspNetCore.Mvc;

namespace PBL_ThermoMotorIOT_Cad.Controllers
{
    public class HelperController 
    {
        public static Boolean VerificaUserLogado(ISession session)
        {
            string logado = session.GetString("Logado");
            if (logado == null)
                return false;
            else
                return true;
        }
    }
}
