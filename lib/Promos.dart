import 'package:flutter/material.dart';

class Promos extends StatefulWidget {
  const Promos({super.key});

  @override
  State<Promos> createState() => _PromosState();
}

class _PromosState extends State<Promos> {
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
        title: const Text('Promociones', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF991B1B), // Rojo oscuro
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '¡OFERTAS DE HOY!',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBC02D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Solo por tiempo limitado 🔥',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _PromoCard(
              'PROMO FAMILIAR',
              '2kg Asada + Complementos + Refresco 2L',
              'ANTES: \$550',
              '\480',
              'assets/LandingFoto.jpg',
              const Color(0xFF991B1B),
            ),
            _PromoCard(
              'DOMINGO DE PAPAS',
              '2x1 en Papas de Asada',
              'Válido solo Domingo',
              '¡Aprovecha!',
              'assets/Paquete1.jpg',
              const Color(0xFFF58220),
            ),
            _PromoCard(
              'COMBO INDIVIDUAL',
              '1/4 kg Arrachera + Complementos',
              'Ideal para tu comida',
              '\$80',
              'assets/Paquete2.jpg',
              const Color(0xFF1A1A1A),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _PromoCard(String titulo, String desc, String sub, String precio, String img, Color colorBase) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(4, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            // Parte de la Imagen
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(img, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey[200])),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: colorBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(color: Color(0xFFFBC02D), fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      desc,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sub,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10, decoration: sub.contains('ANTES') ? TextDecoration.lineThrough : null),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          precio,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
