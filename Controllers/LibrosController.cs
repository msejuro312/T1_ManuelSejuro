using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using T1_ManuelSejuro.Models;

namespace T1_ManuelSejuro.Controllers
{
    public class LibrosController : Controller
    {
        private readonly string? conexion;

        public LibrosController(IConfiguration configuration)
        {
            conexion = configuration.GetConnectionString("conexion");
        }

        
        IEnumerable<Autores> ListarAutores()
        {
            List<Autores> temporal = new List<Autores>();
            using (SqlConnection con = new SqlConnection(conexion))
            {
                SqlCommand command = new SqlCommand("sp_listar_autores", con);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Autores autor = new Autores
                        {
                            idAutor = reader.GetInt32(0),
                            nombre = reader.GetString(1),
                            nacionalidad = reader.GetString(2)
                        };
                        temporal.Add(autor);
                    }
                }
            }
            return temporal;
        }

        
        IEnumerable<Libros> ListarLibros()
        {
            List<Libros> temporal = new List<Libros>();
            using (SqlConnection con = new SqlConnection(conexion))
            {
                SqlCommand command = new SqlCommand("sp_listar_libros", con);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Libros libro = new Libros
                        {
                            idLibro = reader.GetInt32(0),
                            titulo = reader.GetString(1),
                            idAutor = reader.GetInt32(2),
                            anio_publicacion = reader.GetInt32(3),
                            estado = reader.GetInt32(4),
                            nombre_autor = reader.GetString(5)
                        };
                        temporal.Add(libro);
                    }
                }
            }
            return temporal;
        }

        
        string InsertarLibro(string titulo, int idAutor, int anio_publicacion)
        {
            string mensaje = "";
            using (SqlConnection con = new SqlConnection(conexion))
            {
                SqlCommand command = new SqlCommand("sp_insertar_libro", con);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@titulo", titulo);
                command.Parameters.AddWithValue("@idAutor", idAutor);
                command.Parameters.AddWithValue("@anio_publicacion", anio_publicacion);
                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        mensaje = reader.GetString(0);
                    }
                }
            }
            return mensaje;
        }

        
        [HttpGet]
        public IActionResult Agregar()
        {
            IEnumerable<Autores> autores = ListarAutores();
            IEnumerable<Libros> libros = ListarLibros();
            ViewBag.Autores = new SelectList(autores, "idAutor", "nombre");
            return View(libros);
        }

        
        [HttpPost]
        public IActionResult Agregar(string titulo, int idAutor, int anio_publicacion)
        {
            string mensaje = InsertarLibro(titulo, idAutor, anio_publicacion);
            TempData["mensaje"] = mensaje;
            return RedirectToAction("Agregar");
        }
    }
}