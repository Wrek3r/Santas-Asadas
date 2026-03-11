import 'package:flutter/material.dart';

class MenuItem {
  final String imagen;
  final String titulo;
  final String precio;
  final String categoria;
  final String descripcion;

  MenuItem({
    required this.imagen,
    required this.titulo,
    required this.precio,
    required this.categoria,
    required this.descripcion,
  });
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _categoriaSeleccionada = 'Todos';

  final List<MenuItem> _todosLosItems = [
    // --- SECCIÓN PAQUETES ---
    MenuItem(
      imagen: 'assets/Paquete1.jpg',
      titulo: "Paquete Individual",
      precio: "105",
      categoria: "Paquetes",
      descripcion: "• 1/4 Carne Asada\n• 1 Pieza de Chorizo Corona\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/Paquete2.jpg',
      titulo: "Paquete 1",
      precio: "180",
      categoria: "Paquetes",
      descripcion: "• 1/2 Carne Asada\n• 1 Pieza de Chorizo Corona\n• 1 Quesadilla\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/Paquete2.jpg', // Usando assets disponibles
      titulo: "Paquete 2",
      precio: "210",
      categoria: "Paquetes",
      descripcion: "• 1/2 Kg de Tasajo\n• 1 Pieza de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/LandingFoto.jpg',
      titulo: "Paquete 3",
      precio: "330",
      categoria: "Paquetes",
      descripcion: "• 3/4 Kg de Carne Asada\n• 2 Piezas de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/Paquete1.jpg',
      titulo: "Paquete Familiar",
      precio: "355",
      categoria: "Paquetes",
      descripcion: "• 1 Kg Arrachera muy al estilo de las Santas Asadas\n• 2 Piezas de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),

    // --- SECCIÓN A COMER ---
    MenuItem(
      imagen: 'assets/LandingFoto.jpg',
      titulo: "Kilo de Carne Asada",
      precio: "285",
      categoria: "Cortes",
      descripcion: "Un kilo de nuestra tradicional carne asada al carbón.\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/LandingFoto.jpg',
      titulo: "Kilo de Arrachera",
      precio: "285",
      categoria: "Cortes",
      descripcion: "Corte muy suave y de buen sabor, prácticamente libre de grasa.\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.",
    ),
    MenuItem(
      imagen: 'assets/Paquete2.jpg',
      titulo: "Papa Rellena Natural",
      precio: "75",
      categoria: "Complementos",
      descripcion: "El sabor de nuestras papas al carbón, el complemento perfecto para tu carnita asada.",
    ),
    MenuItem(
      imagen: 'assets/Paquete1.jpg',
      titulo: "Papa Rellena Mixta",
      precio: "85",
      categoria: "Complementos",
      descripcion: "Deliciosa papa asada con carne a elegir: Arrachera, Asada, Chorizo o Mixta.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<MenuItem> itemsFiltrados = _categoriaSeleccionada == 'Todos'
        ? _todosLosItems
        : _todosLosItems.where((item) => item.categoria == _categoriaSeleccionada).toList();

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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Categoria('Todos'),
                  Categoria('Paquetes'),
                  Categoria('Cortes'),
                  Categoria('Complementos'),
                ],
              ),
            ),
          ),
          Expanded(
            child: itemsFiltrados.isEmpty
                ? const Center(child: Text("No hay platillos en esta categoría"))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: itemsFiltrados.length,
                    itemBuilder: (context, index) {
                      return TarjetaPaquete(item: itemsFiltrados[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget Categoria(String titulo) {
    bool seleccionado = _categoriaSeleccionada == titulo;
    return GestureDetector(
      onTap: () {
        setState(() {
          _categoriaSeleccionada = titulo;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFF991B1B) : const Color(0xFFFBC02D),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Text(
          titulo,
          style: TextStyle(
            color: seleccionado ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget TarjetaPaquete({required MenuItem item}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
              ),
              child: Image.asset(
                item.imagen,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.restaurant)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 80, color: Colors.grey[300]),
                Text(
                  '${item.titulo}\n\$${item.precio}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _mostrarDetalle(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBC02D),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: const Text(
                      'Ver',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

  void _mostrarDetalle(MenuItem item) {
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
            item.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.restaurant, size: 50),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Precio: \$${item.precio}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                item.descripcion,
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
