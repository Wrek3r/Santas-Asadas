import 'package:flutter/material.dart';

class Promos extends StatefulWidget {
  Promos({super.key});

  @override
  State<Promos> createState() => _PromosState();
}

class _PromosState extends State<Promos> {
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
        title: const Text('Promociones'),
        centerTitle: true,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado limpio
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ofertas de hoy',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBC02D).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tiempo limitado',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF7A5000)),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                'Aprovecha estas promociones exclusivas',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),

            _PromoCard(
              titulo: 'Promo Familiar',
              desc: '2kg Asada + Complementos + Refresco 2L',
              precioAntes: '\$550',
              precioDespues: '\$480',
              img: 'assets/LandingFoto.jpg',
              tag: 'AHORRA \$70',
              tagColor: const Color(0xFF991B1B),
            ),
            _PromoCard(
              titulo: 'Domingo de Papas',
              desc: '2x1 en Papas de Asada. Válido solo el domingo.',
              precioAntes: '',
              precioDespues: '¡Aprovecha!',
              img: 'assets/Paquetes/papaasadanatural.jpg',
              tag: '2×1',
              tagColor: const Color(0xFFF97316),
            ),
            _PromoCard(
              titulo: 'Combo Individual',
              desc: '1/4 kg Arrachera + Complementos incluidos',
              precioAntes: '',
              precioDespues: '\$80',
              img: 'assets/Paquetes/Paquete1.jpg',
              tag: 'PROMO',
              tagColor: const Color(0xFF388E3C),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _PromoCard({
    required String titulo,
    required String desc,
    required String precioAntes,
    required String precioDespues,
    required String img,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo a pantalla completa
            Image.asset(
              img,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF444444), Color(0xFF222222)],
                  ),
                ),
              ),
            ),

            // Gradiente oscuro desde abajo para legibilidad del texto
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),

            // Badge de tag en esquina superior izquierda
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
                ),
              ),
            ),

            // Texto en la parte inferior — con padding para no tocar los bordes
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (precioAntes.isNotEmpty) ...[
                        Text(
                          precioAntes,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white60,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        precioDespues,
                        style: const TextStyle(
                          color: Color(0xFFFBC02D),
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
