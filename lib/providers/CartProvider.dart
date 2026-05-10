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
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  void addItem(ProductModel product, int quantity) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = OrderItem(
        product: product,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(OrderItem(product: product, quantity: quantity));
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        _items[index] = OrderItem(
          product: _items[index].product,
          quantity: quantity,
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

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => OrderItem(
        product: ProductModel(
          id: '',
          image: '',
          title: '',
          price: 0,
          category: '',
          description: '',
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _items.map((item) => item.toJson()).toList();
    await prefs.setString('cart', json.encode(cartJson));
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');
    if (cartString != null) {
      final cartJson = json.decode(cartString) as List<dynamic>;
      _items.clear();
      _items.addAll(
        cartJson.map(
          (item) => OrderItem(
            product: ProductModel.fromJson(item['product']),
            quantity: item['quantity'],
          ),
        ),
      );
      notifyListeners();
    }
  }
}
