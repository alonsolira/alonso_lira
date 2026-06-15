using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace venta
{
    public partial class RegistrarArticulo : Form
    {
        public RegistrarArticulo()
        {
            InitializeComponent();
        }
        DateTime hoy = DateTime.Now;
        private void RegistrarArticulo_Load(object sender, EventArgs e)
        {
            label9.Text = hoy.ToShortDateString();

        }
    }
}
