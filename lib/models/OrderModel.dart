import 'ProductModel.dart';

/// Modelo de un artículo dentro de un pedido
class OrderItem {
  final String productId;
  final String productTitle;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId']?.toString() ?? '',
      productTitle:
          json['productTitle']?.toString() ?? json['title']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 1,
      unitPrice:
          (json['unitPrice'] as num? ?? json['price'] as num?)?.toDouble() ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
    };
  }

  @override
  String toString() =>
      'OrderItem(productId: $productId, quantity: $quantity, unitPrice: $unitPrice)';
}

/// Enumeración para estados de pedido
enum OrderStatus {
  pendiente('Pendiente'),
  confirmado('Confirmado'),
  enviado('Enviado'),
  entregado('Entregado'),
  cancelado('Cancelado');

  final String label;
  const OrderStatus(this.label);
}

/// Modelo de Pedido completo con validación
class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double total;
  final String clienteNombre;
  final String clienteTelefono;
  final String direccionEntrega;
  final String? notas;
  final OrderStatus estado;
  final DateTime fechaCreacion;
  final DateTime? fechaEntrega;
  final String? metodoPago;
  final double? descuento;

  OrderModel({
    required this.items,
    required this.clienteNombre,
    required this.clienteTelefono,
    required this.direccionEntrega,
    this.id = '',
    this.notas,
    this.estado = OrderStatus.pendiente,
    DateTime? fechaCreacion,
    this.fechaEntrega,
    this.metodoPago,
    this.descuento,
    double? total,
  }) : assert(items.isNotEmpty, 'Un pedido debe tener al menos un artículo'),
       assert(clienteNombre.isNotEmpty, 'El nombre del cliente es obligatorio'),
       assert(
         clienteTelefono.isNotEmpty,
         'El teléfono del cliente es obligatorio',
       ),
       assert(direccionEntrega.isNotEmpty, 'La dirección es obligatoria'),
       fechaCreacion = fechaCreacion ?? DateTime.now(),
       total = total ?? items.fold(0, (sum, item) => sum + item.subtotal);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['items'] is List) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      items: orderItems,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      clienteNombre:
          json['clienteNombre']?.toString() ??
          json['customerName']?.toString() ??
          '',
      clienteTelefono:
          json['clienteTelefono']?.toString() ??
          json['customerPhone']?.toString() ??
          '',
      direccionEntrega:
          json['direccionEntrega']?.toString() ??
          json['deliveryAddress']?.toString() ??
          '',
      notas: json['notas']?.toString() ?? json['notes']?.toString(),
      estado: _parseOrderStatus(json['estado']?.toString() ?? 'pendiente'),
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'].toString())
          : DateTime.now(),
      fechaEntrega: json['fechaEntrega'] != null
          ? DateTime.parse(json['fechaEntrega'].toString())
          : null,
      metodoPago: json['metodoPago']?.toString(),
      descuento: (json['descuento'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'clienteNombre': clienteNombre,
      'clienteTelefono': clienteTelefono,
      'direccionEntrega': direccionEntrega,
      'notas': notas,
      'estado': estado.name,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaEntrega': fechaEntrega?.toIso8601String(),
      'metodoPago': metodoPago,
      'descuento': descuento,
    };
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get totalConDescuento {
    if (descuento == null) return total;
    return total - (total * (descuento! / 100));
  }

  @override
  String toString() =>
      'OrderModel(id: $id, items: ${items.length}, total: $total, estado: ${estado.label})';
}

/// Función auxiliar para parsear el estado del pedido
OrderStatus _parseOrderStatus(String status) {
  try {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => OrderStatus.pendiente,
    );
  } catch (_) {
    return OrderStatus.pendiente;
  }
}
