import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'models/ProductModel.dart';
import 'ApiService.dart';
import 'Login.dart';
import 'providers/CartProvider.dart';
import 'widgets/loading_widgets.dart';

class Menu extends StatefulWidget {
  Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late ApiService _apiService;
  String _categoriaSeleccionada = 'Todos';
  final Map<String, int> _selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  int _getQuantity(String productId) => _selectedQuantities[productId] ?? 1;

  void _changeQuantity(String productId, int delta) {
    final current = _getQuantity(productId);
    final next = (current + delta).clamp(1, 20);
    setState(() {
      _selectedQuantities[productId] = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF97316), Color(0xFFFF6B00)],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Image.asset('assets/Logo.png', height: 48, errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, size: 32, color: Color(0xFFF97316))),
                      ),
                      const SizedBox(height: 10),
                      const Text('Santas Asadas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(leading: const Icon(Icons.home_outlined, color: Colors.black54), title: const Text('Inicio'), onTap: () => Navigator.pushReplacementNamed(context, '/inicio')),
            ListTile(leading: const Icon(Icons.restaurant_menu_outlined, color: Colors.orangeAccent), title: const Text('Menú', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.local_offer_outlined, color: Colors.black54), title: const Text('Promos'), onTap: () => Navigator.pushReplacementNamed(context, '/promos')),
            ListTile(leading: const Icon(Icons.location_on_outlined, color: Colors.black54), title: const Text('Local'), onTap: () => Navigator.pushReplacementNamed(context, '/local')),
            ListTile(leading: const Icon(Icons.shopping_cart_outlined, color: Colors.black54), title: const Text('Carrito'), onTap: () => Navigator.pushNamed(context, '/chat')),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4), child: Divider()),
            ListTile(leading: const Icon(Icons.logout, color: Colors.black54), title: const Text('Cerrar sesión'), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()))),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Menú'),
        actions: [
          // Carrito (usando Provider)
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: badges.Badge(
                  badgeContent: Text(
                    cart.items.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // ✅ FutureBuilder: maneja async data elegantemente
      body: FutureBuilder<List<ProductModel>>(
        future: _apiService.fetchProducts(),
        builder: (context, snapshot) {
          // ESTADO 1: CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Center(child: const Text('Cargando categorías...')),
                ),
                Expanded(
                  child: ProductsSkeletonGrid(), // ✅ Shimmer effect
                ),
              ],
            );
          }

          // ESTADO 2: ERROR
          if (snapshot.hasError) {
            return Column(
              children: [
                SizedBox(height: 50),
                Expanded(
                  child: CustomErrorWidget(
                    message: 'Error al cargar productos:\n${snapshot.error}',
                    onRetry: () {
                      setState(() {
                        _apiService.clearCache(); // Limpia cache y reinicia
                      });
                    },
                  ),
                ),
              ],
            );
          }

          // ESTADO 3: ÉXITO
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No hay productos disponibles'),
                ],
              ),
            );
          }

          final allProducts = snapshot.data!;

          // Filtra por categoría seleccionada
          final productosFiltrados = _categoriaSeleccionada == 'Todos'
              ? allProducts
              : allProducts
                    .where((p) => p.category == _categoriaSeleccionada)
                    .toList();

          // Obtiene categorías únicas
          final categorias = [
            'Todos',
            ...allProducts.map((p) => p.category).toSet(),
          ];

          return Column(
            children: [
              // FILTRO DE CATEGORÍAS
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    final isSelected = _categoriaSeleccionada == categoria;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(
                          categoria,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _categoriaSeleccionada = categoria;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFF97316),
                        showCheckmark: false,
                        elevation: isSelected ? 2 : 0,
                        shadowColor: Colors.black26,
                      ),
                    );
                  },
                ),
              ),
              // GRID DE PRODUCTOS
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: productosFiltrados.length,
                  itemBuilder: (context, index) {
                    final producto = productosFiltrados[index];
                    return _buildProductCard(producto);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel producto) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con badge de categoría superpuesto
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  producto.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: Center(child: Icon(Icons.restaurant, color: Colors.grey[400], size: 36)),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      producto.category,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info del producto
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87, height: 1.3),
                  ),
                  const SizedBox(height: 4),
                  // Precio en dark para máximo contraste
                  Text(
                    '\$${producto.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _qtyButton(Icons.remove, () => _changeQuantity(producto.id, -1)),
                      Text(
                        '${_getQuantity(producto.id)}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87),
                      ),
                      _qtyButton(Icons.add, () => _changeQuantity(producto.id, 1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {
                        final cantidad = _getQuantity(producto.id);
                        context.read<CartProvider>().addItem(producto, quantity: cantidad);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${producto.title} añadido ($cantidad)'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      child: const Text('Agregar al carrito'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton.filledTonal(
        padding: EdgeInsets.zero,
        iconSize: 16,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFF5F5F5),
          foregroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
