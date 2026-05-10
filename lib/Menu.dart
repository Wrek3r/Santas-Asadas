import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'models/ProductModel.dart';
import 'ApiService.dart';
import 'providers/CartProvider.dart';

class Menu extends StatefulWidget {
  Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _categoriaSeleccionada = 'Todos';
  List<ProductModel> _todosLosItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final apiService = ApiService();
      final products = await apiService
          .fetchMockProducts(); // Cambiar a fetchProducts() cuando tengas API real
      setState(() {
        _todosLosItems = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFF97316), title: Text('Menú')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFF97316), title: Text('Menú')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error al cargar productos: $_errorMessage'),
              ElevatedButton(
                onPressed: _loadProducts,
                child: Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    List<ProductModel> itemsFiltrados = _categoriaSeleccionada == 'Todos'
        ? _todosLosItems
        : _todosLosItems
              .where((item) => item.category == _categoriaSeleccionada)
              .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: BoxDecoration(
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
          Consumer<CartProvider>(
            builder: (context, cart, child) => Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: badges.Badge(
                badgeContent: Text(
                  '${cart.itemCount}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Color(0xFF991B1B)),
                showBadge: cart.itemCount > 0,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                    ); // Asumiendo que hay rutas
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Categoria('Todos'),
                  Categoria('Paquetes'),
                  Categoria('Kilos'),
                  Categoria('Complementos'),
                ],
              ),
            ),
          ),
          Expanded(
            child: itemsFiltrados.isEmpty
                ? Center(child: Text("No hay platillos en esta categoría"))
                : GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: seleccionado ? Color(0xFF991B1B) : Color(0xFFFBC02D),
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

  Widget TarjetaPaquete({required ProductModel item}) {
    final cart = Provider.of<CartProvider>(context);
    int quantity = cart.getQuantity(item.id);

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
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.restaurant)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.title}\n\$${item.price}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                if (quantity == 0) ...[
                  GestureDetector(
                    onTap: () => cart.addItem(item, 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFBC02D),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () =>
                            cart.updateQuantity(item.id, quantity - 1),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => cart.addItem(item, 1),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _mostrarDetalle(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFF991B1B),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Text(
                      'Ver Detalles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
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

  void _mostrarDetalle(ProductModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF58220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          title: Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.restaurant, size: 50),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Precio: \$${item.price}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(item.description, style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
