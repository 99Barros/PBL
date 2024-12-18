﻿using System.ComponentModel.DataAnnotations;

namespace PBL_ThermoMotorIOT_Cad.Models
{
    public class EmpresaViewModel : PadraoViewModel
    {
        [Required(ErrorMessage = "Nome da empresa é obrigatório.")]
        [StringLength(150, ErrorMessage = "O nome da empresa deve ter no máximo 150 caracteres.")]
        public string NomeEmpresa { get; set; }

        [Required(ErrorMessage = "CNPJ é obrigatório.")]
        [StringLength(20, ErrorMessage = "O CNPJ deve ter no máximo 20 caracteres.")]
        public string CNPJ { get; set; }

        [Required(ErrorMessage = "CEP é obrigatório.")]
        [StringLength(9, ErrorMessage = "O CEP deve ter no máximo 9 caracteres.")]
        public string CEP { get; set; }

        [Required(ErrorMessage = "Logradouro é obrigatório.")]
        [StringLength(8, ErrorMessage = "O Numero deve ter no máximo 8 caracteres.")]
        public string Logradouro { get; set; }

        [Required(ErrorMessage = "Numero é obrigatório.")]
        public int Numero { get; set; }

        [Required(ErrorMessage = "Cidade é obrigatório.")]
        [StringLength(255, ErrorMessage = "A cidade deve ter no máximo 255 caracteres.")]
        public string Cidade { get; set; }

        [Required(ErrorMessage = "Estado é obrigatório.")]
        [StringLength(2, ErrorMessage = "A Estado deve ter no máximo 2 caracteres.")]
        public string Estado { get; set; }


        [StringLength(20, ErrorMessage = "O telefone deve ter no máximo 20 caracteres.")]
        public string? Telefone { get; set; }

        [EmailAddress(ErrorMessage = "Email inválido.")]
        [StringLength(100, ErrorMessage = "O email deve ter no máximo 100 caracteres.")]
        public string? Email { get; set; }

        public DateTime DataCadastro { get; set; }
        /// <summary>
        /// Imagem recebida do form pelo controller
        /// </summary>
        public IFormFile Imagem { get; set; }
        /// <summary>
        /// Imagem em bytes pronta para ser salva
        /// </summary>
        public byte[] ImagemEmByte { get; set; }
        /// <summary>
        /// Imagem usada para ser enviada ao form no formato para ser exibida
        /// </summary>
        public string ImagemEmBase64
        {
            get
            {
                if (ImagemEmByte != null)
                    return Convert.ToBase64String(ImagemEmByte);
                else
                    return string.Empty;
            }
        }

    }


}