import 'package:flutter/material.dart';
import 'database_helper.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _notificaciones = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSeccion('Notificaciones'),
          _buildSwitch('Activar notificaciones', 'Recibe avisos de tus pedidos',
              Icons.notifications_outlined, _notificaciones,
                  (val) => setState(() => _notificaciones = val)),
          const SizedBox(height: 16),
          _buildSeccion('Cuenta'),
          _buildBoton('Eliminar mis datos', Icons.delete_outline, Colors.red, () async {
            final confirmar = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Eliminar datos?'),
                content: const Text('Se borrarán tus datos y tendrás que registrarte de nuevo.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );
            if (confirmar == true && mounted) {
              await DatabaseHelper.instance.cerrarSesion();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSeccion(String titulo) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black45, letterSpacing: 0.5)),
  );

  Widget _buildSwitch(String titulo, String subtitulo, IconData icon, bool valor, ValueChanged<bool> onChange) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFFF97316)),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 12)),
        value: valor,
        activeColor: const Color(0xFFF97316),
        onChanged: onChange,
      ),
    );
  }

  Widget _buildBoton(String titulo, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black26),
        onTap: onTap,
      ),
    );
  }
}