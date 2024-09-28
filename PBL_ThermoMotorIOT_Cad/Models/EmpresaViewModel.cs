using System.ComponentModel.DataAnnotations;

namespace PBL_ThermoMotorIOT_Cad.Models
{
    public class EmpresaViewModel
    {
        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = "Nome da empresa é obrigatório.")]
        [StringLength(150, ErrorMessage = "O nome da empresa deve ter no máximo 150 caracteres.")]
        public string NomeEmpresa { get; set; }

        [Required(ErrorMessage = "CNPJ é obrigatório.")]
        [StringLength(20, ErrorMessage = "O CNPJ deve ter no máximo 20 caracteres.")]
        public string CNPJ { get; set; }

        [Required(ErrorMessage = "Endereço é obrigatório.")]
        [StringLength(255, ErrorMessage = "O endereço deve ter no máximo 255 caracteres.")]
        public string Endereco { get; set; }

        [StringLength(20, ErrorMessage = "O telefone deve ter no máximo 20 caracteres.")]
        public string Telefone { get; set; }

        [EmailAddress(ErrorMessage = "Email inválido.")]
        [StringLength(100, ErrorMessage = "O email deve ter no máximo 100 caracteres.")]
        public string Email { get; set; }

        public DateTime DataCadastro { get; set; }
    }


}
