using System.ComponentModel.DataAnnotations;

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
        [StringLength(255, ErrorMessage = "O Logradouro deve ter no máximo 255 caracteres.")]
        public string Logradouro { get; set; }

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
    }


}