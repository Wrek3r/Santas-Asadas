class ProductModel {
  final String id;
  final String image;
  final String title;
  final double price;
  final String category;
  final String description;

  ProductModel({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
    };
  }
}
