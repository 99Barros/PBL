using DAO;
using PBL_ThermoMotorIOT_Cad.Models;
using System.Data.SqlClient;
using System.Data;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class EstufaDAO : PadraoDAO<EstufaViewModel>
    {
        private static EstufaViewModel BuildModel(DataRow registro)
        {
            EstufaViewModel model = new EstufaViewModel();
            model.IdEstufa = Convert.ToInt32(registro["IdEstufa"]);
            model.IdUsuario = Convert.ToInt32(registro["IdUsuario"]);
            model.IdEmpresa = Convert.ToInt32(registro["IdEmpresa"]);
            model.Modelo = registro["Modelo"].ToString();
            model.Descricao = registro["Descricao"].ToString();
            model.Preco = Convert.ToDecimal(registro["Preco"]);
            model.PeriodoLocacao = Convert.ToInt32(registro["PeriodoLocacao"]);
            model.DataCadastro = Convert.ToDateTime(registro["DataCadastro"]);
            return model;
        }
        
        private static SqlParameter[] CreateParameters(EstufaViewModel estufa)
        {
            SqlParameter[] parameters = new SqlParameter[8];
            parameters[0] = new SqlParameter("IdEstufa", estufa.IdEstufa);
            parameters[1] = new SqlParameter("IdUsuario", estufa.IdUsuario);
            parameters[2] = new SqlParameter("IdEmpresa", estufa.IdEmpresa);
            parameters[3] = new SqlParameter("Modelo", estufa.Modelo);
            parameters[4] = new SqlParameter("Descricao", estufa.Descricao);
            parameters[5] = new SqlParameter("Preco", estufa.Preco);
            parameters[6] = new SqlParameter("PeriodoLocacao", estufa.PeriodoLocacao);
            parameters[7] = new SqlParameter("DataCadastro", estufa.DataCadastro);
            return parameters;
        }
         protected override void SetTabela()
        {
            Tabela = "Estufas";
            /*NomeSpListagem = "spListagemEstufas";  
            conferir se a procedure precisa de join*\
        }
    }
}
