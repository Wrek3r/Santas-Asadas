import 'package:santas_asadas/services/base_api_service.dart';
import 'package:santas_asadas/services/cache_service.dart';
import 'models/ProductModel.dart';
import 'models/PromoModel.dart';
import 'models/UserModel.dart';
import 'models/OrderModel.dart';

/// Implementación concreta del servicio de API para Santas Asadas
class ApiService extends BaseApiService {
  static const String _baseUrl =
      'https://your-api-endpoint.com/api'; // Cambiar por tu URL real
  static const String _apiKey =
      'tu_api_key_aqui'; // Cambiar por tu API key real

  final CacheService _cacheService = CacheService();

  // Claves de cache
  static const String _cacheKeyProducts = 'products_menu';
  static const String _cacheKeyPromos = 'promos';

  @override
  String get baseUrl => _baseUrl;

  @override
  String? get apiKey => _apiKey;

  /// ============ PRODUCTOS/MENÚ ============

  /// Obtiene la lista de productos con cache y fallback automático a mock
  Future<List<ProductModel>> fetchProducts({bool forceRefresh = false}) async {
    try {
      // Si no fuerza refresh, intenta obtener del cache
      if (!forceRefresh && _cacheService.has(_cacheKeyProducts)) {
        final cached = _cacheService.get<List<ProductModel>>(_cacheKeyProducts);
        if (cached != null) {
          print('[ApiService] Productos obtenidos del cache');
          return cached;
        }
      }

      // Realiza la petición GET
      final response = await get('/productos');

      // Valida que la respuesta sea una lista
      if (response is! List) {
        throw ApiException(
          message: 'Respuesta de productos inválida: se esperaba una lista',
        );
      }

      // Convierte a modelos
      final products = (response as List)
          .map((json) {
            try {
              return ProductModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              print('[ApiService] Error al parsear producto: $e');
              return null;
            }
          })
          .whereType<ProductModel>()
          .toList();

      // Guarda en cache
      _cacheService.set(_cacheKeyProducts, products);

      print('[ApiService] ${products.length} productos obtenidos de la API');
      return products;
    } on ApiException catch (e) {
      print('[ApiService] Error en API real: ${e.message}');
      print('[ApiService] Usando datos mock como fallback');
      // Fallback automático a datos mock
      return await fetchMockProducts();
    } catch (e) {
      print('[ApiService] Error desconocido: $e');
      print('[ApiService] Usando datos mock como fallback');
      // Fallback automático a datos mock
      return await fetchMockProducts();
    }
  }

  /// Obtiene un producto específico por ID
  Future<ProductModel> fetchProductById(String productId) async {
    try {
      final response = await get('/productos/$productId');

      if (response is! Map) {
        throw ApiException(message: 'Respuesta de producto inválida');
      }

      return ProductModel.fromJson(response as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al obtener producto: $e');
    }
  }

  /// ============ PROMOCIONES ============

  /// Obtiene la lista de promociones activas
  Future<List<PromoModel>> fetchPromos({bool forceRefresh = false}) async {
    try {
      // Intenta obtener del cache
      if (!forceRefresh && _cacheService.has(_cacheKeyPromos)) {
        final cached = _cacheService.get<List<PromoModel>>(_cacheKeyPromos);
        if (cached != null) {
          print('[ApiService] Promociones obtenidas del cache');
          return cached;
        }
      }

      // Realiza la petición GET
      final response = await get('/promociones');

      if (response is! List) {
        throw ApiException(
          message: 'Respuesta de promociones inválida: se esperaba una lista',
        );
      }

      // Convierte a modelos
      final promos = (response as List)
          .map((json) {
            try {
              return PromoModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              print('[ApiService] Error al parsear promoción: $e');
              return null;
            }
          })
          .whereType<PromoModel>()
          .toList();

      // Guarda en cache
      _cacheService.set(_cacheKeyPromos, promos);

      print('[ApiService] ${promos.length} promociones obtenidas de la API');
      return promos;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al obtener promociones: $e');
    }
  }

  /// ============ CLIENTES ============

  /// Registra un nuevo cliente en la base de datos
  Future<UserModel> registerUser(UserModel user) async {
    try {
      final response = await post('/clientes', body: user.toJson());

      if (response is! Map) {
        throw ApiException(message: 'Respuesta de registro inválida');
      }

      return UserModel.fromJson(response as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al registrar cliente: $e');
    }
  }

  /// Obtiene la información de un cliente por ID
  Future<UserModel> getUser(String userId) async {
    try {
      final response = await get('/clientes/$userId');

      if (response is! Map) {
        throw ApiException(message: 'Respuesta de cliente inválida');
      }

      return UserModel.fromJson(response as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al obtener cliente: $e');
    }
  }

  /// ============ PEDIDOS ============

  /// Crea un nuevo pedido en el servidor
  Future<OrderModel> submitOrder(OrderModel order) async {
    try {
      // Valida que el pedido tenga artículos
      if (order.items.isEmpty) {
        throw ApiException(
          message: 'El pedido debe contener al menos un artículo',
        );
      }

      final response = await post('/pedidos', body: order.toJson());

      if (response is! Map) {
        throw ApiException(message: 'Respuesta de pedido inválida');
      }

      return OrderModel.fromJson(response as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al enviar pedido: $e');
    }
  }

  /// Obtiene la lista de pedidos de un cliente
  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final response = await get('/pedidos?clienteId=$userId');

      if (response is! List) {
        throw ApiException(
          message: 'Respuesta de pedidos inválida: se esperaba una lista',
        );
      }

      return (response as List)
          .map((json) {
            try {
              return OrderModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              print('[ApiService] Error al parsear pedido: $e');
              return null;
            }
          })
          .whereType<OrderModel>()
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al obtener pedidos: $e');
    }
  }

  /// Obtiene un pedido específico
  Future<OrderModel> fetchOrder(String orderId) async {
    try {
      final response = await get('/pedidos/$orderId');

      if (response is! Map) {
        throw ApiException(message: 'Respuesta de pedido inválida');
      }

      return OrderModel.fromJson(response as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error al obtener pedido: $e');
    }
  }

  /// ============ UTILIDADES ============

  /// Limpia el cache
  void clearCache() {
    _cacheService.clear();
    print('[ApiService] Cache limpiado');
  }

  /// Método mock para desarrollo (usar si no hay API real)
  Future<List<ProductModel>> fetchMockProducts() async {
    // Simular delay
    await Future.delayed(const Duration(seconds: 1));

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
