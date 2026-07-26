using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using T1_ManuelSejuro.Models;

namespace T1_ManuelSejuro.Controllers
{
    public class PrestamosController : Controller
    {
        private readonly string? conexion;

        public PrestamosController(IConfiguration configuration)
        {
            conexion = configuration.GetConnectionString("conexion");
        }

        IEnumerable<Prestamos> ListarPrestamosXAnio(int year)
        {
            List<Prestamos> temporal = new List<Prestamos>();

            using (SqlConnection con = new SqlConnection(conexion))
            {
                SqlCommand command = new SqlCommand("sp_listar_prestamos_x_anio", con);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@year", year);
                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Prestamos prestamo = new Prestamos
                        {
                            idPrestamo = reader.GetInt32(0),
                            nombre_cliente = reader.GetString(1),
                            nombre_libro = reader.GetString(2),
                            fechaPrestamo = reader.GetDateTime(3)
                        };
                        temporal.Add(prestamo);
                    }
                }
            }
            return temporal;
        }


        public async Task<IActionResult> Index(int year = 0, int page = 0)
        {
            IEnumerable<Prestamos> prestamos = ListarPrestamosXAnio(year);
            int filas = 10; 
            int totalRegistros = prestamos.Count(); 
            int totalPaginas = totalRegistros % filas == 0 ?
                                (totalRegistros / filas) :
                                (totalRegistros / filas + 1);

            
            ViewBag.totalRegistros = totalRegistros;
            ViewBag.totalPaginas = totalPaginas;
            ViewBag.page = page;
            ViewBag.year = year;

            return View(await Task.Run(() => prestamos.Skip(filas * (page - 1)).Take(filas)));
        }
    }
}
