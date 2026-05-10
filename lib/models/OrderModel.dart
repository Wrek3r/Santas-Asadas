import 'ProductModel.dart';

class OrderItem {
  final ProductModel product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'title': product.title,
      'quantity': quantity,
      'unitPrice': product.price,
      'total': total,
    };
  }
}

class OrderModel {
  final List<OrderItem> items;
  final double total;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String notes;

  OrderModel({
    required this.items,
    required this.total,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItem(
                  product: ProductModel.fromJson(item['product']),
                  quantity: item['quantity'] ?? 1,
                ),
              )
              .toList() ??
          [],
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }
}
