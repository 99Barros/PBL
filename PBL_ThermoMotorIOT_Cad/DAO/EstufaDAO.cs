using DAO;
using PBL_ThermoMotorIOT_Cad.Models;
using System.Data.SqlClient;
using System.Data;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class EstufaDAO
    {
        public static void Insert(EstufaViewModel estufa)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            estufa.DataCadastro = DateTime.Now;
            string sql = "INSERT INTO estufas (IdUsuario, IdEmpresa, Modelo, Descricao, Preco, PeriodoLocacao, DataCadastro) " +
                "VALUES (@IdUsuario, @IdEmpresa, @Modelo, @Descricao, @Preco, @PeriodoLocacao, @DataCadastro)";
            HelperDAO.ExecutaSql(sql, CreateParameters(estufa));
        }

        public static void Update(EstufaViewModel estufa)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "UPDATE estufas SET IdUsuario = @IdUsuario, IdEmpresa = @IdEmpresa, Modelo = @Modelo, " +
                "Descricao = @Descricao, Preco = @Preco, PeriodoLocacao = @PeriodoLocacao, DataCadastro = @DataCadastro " +
                "WHERE IdEstufa = @IdEstufa";
            HelperDAO.ExecutaSql(sql, CreateParameters(estufa));
        }

        public static void Delete(int id)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "DELETE FROM estufas WHERE IdEstufa = " + id;
            HelperDAO.ExecutaSql(sql, null);
        }

        public EstufaViewModel Search(int id)
        {
            string sql = "SELECT * FROM estufas WHERE IdEstufa = " + id;
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildModel(tabela.Rows[0]);
        }

        public static List<EstufaViewModel> AllSearch()
        {
            string sql = "SELECT * FROM estufas ORDER BY IdEstufa";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildTable(tabela);
        }

        public static List<EstufaViewModel> BuildTable(DataTable tabela)
        {
            List<EstufaViewModel> model = new List<EstufaViewModel>();

            foreach (DataRow registro in tabela.Rows)
            {
                model.Add(BuildModel(registro));
            }
            return model;
        }

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

        public int ProximoId()
        {
            string sql = "SELECT ISNULL(MAX(IdEstufa) + 1, 1) AS 'MAIOR' FROM estufas";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            return Convert.ToInt32(tabela.Rows[0]["MAIOR"]);
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
    }
}
