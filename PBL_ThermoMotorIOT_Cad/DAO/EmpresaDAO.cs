﻿using System.Data.SqlClient;
using System.Data;
using PBL_ThermoMotorIOT_Cad.Models;
using DAO;
using System.Reflection;

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
            model.CEP = registro["CEP"].ToString();
            model.Logradouro = registro["Logradouro"].ToString();
            model.Numero = Convert.ToInt16(registro["Numero"]);
            model.Cidade = registro["Cidade"].ToString();
            model.Estado = registro["Estado"].ToString();
            model.Telefone = registro["Telefone"].ToString();
            model.Email = registro["Email"].ToString();
            model.DataCadastro = Convert.ToDateTime(registro["DataCadastro"]);
            if (registro["imagem"] != DBNull.Value)
                model.ImagemEmByte = registro["imagem"] as byte[];

            return model;
        }
        protected override SqlParameter[] CreateParameters(EmpresaViewModel empresa)
        {
            object imgByte = empresa.ImagemEmByte;
            if (imgByte == null)
                imgByte = DBNull.Value;
            SqlParameter[] parameters = new SqlParameter[12];
            parameters[0] = new SqlParameter("Id", empresa.id);
            parameters[1] = new SqlParameter("NomeEmpresa", empresa.NomeEmpresa);
            parameters[2] = new SqlParameter("CNPJ", empresa.CNPJ);
            parameters[3] = new SqlParameter("CEP", empresa.CEP);
            parameters[4] = new SqlParameter("Logradouro", empresa.Logradouro);
            parameters[5] = new SqlParameter("numero", empresa.Numero);
            parameters[6] = new SqlParameter("Cidade", empresa.Cidade);
            parameters[7] = new SqlParameter("Estado", empresa.Estado);
            parameters[8] = new SqlParameter("Telefone", empresa.Telefone != null ? empresa.Telefone : DBNull.Value);
            parameters[9] = new SqlParameter("Email", empresa.Email != null ? empresa.Email : DBNull.Value);
            parameters[10] = new SqlParameter("DataCadastro", empresa.DataCadastro);
            parameters[11] = new SqlParameter("Imagem", imgByte);
            return parameters;
        }

        protected override void SetTabela()
        {
            Tabela = "Empresas";
            //NomeSpListagem = "spListagemEmpresas"; 
        }
    }
}