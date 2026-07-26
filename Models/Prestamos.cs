namespace T1_ManuelSejuro.Models
{
    public class Prestamos
    {
        public int idPrestamo { get; set; }
        public int idCliente { get; set; }
        public int idLibro { get; set; }
        public DateTime fechaPrestamo { get; set;}
        public DateTime? fechaDevolucion {get ; set;}
        public int estado { get; set; }
        public string nombre_cliente { get; set; }
        public string nombre_libro { get; set;}


    }
}
