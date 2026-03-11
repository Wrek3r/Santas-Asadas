import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
   Chat({super.key});

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
           SnackBar(content: Text('No se pudo realizar la llamada')),
        );
      }
    }
  }

  void _sendWhatsAppMessage() async {
    if (_pedidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Por favor, escribe tu pedido primero.')),
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
           SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding:  EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/Logo.png', errorBuilder: (_,__,___) =>  Icon(Icons.restaurant)),
          ),
        ),
        title:  Text('Realizar Pedido', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon:  Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Center(
                child: Icon(Icons.shopping_basket_outlined, size: 80, color: Color(0xFF991B1B)),
              ),
               SizedBox(height: 20),
               Center(
                child: Text(
                  '¿Cómo quieres pedir?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
               SizedBox(height: 30),
              
              if (!_mostrarFormulario) ...[
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = true;
                      });
                    },
                    icon:  Icon(Icons.edit_note_rounded, size: 30, color: Colors.white),
                    label:  Text(
                      'ESCRIBIR MI PEDIDO POR WHATSAPP',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF25D366), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:  BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: _llamarTelefono,
                    icon:  Icon(Icons.phone, color: Colors.black, size: 28),
                    label:  Text(
                      'LLAMAR POR TELÉFONO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFFFBC02D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:  BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],

              if (_mostrarFormulario) ...[
                 Text(
                  'Escribe tu pedido detalladamente:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                 SizedBox(height: 10),
                TextField(
                  controller: _pedidoController,
                  maxLines: 6,
                  autofocus: true,
                  style:  TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Ej: kg de arrachera...',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:  BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:  BorderSide(color: Color(0xFF991B1B), width: 2),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _sendWhatsAppMessage,
                    icon:  Icon(Icons.send_rounded, size: 28, color: Colors.white),
                    label:  Text(
                      'ENVIAR AHORA POR WHATSAPP',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF25D366), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:  BorderSide(color: Colors.black, width: 2),
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
                    child:  Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
               SizedBox(height: 20),
               SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
