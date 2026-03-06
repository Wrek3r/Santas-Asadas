import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui; // Importamos ui_web directamente

class Local extends StatefulWidget {
  const Local({super.key});

  @override
  State<Local> createState() => _LocalState();
}

class _LocalState extends State<Local> {
  @override
  void initState() {
    super.initState();
    
    // USAMOS ui.platformViewRegistry (directamente desde ui_web)
    ui.platformViewRegistry.registerViewFactory(
      'google-maps-view',
      (int viewId) => html.IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        // PEGA AQUÍ LA URL DE EMBED:
        ..src = 'https://www.google.com/maps?q=21.47429656720365,-104.87661093978429&output=embed'
        ..allowFullscreen = true,
    );
  }

  Future<void> _abrirEnMaps() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=21.47429656720365,-104.87661093978429');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _llamarTelefono() async {
    final Uri url = Uri.parse('tel:+523312345678');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
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
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: const Text(
          'Nuestra Ubicación',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mapa interactivo
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: const HtmlElementView(viewType: 'google-maps-view'),
            ),

            // Información del local
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📍 Dirección',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calle Ixtlán, C. Ayutla esquina',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Tepic, Nayarit',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          'C.P. 63197',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    '🕐 Horarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Column(
                      children: [
                        HorarioItem(dia: 'Lunes - Viernes', horario: '10:00 AM - 10:00 PM'),
                        Divider(),
                        HorarioItem(dia: 'Sábado', horario: '9:00 AM - 11:00 PM'),
                        Divider(),
                        HorarioItem(dia: 'Domingo', horario: '9:00 AM - 9:00 PM'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    '📞 Contacto',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.phone, color: Color(0xFF991B1B)),
                            SizedBox(width: 10),
                            Text(
                              '+52 33 1234 5678',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.email, color: Color(0xFF991B1B)),
                            SizedBox(width: 10),
                            Text(
                              'contacto@santasasadas.com',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _abrirEnMaps,
                          icon: const Icon(Icons.directions, color: Colors.white),
                          label: const Text(
                            'Cómo llegar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF991B1B),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _llamarTelefono,
                          icon: const Icon(Icons.phone, color: Colors.black),
                          label: const Text(
                            'Llamar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBC02D),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorarioItem extends StatelessWidget {
  final String dia;
  final String horario;

  const HorarioItem({
    super.key,
    required this.dia,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dia,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            horario,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
