import 'package:flutter/material.dart';
import 'package:RDG/database/database_helper.dart';
import 'package:RDG/main.dart'; // Importante para acceder a nombreOperador
import 'package:url_launcher/url_launcher.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  String? fechaFiltro;
  int? filtroVisita;

  // --- FUNCIÓN: MODAL DE CONFIRMACIÓN ---
  void _mostrarConfirmacionCompartir(BuildContext context, List<Map<String, dynamic>> registros) {
    int cantidad = registros.length;
    
    String titulo = filtroVisita == null ? "Compartir Todo" : "Compartir Filtro";
    
    // Texto personalizado según el filtro
    String mensajeCuerpo = filtroVisita == null 
        ? "Hola $encargado, se va a generar un resumen de TODOS los visitantes ($cantidad personas)." 
        : "Hola $encargado, se va a generar un resumen solo de los visitantes de la $filtroVisitaª vez ($cantidad personas).";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.chat, color: Colors.green),
              const SizedBox(width: 10),
              Text(titulo),
            ],
          ),
          content: Text(mensajeCuerpo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Cierra el modal
                _compartirWhatsApp(registros); // Envía a WhatsApp
              },
              child: const Text("ACEPTAR Y ENVIAR"),
            ),
          ],
        );
      },
    );
  }
  // --- MÉTODO PARA MOSTRAR LA ALERTA DE LIMPIEZA TOTAL ---
  void _confirmarLimpiezaTotal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // No se cierra al tocar fuera
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text("¿Borrar todo?"),
        ],
      ),
      content: const Text(
        "¿Estás seguro de eliminar TODOS los registros? "
        "Esta acción es permanente y los datos ya no serán recuperados.",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            await DatabaseHelper.instance.deleteAll();
            if (!mounted) return;
            Navigator.pop(context); // Cierra el diálogo
            setState(() {}); // Refresca la lista vacía
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Base de datos vaciada correctamente"),
                backgroundColor: Colors.black87,
              ),
            );
          },
          child: const Text("SÍ, ELIMINAR TODO"),
        ),
      ],
    ),
  );
}
  // --- MÉTODO PARA MOSTRAR LA ALERTA DE ELIMINACIÓN ---
  void _confirmarEliminacion(BuildContext context, int id, String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar registro?"),
        content: Text("¿Estás seguro de que deseas eliminar a $nombre? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete(id);
              if (!mounted) return;
              Navigator.pop(context); // Cierra el diálogo
              setState(() {}); // Refresca la lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registro eliminado correctamente")),
              );
            },
            child: const Text("ELIMINAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- CARD ACTUALIZADA CON BOTÓN DE ELIMINAR ---
  Widget _buildCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item['visita_numero'] == 1 ? Colors.green[100] : Colors.orange[100],
          child: Icon(
            item['visita_numero'] == 1 ? Icons.star : Icons.repeat,
            color: item['visita_numero'] == 1 ? Colors.green : Colors.orange,
          ),
        ),
        title: Text("${item['nombre']} ${item['apellido']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("📆 ${item['fecha']} • 🏛️ ${item['iglesia']}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _confirmarEliminacion(context, item['id'], item['nombre']),
        ),
        onTap: () => _mostrarDetalle(context, item),
      ),
    );
  }

  void _compartirWhatsApp(List<Map<String, dynamic>> registros) async {
    if (registros.isEmpty) return;

    // 1. Calculamos los totales internos de la lista que se va a enviar
    int totalEnviados = registros.length;
    int totalPrimeraVez = registros.where((r) => r['visita_numero'] == 1).length;
    int totalSegundaVez = registros.where((r) => r['visita_numero'] == 2).length;

    // 2. Construimos el encabezado dinámico
    String mensaje = "📋 *RESUMEN DE VISITAS RDG*\n";
    mensaje += "👤 *Encargado:* $encargado\n";
    
    if (filtroVisita == 1) {
      mensaje += "🌟 *Solo Primera Vez:* $totalPrimeraVez personas\n";
    } else if (filtroVisita == 2) {
      mensaje += "🔄 *Solo Segunda Vez:* $totalSegundaVez personas\n";
    } else {
      // Si es el resumen completo
      mensaje += "📊 *Total General:* $totalEnviados personas\n";
      mensaje += "   - 🌟 Primera vez: $totalPrimeraVez\n";
      mensaje += "   - 🔄 Segunda vez: $totalSegundaVez\n";
    }
    
    if (fechaFiltro != null) {
      mensaje += "📅 *Fecha:* $fechaFiltro\n";
    }

    mensaje += "--------------------------------\n\n";

    // 3. Listado de personas
    for (var p in registros) {
      mensaje += "👤 *${p['nombre']} ${p['apellido']}*\n";
      mensaje += "🔄 Visita: #${p['visita_numero']}\n";
      mensaje += "📅 Fecha registro: ${p['fecha']}\n";
      mensaje += "🏛️ Iglesia: ${p['iglesia']}\n";
      mensaje += "📞 Tel: ${p['telefono']}\n";
      mensaje += "🙏 Petición: ${p['peticion']}\n";
      mensaje += "--------------------------------\n";
    }

    final Uri url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(mensaje)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Resumen y Listado'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
          icon: const Icon(Icons.delete_sweep, size: 28),
          tooltip: 'Borrar todo el historial',
          onPressed: () => _confirmarLimpiezaTotal(context),
        ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.queryAll(),
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  if (snapshot.hasData) {
                    final filtrados = _aplicarFiltros(snapshot.data!);
                    _mostrarConfirmacionCompartir(context, filtrados);
                  }
                },
              );
            }
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2040),
              );
              if (picked != null) setState(() => fechaFiltro = picked.toString().split(' ')[0]);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final registros = _aplicarFiltros(snapshot.data!);

          return Column(
            children: [
              _buildHeaderStats(snapshot.data!), 
              if (filtroVisita != null || fechaFiltro != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton.icon(
                    onPressed: () => setState(() { filtroVisita = null; fechaFiltro = null; }),
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text("Quitar filtros"),
                  ),
                ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: registros.isEmpty 
                  ? const Center(child: Text("No hay registros con este filtro"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: registros.length,
                      itemBuilder: (context, index) => _buildCard(registros[index]),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _aplicarFiltros(List<Map<String, dynamic>> original) {
    return original.where((r) {
      final matchFecha = fechaFiltro == null || r['fecha'] == fechaFiltro;
      final matchVisita = filtroVisita == null || r['visita_numero'] == filtroVisita;
      return matchFecha && matchVisita;
    }).toList();
  }



  Widget _buildHeaderStats(List<Map<String, dynamic>> todos) {
    int p = todos.where((r) => r['visita_numero'] == 1).length;
    int s = todos.where((r) => r['visita_numero'] == 2).length;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          _statButton("1ra Vez", p, Colors.green, 1),
          const SizedBox(width: 10),
          _statButton("2da Vez", s, Colors.orange, 2),
          const SizedBox(width: 10),
          _statButton("Total", todos.length, Colors.blue, null),
        ],
      ),
    );
  }

  Widget _statButton(String label, int value, Color color, int? tipo) {
    bool activo = filtroVisita == tipo;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => filtroVisita = tipo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: activo ? color.withOpacity(0.2) : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: activo ? color : color.withOpacity(0.2),
              width: activo ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text("$value", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: activo ? FontWeight.bold : FontWeight.normal, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDetalle(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text("${item['nombre']} ${item['apellido']}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const Divider(),
            _infoItem(Icons.phone, "Teléfono", item['telefono']),
            _infoItem(Icons.church, "Iglesia", item['iglesia']),
            _infoItem(Icons.calendar_month, "Fecha", item['fecha']),
            _infoItem(Icons.favorite, "Petición", item['peticion']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text("Compartir solo este contacto"),
                onPressed: () {
                  Navigator.pop(context); 
                  _mostrarConfirmacionCompartir(context, [item]); 
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 15),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}