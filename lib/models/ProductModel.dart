/// Modelo de Producto con validación robusta y serialización JSON
class ProductModel {
  final String id;
  final String image;
  final String title;
  final double price;
  final String category;
  final String description;
  final int? stock;
  final bool available;

  ProductModel({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    this.stock,
    this.available = true,
  }) : assert(price >= 0, 'El precio no puede ser negativo'),
       assert(id.isNotEmpty, 'El id es obligatorio'),
       assert(title.isNotEmpty, 'El título es obligatorio');

  /// Deserialización segura desde JSON con validación
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Validación de campos obligatorios
    if (json['id'] == null || json['id'].toString().isEmpty) {
      throw FormatException('Campo "id" es obligatorio en ProductModel');
    }
    if (json['price'] == null) {
      throw FormatException('Campo "price" es obligatorio en ProductModel');
    }
    if (json['title'] == null || json['title'].toString().isEmpty) {
      throw FormatException('Campo "title" es obligatorio en ProductModel');
    }

    return ProductModel(
      id: json['id'].toString(),
      image: json['image']?.toString() ?? 'assets/LandingFoto.jpg',
      title: json['title'].toString(),
      price: (json['price'] as num).toDouble(),
      category: json['category']?.toString() ?? 'Otros',
      description: json['description']?.toString() ?? 'Sin descripción',
      stock: json['stock'] as int?,
      available: json['available'] as bool? ?? true,
    );
  }

  /// Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'stock': stock,
      'available': available,
    };
  }

  /// Método auxiliar para debug
  @override
  String toString() => 'ProductModel(id: $id, title: $title, price: $price)';
}
