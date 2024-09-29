using global::DAO;
using System.Data;
using System.Data.SqlClient;


namespace Dentista.DAO
{
    public static class HelperDAO
    {
        internal static DataTable ExecutaSql(string sql, SqlParameter[] parametros)
        {
            using (SqlConnection conexao = ConexaoBD.GetConexao())
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(sql, conexao))
                {   
                    if (parametros != null)
                        adapter.SelectCommand.Parameters.AddRange(parametros);
                    DataTable tabelaTemp = new DataTable();
                    adapter.Fill(tabelaTemp);
                    return tabelaTemp;
                }
            }
        }
    }
}