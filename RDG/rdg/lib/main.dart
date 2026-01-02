import 'package:flutter/material.dart';
import 'package:RDG/screens/formulario_screen.dart';

// Variable global para el encargado
String encargado = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RDG App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
      ),
      home: const InicioConOperador(),
    );
  }
}

class InicioConOperador extends StatefulWidget {
  const InicioConOperador({super.key});

  @override
  State<InicioConOperador> createState() => _InicioConOperadorState();
}

class _InicioConOperadorState extends State<InicioConOperador> {
  final TextEditingController _operadorCtrl = TextEditingController();

  void _ingresar() {
    if (_operadorCtrl.text.trim().isNotEmpty) {
      setState(() {
        encargado = _operadorCtrl.text.trim();
      });
      // Navegación fluida hacia el formulario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FormularioScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingrese su nombre")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Degradado moderno para el fondo
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Color(0xFF1A237E)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono o Logo de Bienvenida
              const Icon(
                Icons.account_circle_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                "¡Bienvenido!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Por favor, identifícate para comenzar el registro de visitas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              
              // Campo de texto estilizado
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: TextField(
                  controller: _operadorCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: "Nombre del Encargado",
                    prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Botón de Ingreso llamativo
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _ingresar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "INGRESAR",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}