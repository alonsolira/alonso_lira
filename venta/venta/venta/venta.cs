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
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox1.Width < tamanoAnimado.Width)
                {
                    pictureBox1.Size = new Size(pictureBox1.Width + paso, pictureBox1.Height + paso);
                    pictureBox1.Location = new Point(pictureBox1.Left - (paso / 2), pictureBox1.Top - (paso / 2));
                }
                else
                {
                    timer1.Stop(); 
                }
            }
            else 
            {             
                if (pictureBox1.Width > tamanoOriginal.Width)
                {
                    pictureBox1.Size = new Size(pictureBox1.Width - paso, pictureBox1.Height - paso);
                    pictureBox1.Location = new Point(pictureBox1.Left + (paso / 2), pictureBox1.Top + (paso / 2));
                }
                else
                {
                    timer1.Stop();
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

        private void pictureBox2_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer2.Start();
        }

        private void pictureBox2_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer2.Start();
        }

        private void pictureBox4_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer4.Start();
        }

        private void pictureBox4_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer4.Start();
        }

        private void pictureBox3_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer3.Start();
        }

        private void pictureBox3_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer3.Start();
        }

        private void pictureBox5_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer5.Start();
        }

        private void pictureBox5_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer5.Start();
        }

        private void pictureBox7_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer7.Start();
        }

        private void pictureBox7_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer7.Start();
        }

        private void pictureBox6_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer6.Start();
        }

        private void pictureBox6_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer6.Start();
        }

        private void pictureBox8_MouseEnter(object sender, EventArgs e)
        {
            expandiendo = true;
            timer8.Start();
        }

        private void pictureBox8_MouseLeave(object sender, EventArgs e)
        {
            expandiendo = false;
            timer8.Start();
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox2.Width < tamanoAnimado.Width)
                {
                    pictureBox2.Size = new Size(pictureBox2.Width + paso, pictureBox2.Height + paso);
                    pictureBox2.Location = new Point(pictureBox2.Left - (paso / 2), pictureBox2.Top - (paso / 2));
                }
                else
                {
                    timer2.Stop();
                }
            }
            else
            {
                if (pictureBox2.Width > tamanoOriginal.Width)
                {
                    pictureBox2.Size = new Size(pictureBox2.Width - paso, pictureBox2.Height - paso);
                    pictureBox2.Location = new Point(pictureBox2.Left + (paso / 2), pictureBox2.Top + (paso / 2));
                }
                else
                {
                    timer2.Stop();
                }
            }
        }

        private void timer3_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox3.Width < tamanoAnimado.Width)
                {
                    pictureBox3.Size = new Size(pictureBox3.Width + paso, pictureBox3.Height + paso);
                    pictureBox3.Location = new Point(pictureBox3.Left - (paso / 2), pictureBox3.Top - (paso / 2));
                }
                else
                {
                    timer3.Stop();
                }
            }
            else
            {
                if (pictureBox3.Width > tamanoOriginal.Width)
                {
                    pictureBox3.Size = new Size(pictureBox3.Width - paso, pictureBox3.Height - paso);
                    pictureBox3.Location = new Point(pictureBox3.Left + (paso / 2), pictureBox3.Top + (paso / 2));
                }
                else
                {
                    timer3.Stop();
                }
            }
        }

        private void timer4_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox4.Width < tamanoAnimado.Width)
                {
                    pictureBox4.Size = new Size(pictureBox4.Width + paso, pictureBox4.Height + paso);
                    pictureBox4.Location = new Point(pictureBox4.Left - (paso / 2), pictureBox4.Top - (paso / 2));
                }
                else
                {
                    timer4.Stop();
                }
            }
            else
            {
                if (pictureBox4.Width > tamanoOriginal.Width)
                {
                    pictureBox4.Size = new Size(pictureBox4.Width - paso, pictureBox4.Height - paso);
                    pictureBox4.Location = new Point(pictureBox4.Left + (paso / 2), pictureBox4.Top + (paso / 2));
                }
                else
                {
                    timer4.Stop();
                }
            }
        }

        private void timer5_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox5.Width < tamanoAnimado.Width)
                {
                    pictureBox5.Size = new Size(pictureBox5.Width + paso, pictureBox5.Height + paso);
                    pictureBox5.Location = new Point(pictureBox5.Left - (paso / 2), pictureBox5.Top - (paso / 2));
                }
                else
                {
                    timer5.Stop();
                }
            }
            else
            {
                if (pictureBox5.Width > tamanoOriginal.Width)
                {
                    pictureBox5.Size = new Size(pictureBox5.Width - paso, pictureBox5.Height - paso);
                    pictureBox5.Location = new Point(pictureBox5.Left + (paso / 2), pictureBox5.Top + (paso / 2));
                }
                else
                {
                    timer5.Stop();
                }
            }
        }

        private void timer6_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox6.Width < tamanoAnimado.Width)
                {
                    pictureBox6.Size = new Size(pictureBox6.Width + paso, pictureBox6.Height + paso);
                    pictureBox6.Location = new Point(pictureBox6.Left - (paso / 2), pictureBox6.Top - (paso / 2));
                }
                else
                {
                    timer6.Stop();
                }
            }
            else
            {
                if (pictureBox6.Width > tamanoOriginal.Width)
                {
                    pictureBox6.Size = new Size(pictureBox6.Width - paso, pictureBox6.Height - paso);
                    pictureBox6.Location = new Point(pictureBox6.Left + (paso / 2), pictureBox6.Top + (paso / 2));
                }
                else
                {
                    timer6.Stop();
                }
            }
        }

        private void timer7_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox7.Width < tamanoAnimado.Width)
                {
                    pictureBox7.Size = new Size(pictureBox7.Width + paso, pictureBox7.Height + paso);
                    pictureBox7.Location = new Point(pictureBox7.Left - (paso / 2), pictureBox7.Top - (paso / 2));
                }
                else
                {
                    timer7.Stop();
                }
            }
            else
            {
                if (pictureBox7.Width > tamanoOriginal.Width)
                {
                    pictureBox7.Size = new Size(pictureBox7.Width - paso, pictureBox7.Height - paso);
                    pictureBox7.Location = new Point(pictureBox7.Left + (paso / 2), pictureBox7.Top + (paso / 2));
                }
                else
                {
                    timer7.Stop();
                }
            }
        }

        private void timer8_Tick(object sender, EventArgs e)
        {
            int paso = 4;

            if (expandiendo)
            {
                if (pictureBox8.Width < tamanoAnimado.Width)
                {
                    pictureBox8.Size = new Size(pictureBox8.Width + paso, pictureBox8.Height + paso);
                    pictureBox8.Location = new Point(pictureBox8.Left - (paso / 2), pictureBox8.Top - (paso / 2));
                }
                else
                {
                    timer8.Stop();
                }
            }
            else
            {
                if (pictureBox8.Width > tamanoOriginal.Width)
                {
                    pictureBox8.Size = new Size(pictureBox8.Width - paso, pictureBox8.Height - paso);
                    pictureBox8.Location = new Point(pictureBox8.Left + (paso / 2), pictureBox8.Top + (paso / 2));
                }
                else
                {
                    timer8.Stop();
                }
            }
        }
    }
}
