/// Modelo de Usuario con validación profesional
class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final String? direccion;
  final String? notas;
  final DateTime? fechaRegistro;
  final bool activo;

  UserModel({
    required this.nombre,
    required this.telefono,
    this.id = '',
    this.email = '',
    this.direccion,
    this.notas,
    this.fechaRegistro,
    this.activo = true,
  }) : assert(nombre.isNotEmpty, 'El nombre es obligatorio'),
       assert(telefono.isNotEmpty, 'El teléfono es obligatorio');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? json['phone']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? json['address']?.toString(),
      notas: json['notas']?.toString() ?? json['notes']?.toString(),
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'].toString())
          : null,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'notas': notas,
      'fechaRegistro': fechaRegistro?.toIso8601String(),
      'activo': activo,
    };
  }

  @override
  String toString() =>
      'UserModel(id: $id, nombre: $nombre, telefono: $telefono, email: $email)';
}
