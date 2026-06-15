using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace venta
{
    public partial class Stock : Form
    {
        public Stock()
        {
            InitializeComponent();
        }
        SqlConnection conexionb = new SqlConnection("Data Source = DESKTOP-37L5TDN\\SQLEXPRESS; Initial Catalog = venta; Integrated Security = True;");
        DateTime hoy = DateTime.Now;
        private void Stock_Load(object sender, EventArgs e)
        {
            label9.Text = hoy.ToShortDateString();

            try
            {
                // 1. Definimos la consulta
                string consulta = "SELECT * FROM Articulos";

                // 2. Usamos el adaptador (él se encarga de abrir y cerrar la conexión)
                SqlDataAdapter adaptador = new SqlDataAdapter(consulta, conexionb);

                DataTable tabla = new DataTable();
                adaptador.Fill(tabla); // Aquí es donde antes tronaba

                // 3. Mostramos los datos
                dataGridView1.DataSource = tabla;
            }
            catch (Exception ex)
            {
                // Si algo sale mal, te avisará con un mensaje en pantalla
                MessageBox.Show("Error al conectar: " + ex.Message);
            }
        }
    }
}
