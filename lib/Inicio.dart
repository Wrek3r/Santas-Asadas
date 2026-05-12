import 'package:flutter/material.dart';
import 'package:santas_asadas/main.dart';

class Inicio extends StatefulWidget {
   Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}
// Pantalla de inicio con imagen de fondo, botones principales y sección de favoritos
class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/Logo.png'),
          ),
        ),
        title: const Text('Santas Asadas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration:  BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    image: DecorationImage(
                      image: AssetImage('assets/LandingFoto.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'SANTAS ASADAS',
                        style: TextStyle(
                          color: Color(0xFFFBC02D),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                       Text(
                        'DONDE EL FUEGO SE\nCONVIERTE EN SABOR 🔥',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Ver Menú',
                        Icons.restaurant_menu,
                        const Color(0xFF991B1B),
                        Colors.white,
                        () => Main.of(context)?.cambiarIndice(1)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Hacer Pedido',
                        Icons.shopping_basket_outlined,
                        const Color(0xFFFBC02D),
                        Colors.black87,
                        () => Main.of(context)?.cambiarIndice(4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nuestros Favoritos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text('Ver todo', style: TextStyle(fontSize: 13, color: Colors.orangeAccent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCardMejorada(
                      'Paquete Familiar',
                      '355',
                      'assets/Paquetes/Paquete1.jpg',
                      '• 1 Kg Arrachera muy al estilo de las Santas Asadas\n• 2 Piezas de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
                    ),
                  ),
                   SizedBox(width: 15),
                  Expanded(
                    child: _buildCardMejorada(
                      'Paquete Individual',
                      '75',
                      'assets/Paquetes/Paquete2.jpg',
                      '• 1/4 Carne Asada\n• 1 Pieza de Chorizo Corona\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(BuildContext context, String label, IconData icon, Color color, Color textColor, VoidCallback? onTap) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 3,
          shadowColor: Colors.black38,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildCardMejorada(String titulo, String precio, String img, String descripcion) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            img,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 120,
              color: Colors.grey[200],
              child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$precio',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF991B1B)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _mostrarDetalle(titulo, precio, img, descripcion),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBC02D),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Ver detalles'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalle(String titulo, String precio, String imagen, String descripcion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF8F0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          title: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  child: Image.asset(
                    imagen,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 100,
                      child: Center(child: Icon(Icons.restaurant, size: 50, color: Colors.grey)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$$precio',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        descripcion,
                        style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF991B1B)),
              child: const Text('Cerrar', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBC02D),
                foregroundColor: Colors.black87,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text('Ver Menú', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }
}
