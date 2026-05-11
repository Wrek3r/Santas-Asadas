/// Modelo de Promoción/Descuento
class PromoModel {
  final String id;
  final String titulo;
  final String descripcion;
  final double descuento; // Porcentaje o monto
  final String tipo; // 'porcentaje' o 'monto'
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String? imagenUrl;
  final bool activa;
  final List<String>? productosAplicables; // IDs de productos

  PromoModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.descuento,
    required this.tipo,
    required this.fechaInicio,
    required this.fechaFin,
    this.imagenUrl,
    this.activa = true,
    this.productosAplicables,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? 'Promoción',
      descripcion: json['descripcion']?.toString() ?? '',
      descuento: (json['descuento'] as num?)?.toDouble() ?? 0.0,
      tipo: json['tipo']?.toString() ?? 'porcentaje',
      fechaInicio: DateTime.parse(
        json['fechaInicio']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      fechaFin: DateTime.parse(
        json['fechaFin']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      imagenUrl: json['imagenUrl']?.toString(),
      activa: json['activa'] as bool? ?? true,
      productosAplicables: (json['productosAplicables'] as List?)
          ?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'descuento': descuento,
      'tipo': tipo,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'imagenUrl': imagenUrl,
      'activa': activa,
      'productosAplicables': productosAplicables,
    };
  }

  bool get esValida {
    final ahora = DateTime.now();
    return activa && ahora.isAfter(fechaInicio) && ahora.isBefore(fechaFin);
  }

  @override
  String toString() => 'PromoModel(id: $id, titulo: $titulo)';
}
