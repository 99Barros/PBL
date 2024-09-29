using Dentista.DAO;
using System.Data.SqlClient;
using System.Data;
using PBL_ThermoMotorIOT_Cad.Models;
using DAO;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class EmpresaDAO
    {
        public static void Insert(EmpresaViewModel empresa)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            empresa.DataCadastro = DateTime.Now;
            string sql = "INSERT INTO empresas values (@NomeEmpresa, @CNPJ, @Endereco, @Telefone, @Email, @DataCadastro)";
            HelperDAO.ExecutaSql(sql, CreateParameters(empresa));
        }
        public static void Update(EmpresaViewModel empresa)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "UPDATE empresas set NomeEmpresa=@NomeEmpresa, CNPJ=@CNPJ, Endereco=@Endereco, Telefone=@Telefone," +
                " Email=@Email, DataCastro=@DataCastro WHERE IdEmpresa = @IdEmpresa";
            HelperDAO.ExecutaSql(sql, CreateParameters(empresa));
        }
        public static void Delete(int id)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "DELETE FROM empresas WHERE IdEmpresa=" + id;
            HelperDAO.ExecutaSql(sql, null);
        }
        public EmpresaViewModel Search(int id)
        {
            string sql = "select * from empresas where IdEmpresa = " + id;
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildModel(tabela.Rows[0]);
        }
        public static List<EmpresaViewModel> AllSearch()
        {
            string sql = "select * from empresas order by IdEmpresa";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildTable(tabela);
        }
        public static List<EmpresaViewModel> BuildTable(DataTable tabela)
        {
            List<EmpresaViewModel> model = new List<EmpresaViewModel>();

            foreach (DataRow registro in tabela.Rows)
            {
                model.Add(BuildModel(registro));
            }
            return model;
        }
        private static EmpresaViewModel BuildModel(DataRow registro)
        {
            EmpresaViewModel model = new EmpresaViewModel();
            model.NomeEmpresa = registro["NomeEmpresa"].ToString();
            model.CNPJ = registro["CNPJ"].ToString();
            model.Endereco = registro["Endereco"].ToString();
            model.Telefone = registro["Telefone"].ToString();
            model.Email = registro["Email"].ToString();
            model.DataCadastro = Convert.ToDateTime(registro["DataCadastro"]);
            return model;
        }
        public int ProximoId()
        {
            string sql = "select isnull(max(IdEmpresa) +1, 1) as 'MAIOR' from empresas";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            return Convert.ToInt32(tabela.Rows[0]["MAIOR"]);
        }
        private static SqlParameter[] CreateParameters(EmpresaViewModel empresa)
        {
            SqlParameter[] parameters = new SqlParameter[7];
            parameters[0] = new SqlParameter("IdEmpresa", empresa.IdEmpresa);
            parameters[1] = new SqlParameter("NomeEmpresa", empresa.NomeEmpresa);
            parameters[2] = new SqlParameter("CNPJ", empresa.CNPJ);
            parameters[3] = new SqlParameter("Endereco", empresa.Endereco);
            parameters[4] = new SqlParameter("Telefone", empresa.Telefone);
            parameters[5] = new SqlParameter("Email", empresa.Email);
            parameters[6] = new SqlParameter("DataCadastro", empresa.DataCadastro);
            return parameters;
        }
    }
}
