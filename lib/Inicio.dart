import 'package:flutter/material.dart';
import 'package:santas_asadas/main.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
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
            child: Image.asset('assets/Logo.png',),
          ),
        ),
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
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration: const BoxDecoration(
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
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SANTAS ASADAS',
                        style: TextStyle(
                          color: Color(0xFFFBC02D),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Text(
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
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Ver Menú',
                        const Color(0xFF991B1B),
                        Colors.white,
                        () => Main.of(context)?.cambiarIndice(1)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Pedido',
                        const Color(0xFFFBC02D),
                        Colors.black,
                        () => Main.of(context)?.cambiarIndice(4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Sección Destacados
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nuestros Favoritos ✨',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const SizedBox(width: 15),
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(BuildContext context, String label, Color color, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCardMejorada(String titulo, String precio, String img, String descripcion) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: Image.asset(
              img,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(height: 120, child: Icon(Icons.restaurant)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$precio',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF991B1B)),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _mostrarDetalle(titulo, precio, img, descripcion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBC02D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: const Text(
                      'Ver',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
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
          backgroundColor: const Color(0xFFF58220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
          title: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 50),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Precio: \$$precio",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                descripcion,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
