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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Hero header naranja con logo
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF97316), Color(0xFFFF6B00)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/Logo.png',
                          height: 80,
                          errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, size: 52, color: Color(0xFFF97316)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Santas Asadas',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Regístrate para pedir más rápido',
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Formulario sobre fondo gris
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      const Text(
                        'Tus datos de envío',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Solo necesitamos esto una vez',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                  _buildTextField(
                    controller: _nombreController,
                    validator: _validateName,
                    label: 'Nombre Completo',
                    icon: Icons.person_outline,
                    hint: 'Ej. Juan Pérez',
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _telefonoController,
                    validator: _validatePhone,
                    label: 'Teléfono de Contacto',
                    icon: Icons.phone_android_outlined,
                    hint: '311 123 4567',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _direccionController,
                    validator: _validateAddress,
                    label: 'Dirección (Calle y Número)',
                    icon: Icons.location_on_outlined,
                    hint: 'Ej. Calle Ixtlán #123, Los Fresnos',
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _referenciasController,
                    validator: _validateReferences,
                    label: 'Referencias (Opcional)',
                    icon: Icons.map_outlined,
                    hint: 'Ej. Entre calle X y Y, portón negro',
                    maxLines: 2,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _guardarDatos();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Datos guardados! Bienvenido.'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Main()),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF991B1B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.black26,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black38,
                      ),
                      child: const Text(
                        'COMENZAR A PEDIR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
          validator: validator ??
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
