/// Modelo de Categoría
class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String? description;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sin nombre',
      icon: json['icon']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'description': description};
  }

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
