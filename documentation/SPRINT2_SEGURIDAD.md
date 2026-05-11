## Sprint 2: Guía de Seguridad y Configuración

### 1. Manejo de API_KEY (Seguridad)

#### Problema:
No guardes la API_KEY directamente en el código fuente. Es un riesgo de seguridad.

#### Solución Recomendada:

##### Opción A: Variables de Entorno (Recomendado)
```dart
// lib/config/api_config.dart
import 'dart:io';

class ApiConfig {
  // Lee desde variables de entorno
  static String get apiBaseUrl {
    return Platform.environment['SANTAS_API_URL'] ?? 
           'https://api.santasasadas.com/api';
  }

  static String get apiKey {
    return Platform.environment['SANTAS_API_KEY'] ?? '';
  }

  // En desarrollo, usa valores locales
  static const String apiKeyDev = 'dev_key_123456';
  static const String baseUrlDev = 'http://localhost:3000/api';

  static bool get isDevelopment => !const bool.fromEnvironment('dart.vm.product');
}

// Uso:
// export SANTAS_API_URL=https://api.santasasadas.com/api
// export SANTAS_API_KEY=your_production_key_here
// flutter run
```

##### Opción B: Archivo de Configuración (NO committear a git)
```dart
// lib/config/api_config.dart (gitignore: api_config.local.dart)
class ApiConfig {
  static const String apiKey = 'tu_api_key_real_aqui';
  static const String baseUrl = 'https://tu-servidor.com/api';
}

// .gitignore
api_config.local.dart
```

##### Opción C: Backend Token (Lo más Seguro)
```dart
// El cliente NO almacena API_KEY, solo obtiene un token del backend
class ApiService extends BaseApiService {
  String? _authToken;

  // 1. Login: obtén token
  Future<String> login(String usuario, String password) async {
    final response = await post('/auth/login', body: {
      'usuario': usuario,
      'password': password,
    });
    _authToken = response['token'];
    return _authToken!;
  }

  @override
  Map<String, String> get commonHeaders {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }
}
```

---

### 2. Headers de Seguridad

Todos los requests incluyen estos headers automáticamente:

```dart
Map<String, String> get commonHeaders {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'santas-asadas-mobile/1.0',
    if (apiKey != null) 'Authorization': 'Bearer $apiKey',
    // Agregar más según necesidad:
    // 'X-API-Version': '1.0',
    // 'X-Device-ID': deviceId,
  };
}
```

---

### 3. Validación de JSON

Todos los modelos validan campos obligatorios:

```dart
// ✅ BIEN - Valida campos obligatorios
factory ProductModel.fromJson(Map<String, dynamic> json) {
  if (json['id'] == null || json['id'].toString().isEmpty) {
    throw FormatException('Campo "id" es obligatorio');
  }
  if (json['price'] == null) {
    throw FormatException('Campo "price" es obligatorio');
  }
  // ... resto del constructor
}

// ❌ MAL - Sin validación, puede crashear
factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] ?? '', // ¿Qué pasa si falta?
    price: json['price'] ?? 0.0, // Asume 0, puede ser incorrecto
  );
}
```

---

### 4. Manejo de Errores

```dart
try {
  final products = await apiService.fetchProducts();
} on ApiException catch (e) {
  if (e.statusCode == 401) {
    // No autorizado - vuelve al login
    Navigator.of(context).pushReplacementNamed('/login');
  } else if (e.statusCode == 500) {
    // Error del servidor
    showErrorSnackbar('El servidor está teniendo problemas. Intenta más tarde.');
  } else {
    // Error genérico
    showErrorSnackbar(e.message);
  }
} catch (e) {
  showErrorSnackbar('Error inesperado: $e');
}
```

---

### 5. Cache Simple

El cache se limpia automáticamente después de 15 minutos:

```dart
// Obtiene del cache si existe
final products = await apiService.fetchProducts(); // Del cache si disponible

// Fuerza actualización desde API
final products = await apiService.fetchProducts(forceRefresh: true);

// Limpia el cache manualmente
apiService.clearCache();
```

---

### 6. Estructura de Carpetas (Organización)

```
lib/
├── models/                 # Modelos de datos
│   ├── ProductModel.dart
│   ├── UserModel.dart
│   ├── OrderModel.dart
│   ├── CategoryModel.dart
│   └── PromoModel.dart
│
├── services/               # Capa de servicios
│   ├── base_api_service.dart    # Clase abstracta
│   └── cache_service.dart       # Cache simple
│
├── widgets/                # Widgets reutilizables
│   └── loading_widgets.dart     # Shimmer, skeletons, error
│
├── providers/              # State management (Provider)
│   └── CartProvider.dart
│
├── config/                 # Configuración
│   └── api_config.dart
│
├── ApiService.dart         # Implementación concreta (puede mover a services/)
├── main.dart
├── Menu.dart
├── Promos.dart
└── ...otros archivos
```

---

### 7. Ejemplo: Integración en UI (Menu.dart)

Ver `MENU_INTEGRATION_EXAMPLE.md` para el código completo de Menu.dart refactorizado.

---

### 8. Testing

```dart
// test/api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:santas_asadas/ApiService.dart';
import 'package:santas_asadas/models/ProductModel.dart';

void main() {
  late ApiService apiService;

  setUp(() {
    apiService = ApiService();
  });

  test('fetchProducts devuelve lista de productos', () async {
    final products = await apiService.fetchMockProducts();
    expect(products, isNotEmpty);
    expect(products.first, isA<ProductModel>());
  });

  test('ProductModel valida precio positivo', () {
    expect(
      () => ProductModel(
        id: '1',
        title: 'Test',
        price: -10, // ❌ Negativo
        image: 'test.jpg',
        category: 'Test',
        description: 'Test',
      ),
      throwsAssertionError,
    );
  });
}
```

---

### 9. Checklist de Seguridad

- [ ] No committe API_KEY en git (usa .gitignore)
- [ ] Usa HTTPS siempre en producción
- [ ] Valida todas las respuestas JSON
- [ ] Maneja excepciones correctamente
- [ ] Implementa timeout en requests (recomendado 30s)
- [ ] Usa refresh tokens para sesiones largas
- [ ] Encripta datos sensibles en SharedPreferences
- [ ] Implementa rate limiting en cliente
- [ ] Loguea errores pero no datos sensibles

---

### 10. Paso Siguiente: Integración en Menu.dart

Continúa con la refactorización del Menu.dart para usar FutureBuilder con loading y error states.
