using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace venta
{
    internal class conexion
    {
        SqlCommand cmd;
        //SqlConnection conexionb = new SqlConnection("Data Source = laptop-fv3ucubq\\sqlexpress; Initial Catalog = inventario; integrated Security=True");
        //SqlConnection conexionb = new SqlConnection("Data Source = 192.168.8.2; Initial Catalog = inventario; user id=usuario1;password=123");

        SqlConnection conexionb = new SqlConnection("Data Source = 192.168.1.3; Initial Catalog = venta; user id=alonso;password=1234");

        public static SqlConnection ObtenerCOnexion()
        {
            //SqlConnection conexion = new SqlConnection("Data Source = laptop-fv3ucubq\\sqlexpress; Initial Catalog = inventario; integrated Security=True");
            SqlConnection conexion = new SqlConnection("Data Source = 192.168.1.3; Initial Catalog = venta; user id=alonso;password=1234");

            conexion.Open();
            //MessageBox.Show("Welcome!!");
            return conexion;
        }

        string conexiona = "Data Source = 192.168.1.3; Initial Catalog = venta; user id=alonso;password=1234";
        public SqlConnection conectarbd = new SqlConnection();
        public conexion()
        {
            conectarbd.ConnectionString = conexiona;
        }
        public void Abrir()
        {
            try
            {
                conectarbd.Open();
                MessageBox.Show("Welcome!!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Desconectado enciende el servidor SQL", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
            }
        }
    }
}
