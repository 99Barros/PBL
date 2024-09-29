using Dentista.DAO;
using System.Data.SqlClient;
using System.Data;
using PBL_ThermoMotorIOT_Cad.Models;
using DAO;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class UsuarioDAO
    {
        public static void Insert(UsuarioViewModel usuario)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "INSERT INTO usuarios values (@IdUsuario, @Usuario, @Senha, @Nome, @Email, @DataNascimento, @Telefone, @DataRegistro)";
            HelperDAO.ExecutaSql(sql, CreateParameters(usuario));
        }
        public static void Update(UsuarioViewModel usuario)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "UPDATE usuarios set Usuario=@Usuario, Senha=@Senha, Nome=@Nome, Email=@Email, " +
                "DataNascimento=@DataNascimento, Telefone=@Telefone, DataRegistro=@DataRegistro WHERE IdUsuario = @IdUsuario";
            HelperDAO.ExecutaSql(sql, CreateParameters(usuario));
        }
        public static void Delete(int id)
        {
            SqlConnection connection = ConexaoBD.GetConexao();
            string sql = "DELETE FROM usuarios WHERE IdUsuario=" + id;
            HelperDAO.ExecutaSql(sql, null);
        }
        public UsuarioViewModel Search(int id)
        {
            string sql = "select * from usuarios where IdUsuario = " + id;
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildModel(tabela.Rows[0]);
        }
        public static List<UsuarioViewModel> AllSearch()
        {
            string sql = "select * from usuarios order by IdUsuario";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            if (tabela.Rows.Count == 0)
                return null;
            else
                return BuildTable(tabela);
        }
        public static List<UsuarioViewModel> BuildTable(DataTable tabela)
        {
            List<UsuarioViewModel> model = new List<UsuarioViewModel>();

            foreach (DataRow registro in tabela.Rows)
            {
                model.Add(BuildModel(registro));
            }
            return model;
        }
        private static UsuarioViewModel BuildModel(DataRow registro)
        {
            UsuarioViewModel model = new UsuarioViewModel();
            model.IdUsuario = Convert.ToInt32(registro["IdUsuario"]);
            model.Usuario = registro["Usuario"].ToString();
            model.Nome = registro["Nome"].ToString();
            model.Email = registro["Email"].ToString();
            model.DataNascimento = Convert.ToDateTime(registro["DataNascimento"]);
            model.Telefone = registro["Telefone"].ToString();
            return model;
        }
        public int ProximoId()
        {
            string sql = "select isnull(max(IdUsuario) +1, 1) as 'MAIOR' from usuarios";
            DataTable tabela = HelperDAO.ExecutaSql(sql, null);
            return Convert.ToInt32(tabela.Rows[0]["MAIOR"]);
        }
        private static SqlParameter[] CreateParameters(UsuarioViewModel usuario)
        {
            SqlParameter[] parameters = new SqlParameter[8];
            parameters[0] = new SqlParameter("IdUsuario", usuario.IdUsuario);
            parameters[1] = new SqlParameter("Usuario", usuario.Usuario);
            parameters[2] = new SqlParameter("Senha", usuario.Senha);
            parameters[3] = new SqlParameter("Nome", usuario.Nome);
            parameters[4] = new SqlParameter("Email", usuario.Email);
            parameters[5] = new SqlParameter("DataNascimento", usuario.DataNascimento);
            parameters[6] = new SqlParameter("Telefone", usuario.Telefone);
            parameters[7] = new SqlParameter("DataRegsitro", usuario.DataRegistro);
            return parameters;
        }
    }
}
