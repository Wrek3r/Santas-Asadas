import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Local extends StatefulWidget {
  const Local({super.key});

  @override
  State<Local> createState() => _LocalState();
}

class _LocalState extends State<Local> {
  static const LatLng _centroMapa = LatLng(21.4737677, -104.8766323);
  String? _localSeleccionado;

  static const CameraPosition _posicionCamara = CameraPosition(
    target: _centroMapa,
    zoom: 16.0,
  );

  final List<Map<String, dynamic>> _datosNegocio = [
    {
      'id': 'negocio',
      'nombre': 'Santas Asadas',
      'direccion': 'Calle Ixtlán, C. Ayutla esquina, Los Fresnos',
      'ciudad': 'Tepic, Nayarit',
      'telefonos': ['311-112-7858', '311-102-25-32'],
      'posicion': _centroMapa,
      'horario': 'Sab - Dom: 12:00 PM - 05:00 PM',
      'imagen': 'assets/local.jpg'
    },
  ];

  Future<void> _abrirMapaExterno() async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${_centroMapa.latitude},${_centroMapa.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _hacerLlamada(String tel) async {
    final url = Uri.parse('tel:$tel');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Set<Marker> _crearMarcadores() {
    return _datosNegocio.map((ubicacion) {
      return Marker(
        markerId: MarkerId(ubicacion['id']),
        position: ubicacion['posicion'],
        onTap: () {
          setState(() {
            _localSeleccionado = ubicacion['id'];
          });
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF58220),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/Logo.png'),
          ),
        ),
        title: const Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _posicionCamara,
            markers: _crearMarcadores(),
            onTap: (_) => setState(() => _localSeleccionado = null),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _localSeleccionado != null ? 0 : -400,
            left: 0,
            right: 0,
            child: _buildNegocioDetalle(),
          )
        ],
      ),
    );
  }

  Widget _buildNegocioDetalle() {
    if (_localSeleccionado == null) return const SizedBox();

    final local = _datosNegocio.firstWhere(
      (l) => l['id'] == _localSeleccionado,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local['nombre'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _localSeleccionado = null),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.location_on, local['direccion'], color: const Color(0xFF991B1B)),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, local['horario']),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'LLAMAR',
                        Icons.phone,
                        const Color(0xFFFBC02D),
                        Colors.black,
                        () => _hacerLlamada(local['telefonos'][0]),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton(
                        'RUTA',
                        Icons.directions,
                        const Color(0xFF991B1B),
                        Colors.white,
                        _abrirMapaExterno
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color color = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color bgColor, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
