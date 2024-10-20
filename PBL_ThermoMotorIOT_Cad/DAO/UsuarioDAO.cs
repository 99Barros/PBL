using System.Data.SqlClient;
using System.Data;
using PBL_ThermoMotorIOT_Cad.Models;
using DAO;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class UsuarioDAO : PadraoDAO<UsuarioViewModel>
    {
        private static UsuarioViewModel BuildModel(DataRow registro)
        {
            UsuarioViewModel model = new UsuarioViewModel();
            model.IdUsuario = Convert.ToInt32(registro["IdUsuario"]);
            model.Login = registro["Login"].ToString();
            model.Nome = registro["Nome"].ToString();
            model.Email = registro["Email"].ToString();
            model.DataNascimento = Convert.ToDateTime(registro["DataNascimento"]);
            model.Telefone = registro["Telefone"].ToString();
            return model;
        }
        private static SqlParameter[] CreateParameters(UsuarioViewModel usuario)
        {
            SqlParameter[] parameters = new SqlParameter[8];
            parameters[0] = new SqlParameter("IdUsuario", usuario.IdUsuario);
            parameters[1] = new SqlParameter("Login", usuario.Login);
            parameters[2] = new SqlParameter("Senha", usuario.Senha);
            parameters[3] = new SqlParameter("Nome", usuario.Nome);
            parameters[4] = new SqlParameter("Email", usuario.Email);
            parameters[5] = new SqlParameter("DataNascimento", usuario.DataNascimento);
            parameters[6] = new SqlParameter("Telefone", usuario.Telefone);
            parameters[7] = new SqlParameter("DataRegistro", usuario.DataRegistro);
            return parameters;
        }
         protected override void SetTabela()
        {
            Tabela = "Usuarios";
            /*NomeSpListagem = "spListagemUsuarios";
            conferir se a procedure precisa de join*/
        }
    }
}
