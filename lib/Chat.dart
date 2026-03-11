import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _pedidoController = TextEditingController();
  
  bool _mostrarFormulario = false;

  Future<void> _llamarTelefono() async {
    final Uri url = Uri.parse('tel:+523111022532');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo realizar la llamada')),
        );
      }
    }
  }

  void _sendWhatsAppMessage() async {
    if (_pedidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe tu pedido primero.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    
    String nombre = prefs.getString('nombre') ?? "Cliente";
    String direccion = prefs.getString('direccion') ?? "No especificada";
    String telefonoCliente = prefs.getString('telefono') ?? "";

    String telefonoEstablecimiento = "+523112348161"; 
    
    String mensaje = "¡Hola Santas Asadas! 🔥\n\n"
        "Soy *$nombre*.\n"
        "Mi dirección de entrega es: *$direccion*.\n"
        "Mi teléfono: $telefonoCliente\n\n"
        "📦 *MI PEDIDO:* \n${_pedidoController.text}";

    final Uri url = Uri.parse(
      "https://wa.me/$telefonoEstablecimiento?text=${Uri.encodeComponent(mensaje)}"
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/Logo.png', errorBuilder: (_,__,___) => const Icon(Icons.restaurant)),
          ),
        ),
        title: const Text('Realizar Pedido', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.shopping_basket_outlined, size: 80, color: Color(0xFF991B1B)),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '¿Cómo quieres pedir?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              
              // Vista inicial: Botones de opción
              if (!_mostrarFormulario) ...[
                // Botón para desplegar el formulario de pedido
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = true;
                      });
                    },
                    icon: const Icon(Icons.edit_note_rounded, size: 30, color: Colors.white),
                    label: const Text(
                      'ESCRIBIR MI PEDIDO POR WHATSAPP',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Botón de Llamada directa
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: _llamarTelefono,
                    icon: const Icon(Icons.phone, color: Colors.black, size: 28),
                    label: const Text(
                      'LLAMAR POR TELÉFONO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBC02D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],

              if (_mostrarFormulario) ...[
                const Text(
                  'Escribe tu pedido detalladamente:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pedidoController,
                  maxLines: 6,
                  autofocus: true,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Ej: kg de arrachera...',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF991B1B), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _sendWhatsAppMessage,
                    icon: const Icon(Icons.send_rounded, size: 28, color: Colors.white),
                    label: const Text(
                      'ENVIAR AHORA POR WHATSAPP',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = false;
                        _pedidoController.clear();
                      });
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
