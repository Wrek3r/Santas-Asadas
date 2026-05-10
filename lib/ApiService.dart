import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/ProductModel.dart';
import 'models/OrderModel.dart';

class ApiService {
  static const String baseUrl =
      'https://your-api-endpoint.com'; // Cambiar por tu API real

  // GET productos
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // POST pedido
  Future<bool> submitOrder(OrderModel order) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al enviar pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método mock para desarrollo (usar si no hay API real)
  Future<List<ProductModel>> fetchMockProducts() async {
    // Simular delay
    await Future.delayed(Duration(seconds: 1));

    return [
      ProductModel(
        id: '1',
        image: 'assets/Paquetes/Paquete1.jpg',
        title: 'Paquete Individual',
        price: 105.0,
        category: 'Paquetes',
        description:
            '• 1/4 Carne Asada\n• 1 Pieza de Chorizo Corona\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '2',
        image: 'assets/Paquetes/Paquete2.jpg',
        title: 'Paquete 1',
        price: 180.0,
        category: 'Paquetes',
        description:
            '• 1/2 Carne Asada\n• 1 Pieza de Chorizo Corona\n• 1 Quesadilla\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '3',
        image: 'assets/Paquetes/Paquete3.jpg',
        title: 'Paquete 2',
        price: 210.0,
        category: 'Paquetes',
        description:
            '• 1/2 Kg de Tasajo\n• 1 Pieza de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '4',
        image: 'assets/LandingFoto.jpg',
        title: 'Paquete 3',
        price: 330.0,
        category: 'Paquetes',
        description:
            '• 3/4 Kg de Carne Asada\n• 2 Piezas de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '5',
        image: 'assets/Paquetes/paquetefamiliar.jpg',
        title: 'Paquete Familiar',
        price: 355.0,
        category: 'Paquetes',
        description:
            '• 1 Kg Arrachera muy al estilo de las Santas Asadas\n• 2 Piezas de Chorizo Corona\n• 2 Quesadillas\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '6',
        image: 'assets/LandingFoto.jpg',
        title: 'Kilo de Carne Asada',
        price: 285.0,
        category: 'Kilos',
        description:
            'Un kilo de nuestra tradicional carne asada al carbón.\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '7',
        image: 'assets/LandingFoto.jpg',
        title: 'Kilo de Arrachera',
        price: 285.0,
        category: 'Kilos',
        description:
            'Corte muy suave y de buen sabor, prácticamente libre de grasa.\n\nIncluye: Tortillas, Cebollitas, Chile toreado y Salsa.',
      ),
      ProductModel(
        id: '8',
        image: 'assets/Paquetes/papaasadanatural.jpg',
        title: 'Papa Rellena Natural',
        price: 75.0,
        category: 'Complementos',
        description:
            'El sabor de nuestras papas al carbón, el complemento perfecto para tu carnita asada.',
      ),
      ProductModel(
        id: '9',
        image: 'assets/Paquetes/papamixta.jpg',
        title: 'Papa Rellena Mixta',
        price: 85.0,
        category: 'Complementos',
        description:
            'Deliciosa papa asada con carne a elegir: Arrachera, Asada, Chorizo o Mixta.',
      ),
    ];
  }
}
