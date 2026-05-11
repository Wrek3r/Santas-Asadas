import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/ProductModel.dart';
import '../models/OrderModel.dart';

class CartProvider with ChangeNotifier {
  final List<OrderItem> _items = [];

  CartProvider() {
    _loadCart();
  }

  List<OrderItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Añade un producto al carrito
  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Si ya existe, aumenta la cantidad
      _items[existingIndex] = OrderItem(
        productId: product.id,
        productTitle: product.title,
        quantity: _items[existingIndex].quantity + quantity,
        unitPrice: product.price,
      );
    } else {
      // Si no existe, lo agrega
      _items.add(
        OrderItem(
          productId: product.id,
          productTitle: product.title,
          quantity: quantity,
          unitPrice: product.price,
        ),
      );
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        _items[index] = OrderItem(
          productId: _items[index].productId,
          productTitle: _items[index].productTitle,
          quantity: quantity,
          unitPrice: _items[index].unitPrice,
        );
        _saveCart();
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  // Persistencia con SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('cart_items', jsonList);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList('cart_items') ?? [];

    try {
      _items.clear();
      for (var itemJson in savedItems) {
        _items.add(OrderItem.fromJson(json.decode(itemJson)));
      }
      notifyListeners();
    } catch (e) {
      print('Error cargando carrito: $e');
    }
  }
}
