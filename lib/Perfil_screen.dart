import 'package:flutter/material.dart';
import 'database_helper.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController    = TextEditingController();
  final _telefonoController  = TextEditingController();
  final _direccionController = TextEditingController();
  final _referenciasController = TextEditingController();
  bool _editando = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuario = await DatabaseHelper.instance.obtenerUsuario();
    if (usuario != null) {
      _nombreController.text     = usuario['nombre'] ?? '';
      _telefonoController.text   = usuario['telefono'] ?? '';
      _direccionController.text  = usuario['direccion'] ?? '';
      _referenciasController.text = usuario['referencias'] ?? '';
    }
    setState(() => _cargando = false);
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    await DatabaseHelper.instance.guardarUsuario(
      nombre:      _nombreController.text.trim(),
      telefono:    _telefonoController.text.trim(),
      direccion:   _direccionController.text.trim(),
      referencias: _referenciasController.text.trim(),
    );
    setState(() => _editando = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: Icon(_editando ? Icons.close : Icons.edit_outlined),
            onPressed: () => setState(() => _editando = !_editando),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF97316)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 56, color: Color(0xFFF97316)),
              ),
              const SizedBox(height: 24),
              _buildField('Nombre', _nombreController, Icons.person_outline,
                  validator: (v) => v == null || v.trim().length < 3 ? 'Mínimo 3 caracteres' : null),
              const SizedBox(height: 16),
              _buildField('Teléfono', _telefonoController, Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().length < 10 ? 'Teléfono inválido' : null),
              const SizedBox(height: 16),
              _buildField('Dirección', _direccionController, Icons.location_on_outlined,
                  validator: (v) => v == null || v.trim().length < 10 ? 'Dirección muy corta' : null),
              const SizedBox(height: 16),
              _buildField('Referencias', _referenciasController, Icons.map_outlined,
                  maxLines: 2, validator: (_) => null),
              if (_editando) ...[
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _guardarCambios,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF991B1B),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                    ),
                    child: const Text('GUARDAR CAMBIOS',
                        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: _editando,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(prefixIcon: Icon(icon)),
        ),
      ],
    );
  }
}