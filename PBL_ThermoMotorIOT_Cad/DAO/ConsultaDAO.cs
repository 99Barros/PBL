using PBL_ThermoMotorIOT_Cad.Models;
using System.Data.SqlClient;
using System.Data;

namespace PBL_ThermoMotorIOT_Cad.DAO
{
    public class ConsultaDAO
    {
        //protected override ConsultaViewModel BuildModel(DataRow registro)
        //{
        //    ConsultaViewModel model = new ConsultaViewModel();
        //    model.nomeUsuario = registro["NomeUsuario"].ToString();
        //    model.nomeEmpresa = registro["NomeEmpresa"].ToString();
        //    model.nomeEstufa = registro["nomeEstufa"].ToString();
        //    return model;
        //}

        //protected override SqlParameter[] CreateParameters(ConsultaViewModel consulta)
        //{
        //    SqlParameter[] parameters = new SqlParameter[3];
        //    parameters[0] = new SqlParameter("NomeUsuario", consulta.nomeUsuario);
        //    parameters[1] = new SqlParameter("NomeEmpresa", consulta.nomeEmpresa);
        //    parameters[2] = new SqlParameter("NomeUsuario", consulta.nomeEstufa);

        //    return parameters;
        //}

        //public List<ConsultaViewModel> ConsultaAvancadaJogos(string descricao,
        //                                                     int categoria,
        //                                                     DateTime dataInicial,
        //                                                     DateTime dataFinal)
        //{
        //    SqlParameter[] p = {
        //        new SqlParameter("descricao", descricao),
        //        new SqlParameter("categoria", categoria),
        //        new SqlParameter("dataInicial", dataInicial),
        //        new SqlParameter("dataFinal", dataFinal),
        //    };
        //    var tabela = HelperDAO.ExecutaProcSelect("spConsultaAvancadaJogos", p);
        //    var lista = new List<ConsultaViewModel>();
        //    foreach (DataRow dr in tabela.Rows)
        //        lista.Add(MontaModel(dr));
        //    return lista;
        //}
        //public static ConsultaViewModel MontaModel(DataRow registro)
        //{
        //    ConsultaViewModel Jogo = new ConsultaViewModel();
        //    Jogo.Id = Convert.ToInt32(registro["id"]);
        //    Jogo.Descricao = registro["descricao"].ToString();
        //    Jogo.CategoriaID = Convert.ToInt32(registro["categoriaID"]);
        //    Jogo.Valor = Convert.ToDouble(registro["valor_locacao"]);
        //    Jogo.DataAquisicao = Convert.ToDateTime(registro["data_aquisicao"]);
        //    if (registro.Table.Columns.Contains("DescricaoCategoria"))
        //        Jogo.DescricaoCategoria = registro["DescricaoCategoria"].ToString();
        //    return Jogo;
        //}

        //protected override void SetTabela()
        //{
        //    Tabela = "";
        //}
    }
}
