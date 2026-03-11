import 'package:flutter/material.dart';
import 'package:santas_asadas/main.dart';

class Inicio extends StatefulWidget {
   Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
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
            child: Image.asset('assets/Logo.png',),
          ),
        ),
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
             SizedBox(height: 25),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Ver Menú',
                         Color(0xFF991B1B),
                        Colors.white,
                        () => Main.of(context)?.cambiarIndice(1)),
                  ),
                   SizedBox(width: 15),
                  Expanded(
                    child: _buildMainButton(
                        context,
                        'Pedido',
                         Color(0xFFFBC02D),
                        Colors.black,
                        () => Main.of(context)?.cambiarIndice(4)),
                  ),
                ],
              ),
            ),
             SizedBox(height: 35),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nuestros Favoritos ✨',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
             SizedBox(height: 15),
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
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset:  Offset(0, 4)),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset:  Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:  BorderRadius.vertical(top: Radius.circular(19)),
            child: Image.asset(
              img,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                 SizedBox(height: 4),
                Text(
                  '\$$precio',
                  style:  TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF991B1B)),
                ),
                 SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _mostrarDetalle(titulo, precio, img, descripcion),
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color:  Color(0xFFFBC02D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child:  Text(
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
          backgroundColor:  Color(0xFFF58220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side:  BorderSide(color: Colors.black, width: 2),
          ),
          title: Text(
            titulo,
            style:  TextStyle(fontWeight: FontWeight.bold),
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
                  errorBuilder: (context, error, stackTrace) =>  Icon(Icons.restaurant, size: 50),
                ),
              ),
               SizedBox(height: 15),
              Text(
                "Precio: \$$precio",
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 10),
              Text(
                descripcion,
                style:  TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(
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
