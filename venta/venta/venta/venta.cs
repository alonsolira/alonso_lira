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
    public partial class venta : Form
    {
        public venta()
        {
            InitializeComponent();
            
        }

        private Size tamanoOriginal;
        private Size tamanoAnimado;
        private bool expandiendo = false;

        private void venta_Load(object sender, EventArgs e)
        {
            // Add any additional initialization logic here
            toolTip1.SetToolTip(pictureBox1, "Ventas");
            toolTip1.SetToolTip(pictureBox2, "Stock");
            toolTip1.SetToolTip(pictureBox3, "Sucursales");
            toolTip1.SetToolTip(pictureBox4, "Venta diaria");
            toolTip1.SetToolTip(pictureBox5, "Traspaso");
            toolTip1.SetToolTip(pictureBox6, "Devolucion");
            toolTip1.SetToolTip(pictureBox7, "Registro mercancia");
            toolTip1.SetToolTip(pictureBox8, "Registro de usuario");

            tamanoOriginal = pictureBox1.Size;
            tamanoAnimado = new Size(
                (int)(tamanoOriginal.Width * 1.2),
                (int)(tamanoOriginal.Height * 1.2)
            );

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            Stock optionForm = new Stock();
            optionForm.Show();
        }

        private void pictureBox7_Click(object sender, EventArgs e)
        {
            RegistrarArticulo optionForm = new RegistrarArticulo();
            optionForm.Show();
        }

        private void toolTip1_Draw(object sender, DrawToolTipEventArgs e)
        {
            // Dibuja el fondo estándar del ToolTip
            e.DrawBackground();

            // Define la fuente que quieres usar (Familia, Tamaño, Estilo)
            // ¡Aquí puedes cambiar "14" al tamaño que necesites!
            Font miFuente = new Font("Segoe UI", 13, FontStyle.Regular);

            // Dibuja el texto del mensaje con la nueva fuente
            e.Graphics.DrawString(e.ToolTipText, miFuente, Brushes.Black, new PointF(2, 2));

            // Dibuja el borde estándar del ToolTip
            e.DrawBorder();
        }

        private void toolTip1_Popup(object sender, PopupEventArgs e)
        {
            // 1. Define EXACTAMENTE LA MISMA fuente que usas en el evento Draw
            Font miFuente = new Font("Segoe UI", 13, FontStyle.Regular);

            // 2. Mide el tamaño que necesita el texto del control asociado
            string textoDelToolTip = toolTip1.GetToolTip(e.AssociatedControl);
            Size tamanoDelTexto = TextRenderer.MeasureText(textoDelToolTip, miFuente);

            // 3. Agrega un pequeño margen para que no quede justo
            tamanoDelTexto.Width += 6;  // Margen horizontal
            tamanoDelTexto.Height += 6; // Margen vertical

            // 4. Asigna el nuevo tamaño a la ventana del ToolTip
            e.ToolTipSize = tamanoDelTexto;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            int paso = 4; // Píxeles que se moverán en cada "tick". Afecta la velocidad.

            if (expandiendo)
            {
                // Si aún no llega al tamaño máximo, lo agranda
                if (pictureBox1.Width < tamanoAnimado.Width)
                {
                    // Agrandamos y movemos la ubicación para que el zoom se vea centrado
                    pictureBox1.Size = new Size(pictureBox1.Width + paso, pictureBox1.Height + paso);
                    pictureBox1.Location = new Point(pictureBox1.Left - (paso / 2), pictureBox1.Top - (paso / 2));
                }
                else
                {
                    timer1.Stop(); // Se detiene al llegar al tamaño final
                }
            }
            else // Encogiendo
            {
                // Si aún no llega al tamaño original, lo encoge
                if (pictureBox1.Width > tamanoOriginal.Width)
                {
                    // Encogemos y movemos la ubicación para centrar
                    pictureBox1.Size = new Size(pictureBox1.Width - paso, pictureBox1.Height - paso);
                    pictureBox1.Location = new Point(pictureBox1.Left + (paso / 2), pictureBox1.Top + (paso / 2));
                }
                else
                {
                    timer1.Stop(); // Se detiene al llegar al tamaño original
                }
            }
        }

        private void pictureBox1_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer1.Start();
        }

        private void pictureBox1_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer1.Start();

        }
    }
}
