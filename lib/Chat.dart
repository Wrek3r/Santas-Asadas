import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'models/OrderModel.dart';
import 'providers/CartProvider.dart';
import 'database_helper.dart';

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
    // Comenta esto temporalmente para probar:
    // if (!_isWithinBusinessHours()) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Los pedidos solo se aceptan sábados y domingos de 12:00 PM a 5:00 PM')),
    //   );
    //   return;
    // }

    final cart = Provider.of<CartProvider>(context, listen: false);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('El carrito está vacío')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final usuario = await DatabaseHelper.instance.obtenerUsuario();
      final userName = usuario?['nombre'] ?? 'Cliente';
      final address = usuario?['direccion'] ?? 'No especificada';
      final phone = usuario?['telefono'] ?? '';
      final notes = usuario?['referencias'] ?? '';
      final order = OrderModel(
        items: cart.items,
        clienteNombre: userName,
        clienteTelefono: phone,
        direccionEntrega: address,
        notas: notes,
      );


      await _sendWhatsAppMessage(order);

      cart.clearCart();
      final resumen = order.items.map((i) => '${i.productTitle} x${i.quantity}').join(', ');
      await DatabaseHelper.instance.guardarPedido(resumen, order.total);
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
              '• ${item.productTitle} x${item.quantity} - \$${item.subtotal.toStringAsFixed(2)}',
        )
        .join('\n');

    String mensaje =
        "¡Hola Santas Asadas! 🔥 Nuevo pedido de ${order.clienteNombre}.\n\n"
        "📦 PRODUCTOS:\n$itemsText\n\n"
        "💰 TOTAL: \$${order.total.toStringAsFixed(2)}\n\n"
        "📍 DIRECCIÓN DE ENTREGA: ${order.direccionEntrega}\n"
        "📞 TELÉFONO: ${order.clienteTelefono}\n"
        "📝 NOTAS: ${order.notas?.isNotEmpty ?? false ? order.notas : 'Ninguna'}";

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
        toolbarHeight: 64,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/Logo.png',
              errorBuilder: (_, __, ___) => const Icon(Icons.restaurant),
            ),
          ),
        ),
        title: const Text('Confirmar Pedido'),
        centerTitle: true,
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF991B1B).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_basket_outlined, size: 56, color: Color(0xFF991B1B)),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Resumen de tu Pedido',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 24),

              if (cart.items.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.remove_shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Tu carrito está vacío.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[700])),
                      const SizedBox(height: 8),
                      Text('Agrega productos desde el menú.', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Productos', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Vaciar carrito'),
                            content: const Text('¿Estás seguro de que quieres vaciar el carrito?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () { cart.clearCart(); Navigator.pop(context); },
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF991B1B), foregroundColor: Colors.white),
                                child: const Text('Vaciar'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Vaciar'),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF991B1B)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...cart.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(item.productTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Cantidad: ${item.quantity}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      ),
                      trailing: Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFFF97316)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF991B1B).withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total a pagar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF991B1B))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (!_isWithinBusinessHours()) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Colors.amber.shade600, width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule_outlined, color: Colors.amber[800], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Los pedidos solo se aceptan sábados y domingos de 12:00 PM a 5:00 PM.',
                            style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitOrder,
                    icon: _isSubmitting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, size: 22, color: Colors.white),
                    label: Text(
                      _isSubmitting ? 'Enviando...' : 'Enviar por WhatsApp',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _llamarTelefono,
                  icon: const Icon(Icons.phone_outlined, size: 22),
                  label: const Text('Llamar por teléfono', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBC02D),
                    foregroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
