import 'package:flutter/material.dart';
import 'package:RDG/database/database_helper.dart';
import 'package:RDG/main.dart';
import 'resumen_screen.dart';
import 'package:flutter/services.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final iglesiaCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final peticionCtrl = TextEditingController();
  int visitaNumero = 1;

  final FocusNode nombreFocus = FocusNode();
  final FocusNode apellidoFocus = FocusNode();
  final FocusNode iglesiaFocus = FocusNode();
  final FocusNode telefonoFocus = FocusNode();
  final FocusNode peticionFocus = FocusNode();

  @override
  void dispose() {
    nombreFocus.dispose();
    apellidoFocus.dispose();
    iglesiaFocus.dispose();
    telefonoFocus.dispose();
    peticionFocus.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();

      await DatabaseHelper.instance.insert({
        'nombre': nombreCtrl.text,
        'apellido': apellidoCtrl.text,
        'visita_numero': visitaNumero,
        // Si el campo está vacío, guardamos un texto por defecto o vacío
        'iglesia': iglesiaCtrl.text.isEmpty ? 'Ninguna / De casa' : iglesiaCtrl.text,
        'telefono': telefonoCtrl.text.isEmpty ? 'N/A' : telefonoCtrl.text,
        'peticion': peticionCtrl.text.isEmpty ? 'Sin petición' : peticionCtrl.text,
        'fecha': DateTime.now().toString().split(' ')[0],
      });
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('¡Registro Guardado!'),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );

      setState(() {
        _formKey.currentState!.reset(); 
        nombreCtrl.clear();
        apellidoCtrl.clear();
        iglesiaCtrl.clear();
        telefonoCtrl.clear();
        peticionCtrl.clear();
        visitaNumero = 1; 
      });
      
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
    appBar: AppBar(
        // Quitamos el centerTitle para que el Row use todo el ancho
        centerTitle: false, 
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RDG REGISTRO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20, // Tamaño grande
              ),
            ),
            // Mostramos el nombre del encargado a la derecha
            Flexible(
              child: Text(
                encargado,
                overflow: TextOverflow.ellipsis, 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, 
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const ResumenScreen())
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _cardWrapper(
                column: Column(
                  children: [
                    _buildField(
                      nombreCtrl, "Nombre", Icons.person_rounded,
                      esObligatorio: true, // Campo requerido
                      currentFocus: nombreFocus,
                      nextFocus: apellidoFocus,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      apellidoCtrl, "Apellido", Icons.person_outline_rounded,
                      esObligatorio: true, // Campo requerido
                      currentFocus: apellidoFocus,
                      nextFocus: iglesiaFocus,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _cardWrapper(
                column: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Frecuencia de visita", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: visitaNumero,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("🌟 Primera Vez")),
                        DropdownMenuItem(value: 2, child: Text("🔄 Segunda Vez")),
                      ],
                      onChanged: (v) => setState(() => visitaNumero = v!),
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      iglesiaCtrl, "¿De qué iglesia viene?", Icons.church_rounded,
                      esObligatorio: false, // Ahora es opcional
                      currentFocus: iglesiaFocus,
                      nextFocus: telefonoFocus,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _cardWrapper(
                column: Column(
                  children: [
                    _buildField(
                      telefonoCtrl, "Teléfono (Opcional)", Icons.phone_android_rounded, 
                      type: TextInputType.phone,
                      esObligatorio: false, // Ahora es opcional
                      currentFocus: telefonoFocus,
                      nextFocus: peticionFocus,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      peticionCtrl, "Petición de Oración (Opcional)", Icons.favorite_rounded, 
                      lines: 3,
                      esObligatorio: false, // Ahora es opcional
                      currentFocus: peticionFocus,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: const Icon(Icons.save),
                  label: const Text("GUARDAR REGISTRO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardWrapper({required Widget column}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: column,
    );
  }

  Widget _buildField(
    TextEditingController ctrl, 
    String label, 
    IconData icon, {
    TextInputType type = TextInputType.text, 
    int lines = 1,
    required bool esObligatorio, // Nuevo parámetro para controlar validación
    FocusNode? currentFocus,
    FocusNode? nextFocus,
  }) {
    return TextFormField(
      controller: ctrl,
      focusNode: currentFocus,
      keyboardType: type,
      maxLines: lines,
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (term) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      // Solo valida si el campo es obligatorio
      validator: (v) {
        if (esObligatorio && (v == null || v.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }
}