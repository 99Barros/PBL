using System.ComponentModel.DataAnnotations;

namespace PBL_ThermoMotorIOT_Cad.Models
{
    public class UsuarioViewModel : PadraoViewModel
    {
        [Required(ErrorMessage = "Usuário é obrigatório.")]
        [StringLength(50, ErrorMessage = "O usuário deve ter no máximo 50 caracteres.")]
        public string Login { get; set; }

        [Required(ErrorMessage = "Senha é obrigatória.")]
        [StringLength(255, ErrorMessage = "A senha deve ter no máximo 255 caracteres.")]
        public string Senha { get; set; }

        [Required(ErrorMessage = "Nome é obrigatório.")]
        [StringLength(100, ErrorMessage = "O nome deve ter no máximo 100 caracteres.")]
        public string Nome { get; set; }

        [Required(ErrorMessage = "Email é obrigatório.")]
        [EmailAddress(ErrorMessage = "Email inválido.")]
        [StringLength(100, ErrorMessage = "O email deve ter no máximo 100 caracteres.")]
        public string Email { get; set; }

        [DataType(DataType.Date)]
        public DateTime? DataNascimento { get; set; }

        [StringLength(20, ErrorMessage = "O telefone deve ter no máximo 20 caracteres.")]
        public string? Telefone { get; set; }

        public DateTime DataRegistro { get; set; }
    }

}
