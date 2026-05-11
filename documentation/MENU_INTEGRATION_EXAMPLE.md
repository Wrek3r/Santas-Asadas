// Esto es una GUÍA de refactorización. Cópialo gradualmente en tu Menu.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'models/ProductModel.dart';
import 'ApiService.dart';
import 'providers/CartProvider.dart';
import 'widgets/loading_widgets.dart';

class MenuRefactorizado extends StatefulWidget {
  const MenuRefactorizado({super.key});

  @override
  State<MenuRefactorizado> createState() => _MenuRefactorizadoState();
}

class _MenuRefactorizadoState extends State<MenuRefactorizado> {
  late ApiService _apiService;
  String _categoriaSeleccionada = 'Todos';
  List<ProductModel> _allProducts = [];
  bool _isLoadingCategory = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97316),
        title: const Text('Menú'),
        elevation: 0,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Carrito: ${cart.items.length} items')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        // FutureBuilder: maneja async data elegantemente
        future: _apiService.fetchProducts(),
        builder: (context, snapshot) {
          // 1. Estado: CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: ProductsSkeletonGrid(),
                ),
              ],
            );
          }

          // 2. Estado: ERROR
          if (snapshot.hasError) {
            return Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: ErrorWidget(
                    message: 'Error al cargar productos:\n${snapshot.error}',
                    onRetry: () {
                      setState(() {
                        // Fuerza recarga desde API
                        _apiService.clearCache();
                      });
                    },
                  ),
                ),
              ],
            );
          }

          // 3. Estado: ÉXITO
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

          _allProducts = snapshot.data!;

          // Filtra por categoría
          final productosFiltrados = _categoriaSeleccionada == 'Todos'
              ? _allProducts
              : _allProducts
                  .where((p) => p.category == _categoriaSeleccionada)
                  .toList();

          // Obtiene categorías únicas
          final categorias = ['Todos', ..._allProducts.map((p) => p.category).toSet()];

          return Column(
            children: [
              // Filtro de categorías
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    final isSelected = _categoriaSeleccionada == categoria;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(categoria),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _categoriaSeleccionada = categoria;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFF58220),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Grid de productos
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
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

  /// Construye el widget de filtro de categorías
  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      color: Colors.grey[100],
      child: Center(
        child: const Text('Cargando categorías...'),
      ),
    );
  }

  /// Construye la tarjeta de producto
  Widget _buildProductCard(ProductModel producto) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Image.asset(
                producto.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                  );
                },
              ),
            ),
          ),
          // Información del producto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${producto.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF97316),
                  ),
                ),
                const SizedBox(height: 8),
                // Botón agregar al carrito
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartProvider>().addItem(producto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${producto.title} añadido al carrito'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF58220),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
}

/// ============ NOTA DE INTEGRACIÓN ============
/// 
/// En tu Menu.dart actual, reemplaza la función build() con este código.
/// Los cambios principales:
/// 
/// 1. ✅ FutureBuilder: Maneja automáticamente loading, error y success states
/// 2. ✅ ProductsSkeletonGrid: Shimmer effect mientras carga
/// 3. ✅ ErrorWidget: Mensaje amigable + botón de reintento
/// 4. ✅ Cache: Automático con _apiService.fetchProducts()
/// 5. ✅ Validación: ProductModel valida datos JSON
/// 6. ✅ Categorías: Filtra dinámicamente
///
/// Si quieres más refinamientos:
/// - Agregar animaciones al cambiar categoría
/// - Pull to refresh (RefreshIndicator)
/// - Buscar productos
/// - Detalles de producto en modal
