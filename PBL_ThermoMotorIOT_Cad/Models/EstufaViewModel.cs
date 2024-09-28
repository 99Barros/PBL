using System.ComponentModel.DataAnnotations;

namespace PBL_ThermoMotorIOT_Cad.Models
{
    public class EstufaViewModel
    {
        public int IdEstufa { get; set; }

        [Required(ErrorMessage = "Usuário é obrigatório.")]
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "Empresa é obrigatória.")]
        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = "Modelo é obrigatório.")]
        [StringLength(50, ErrorMessage = "O modelo deve ter no máximo 50 caracteres.")]
        public string Modelo { get; set; }

        [StringLength(255, ErrorMessage = "A descrição deve ter no máximo 255 caracteres.")]
        public string Descricao { get; set; }

        [Required(ErrorMessage = "Preço é obrigatório.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "O preço deve ser maior que zero.")]
        public decimal? Preco { get; set; }

        [Required(ErrorMessage = "Período de locação é obrigatório.")]
        [Range(1, int.MaxValue, ErrorMessage = "O período de locação deve ser maior que zero.")]
        public int PeriodoLocacao { get; set; }

        public DateTime DataCadastro { get; set; }
    }


}
