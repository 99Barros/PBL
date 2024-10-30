using System.Data.SqlClient;
using System.Data;
using PBL_ThermoMotorIOT_Cad.Models;
using DAO;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class EmpresaDAO : PadraoDAO<EmpresaViewModel>
    {
        protected override EmpresaViewModel BuildModel(DataRow registro)
        {
            EmpresaViewModel model = new EmpresaViewModel();
            model.id = Convert.ToInt32(registro["Id"]);
            model.NomeEmpresa = registro["NomeEmpresa"].ToString();
            model.CNPJ = registro["CNPJ"].ToString();
            model.Endereco = registro["Endereco"].ToString();
            model.Telefone = registro["Telefone"].ToString();
            model.Email = registro["Email"].ToString();
            model.DataCadastro = Convert.ToDateTime(registro["DataCadastro"]);
            return model;
        }
        protected override SqlParameter[] CreateParameters(EmpresaViewModel empresa)
        {
            SqlParameter[] parameters = new SqlParameter[7];
            parameters[0] = new SqlParameter("Id", empresa.id);
            parameters[1] = new SqlParameter("NomeEmpresa", empresa.NomeEmpresa);
            parameters[2] = new SqlParameter("CNPJ", empresa.CNPJ);
            parameters[3] = new SqlParameter("Endereco", empresa.Endereco);
            parameters[4] = new SqlParameter("Telefone", empresa.Telefone != null ? empresa.Telefone : DBNull.Value);
            parameters[5] = new SqlParameter("Email", empresa.Email != null ? empresa.Email : DBNull.Value);
            parameters[6] = new SqlParameter("DataCadastro", empresa.DataCadastro);
            return parameters;
        }

        protected override void SetTabela()
        {
            Tabela = "Empresas";
            //NomeSpListagem = "spListagemEmpresas"; 
        }
    }
}
