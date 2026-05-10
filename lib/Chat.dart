import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'models/OrderModel.dart';
import 'providers/CartProvider.dart';
import 'ApiService.dart';

class Chat extends StatefulWidget {
  Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isSubmitting = false;

  bool _isWithinBusinessHours() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final hour = now.hour;

    // Sábado (6) o Domingo (7), entre 12 y 17
    return (weekday == 6 || weekday == 7) && hour >= 12 && hour < 17;
  }

  Future<void> _submitOrder() async {
    if (!_isWithinBusinessHours()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Los pedidos solo se aceptan sábados y domingos de 12:00 PM a 5:00 PM',
          ),
        ),
      );
      return;
    }

    final cart = Provider.of<CartProvider>(context, listen: false);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('El carrito está vacío')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('nombre') ?? 'Cliente';
      final address = prefs.getString('direccion') ?? 'No especificada';
      final phone = prefs.getString('telefono') ?? '';
      final notes = prefs.getString('notas') ?? '';

      final order = OrderModel(
        items: cart.items,
        total: cart.totalAmount,
        customerName: userName,
        customerPhone: phone,
        deliveryAddress: address,
        notes: notes,
      );

      // Enviar a API (opcional, ya que se envía por WhatsApp)
      final apiService = ApiService();
      await apiService.submitOrder(order);

      // Generar mensaje de WhatsApp
      await _sendWhatsAppMessage(order);

      // Limpiar carrito después del pedido
      cart.clearCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar pedido: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _sendWhatsAppMessage(OrderModel order) async {
    String telefonoEstablecimiento = "+523112348161";

    String itemsText = order.items
        .map(
          (item) =>
              '• ${item.product.title} x${item.quantity} - \$${item.total.toStringAsFixed(2)}',
        )
        .join('\n');

    String mensaje =
        "¡Hola Santas Asadas! 🔥 Nuevo pedido de ${order.customerName}.\n\n"
        "📦 PRODUCTOS:\n$itemsText\n\n"
        "💰 TOTAL: \$${order.total.toStringAsFixed(2)}\n\n"
        "📍 DIRECCIÓN DE ENTREGA: ${order.deliveryAddress}\n"
        "📞 TELÉFONO: ${order.customerPhone}\n"
        "📝 NOTAS: ${order.notes.isNotEmpty ? order.notes : 'Ninguna'}";

    final Uri url = Uri.parse(
      "https://wa.me/$telefonoEstablecimiento?text=${Uri.encodeComponent(mensaje)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo abrir WhatsApp')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/Logo.png',
              errorBuilder: (_, __, ___) => Icon(Icons.restaurant),
            ),
          ),
        ),
        title: Text(
          'Confirmar Pedido',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.shopping_basket_outlined,
                  size: 80,
                  color: Color(0xFF991B1B),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Resumen de tu Pedido',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              if (cart.items.isEmpty) ...[
                Center(
                  child: Text(
                    'Tu carrito está vacío.\nAgrega productos desde el menú.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ] else ...[
                Text(
                  'Productos:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                ...cart.items.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item.product.title),
                      subtitle: Text('Cantidad: ${item.quantity}'),
                      trailing: Text('\$${item.total.toStringAsFixed(2)}'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF991B1B),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Vaciar Carrito'),
                        content: Text(
                          '¿Estás seguro de que quieres vaciar el carrito?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              cart.clearCart();
                              Navigator.pop(context);
                            },
                            child: Text('Vaciar'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Vaciar Carrito',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 20),

                if (!_isWithinBusinessHours()) ...[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[800]),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '⚠️ Los pedidos solo se aceptan sábados y domingos de 12:00 PM a 5:00 PM.',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting || !_isWithinBusinessHours()
                        ? null
                        : _submitOrder,
                    icon: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                    label: Text(
                      _isSubmitting
                          ? 'ENVIANDO...'
                          : 'ENVIAR PEDIDO POR WHATSAPP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF25D366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton.icon(
                  onPressed: _llamarTelefono,
                  icon: Icon(Icons.phone, color: Colors.black, size: 28),
                  label: Text(
                    'LLAMAR POR TELÉFONO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBC02D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
