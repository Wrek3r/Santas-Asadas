import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _referenciasController = TextEditingController();

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', _nombreController.text.trim());
    await prefs.setString('telefono', _telefonoController.text.trim());
    await prefs.setString('direccion', _direccionController.text.trim());
    await prefs.setString('referencias', _referenciasController.text.trim());
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Ingresa al menos 3 caracteres';
    }
    final nameRegex = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Ingresa solo letras y espacios';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    final cleaned = value.replaceAll(RegExp(r"[\s\-()]"), '');
    if (!RegExp(r"^\d+$").hasMatch(cleaned)) {
      return 'Solo se permiten números';
    }
    if (cleaned.length < 10 || cleaned.length > 15) {
      return 'Ingresa un teléfono válido de 10 a 15 dígitos';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.trim().length < 10) {
      return 'Ingresa una dirección más detallada';
    }
    return null;
  }

  String? _validateReferences(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length < 5) {
      return 'La referencia debe tener al menos 5 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF58220),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 80),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/Logo.png',
                    height: 90,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'DATOS DE ENVÍO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Regístrate para pedir más rápido',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),

                _buildTextField(
                  controller: _nombreController,
                  validator: _validateName,
                  label: 'Nombre Completo',
                  icon: Icons.person,
                  hint: 'Ej. Juan Pérez',
                ),
                SizedBox(height: 20),

                _buildTextField(
                  controller: _telefonoController,
                  validator: _validatePhone,
                  label: 'Teléfono de Contacto',
                  icon: Icons.phone_android,
                  hint: '311 123 4567',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),

                _buildTextField(
                  controller: _direccionController,
                  validator: _validateAddress,
                  label: 'Dirección (Calle y Número)',
                  icon: Icons.location_on,
                  hint: 'Ej. Calle Ixtlán #123, Los Fresnos',
                ),
                SizedBox(height: 20),

                _buildTextField(
                  controller: _referenciasController,
                  validator: _validateReferences,
                  label: 'Referencias (Opcional)',
                  icon: Icons.map,
                  hint: 'Ej. Entre calle X y Y, portón negro',
                  maxLines: 2,
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _guardarDatos(); // Guardamos los datos

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('¡Datos guardados! Bienvenido.'),
                            ),
                          );

                          // Navegamos al inicio reemplazando el Login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Main()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF991B1B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'COMENZAR A PEDIR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFF991B1B), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
        ),
      ],
    );
  }
}
