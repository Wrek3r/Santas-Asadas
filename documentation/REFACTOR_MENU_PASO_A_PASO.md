# Guía Práctica: Refactorizar Menu.dart - Paso a Paso

## Objetivo: Convertir Menu.dart de datos estáticos a API dinámico

---

## Paso 1: Importes Necesarios

En la parte superior de `lib/Menu.dart`, asegúrate de tener:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'models/ProductModel.dart';
import 'ApiService.dart';
import 'providers/CartProvider.dart';
import 'widgets/loading_widgets.dart';  // ← NUEVO
```

---

## Paso 2: Declara ApiService en la clase State

Reemplaza la inicialización actual con:

```dart
class _MenuState extends State<Menu> {
  late ApiService _apiService;  // ← NUEVO
  String _categoriaSeleccionada = 'Todos';
  
  @override
  void initState() {
    super.initState();
    _apiService = ApiService();  // ← NUEVO - Inicializa en initState
  }
```

---

## Paso 3: Reemplaza el método `build()` completo

### ANTES (actual):
```dart
@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(
      appBar: AppBar(...),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  if (_errorMessage != null) {
    return Scaffold(
      appBar: AppBar(...),
      body: Center(child: Text('Error: $_errorMessage')),
    );
  }

  // Grid de productos...
}
```

### DESPUÉS (nueva):
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFF97316),
      title: const Text('Menú'),
      elevation: 0,
      actions: [
        // Badge del carrito
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
    // ✅ NUEVO: FutureBuilder maneja loading, error, y success automáticamente
    body: FutureBuilder<List<ProductModel>>(
      future: _apiService.fetchProducts(),
      builder: (context, snapshot) {
        // ESTADO 1: CARGANDO
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: Center(
                  child: const Text('Cargando categorías...'),
                ),
              ),
              Expanded(
                child: ProductsSkeletonGrid(),  // ✅ Shimmer effect
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
                child: ErrorWidget(
                  message: 'Error al cargar productos:\n${snapshot.error}',
                  onRetry: () {
                    setState(() {
                      _apiService.clearCache();  // Limpia cache y reinicia
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
        final categorias = ['Todos', ...allProducts.map((p) => p.category).toSet()];

        return Column(
          children: [
            // ✅ FILTRO DE CATEGORÍAS
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
            // ✅ GRID DE PRODUCTOS
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
```

---

## Paso 4: Actualiza `_buildProductCard()`

Reemplaza o crea este método para mostrar productos:

```dart
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
        // Información
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
```

---

## Paso 5: Limpia métodos antiguos

Puedes eliminar o comentar:
- `_loadProducts()` (ya no es necesario)
- `_isLoading` (FutureBuilder lo maneja)
- `_errorMessage` (FutureBuilder lo maneja)

---

## Paso 6: Prueba con Mock Data Primero

Edita `ApiService.dart` temporalmente para usar mock:

```dart
// En Menu.dart
future: _apiService.fetchMockProducts(),  // Usa mock primero
```

Verifica que funcione todo con datos locales.

---

## Paso 7: Conecta a API Real

Una vez que todo funciona con mock:

```dart
// En Menu.dart
future: _apiService.fetchProducts(),  // Cambia a fetchProducts()
```

Asegúrate de haber configurado:
1. URL base en ApiService.dart
2. API_KEY en ApiService.dart

---

## Resultado Final

✅ Menu.dart ahora:
- Carga productos desde API (o mock)
- Muestra skeleton loading while loading
- Maneja errores elegantemente
- Permite reintentar en caso de error
- Filtra por categorías dinámicamente
- Usa cache automático

---

## Troubleshooting

### "Error: The name 'ProductsSkeletonGrid' is not defined"
→ Importa: `import 'widgets/loading_widgets.dart';`

### "Error: 'late' modifier not allowed"
→ Usa `late ApiService _apiService;` solo en variables de clase

### Los productos no cargan
→ Verifica URL y API_KEY en ApiService.dart
→ Prueba con `fetchMockProducts()` primero

### El cache no funciona
→ Limpia el cache con: `_apiService.clearCache();`

---

**¡Listo! Menu.dart ahora está conectado a la API con manejo profesional de errores y loading.**
