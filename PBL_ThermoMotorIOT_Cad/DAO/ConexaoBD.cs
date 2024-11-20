﻿using System.Data.SqlClient;

namespace DAO
{
    public static class ConexaoBD
    {
        /// <summary> 
        /// Método Estático que retorna um conexao aberta com o BD 
        /// </summary> 
        /// <returns>Conexão aberta</returns> 
        public static SqlConnection GetConexao()
        {
            //string strCon = "Data Source=localhost; Database=PBL; user id=sa; password=123456";
            string strCon = "Data Source=DESKTOP-FTRI8H1\\MSSQLSERVER02; Database=PBL; user id=sa; password=123456";
            SqlConnection conexao = new SqlConnection(strCon);
            conexao.Open();
            return conexao;
        }
    }
}