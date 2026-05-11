# 🚀 Sprint 2: Quick Start - Checklist de Inicio

## ⚡ Hazlo Funcionar en 5 Minutos

### ✓ Paso 1: Verifica que todo está en su lugar (1 min)

```
lib/
├── models/
│   ├── ProductModel.dart ✓
│   ├── UserModel.dart ✓
│   ├── OrderModel.dart ✓
│   ├── CategoryModel.dart ✓
│   └── PromoModel.dart ✓
├── services/
│   ├── base_api_service.dart ✓
│   └── cache_service.dart ✓
├── widgets/
│   └── loading_widgets.dart ✓
├── ApiService.dart ✓
└── [otros archivos]

documentation/
├── SPRINT2_SEGURIDAD.md ✓
├── MENU_INTEGRATION_EXAMPLE.md ✓
├── SPRINT2_COMPLETADO.md ✓
├── REFACTOR_MENU_PASO_A_PASO.md ✓
└── ARQUITECTURA_DIAGRAMA.md ✓
```

---

### ✓ Paso 2: Configura la URL y API_KEY (1 min)

Abre: `lib/ApiService.dart`

Localiza:
```dart
class ApiService extends BaseApiService {
  static const String _baseUrl = 'https://your-api-endpoint.com/api';
  static const String _apiKey = 'tu_api_key_aqui';
```

Reemplaza con tus valores:
```dart
  static const String _baseUrl = 'https://tu-servidor.com/api';
  static const String _apiKey = 'tu_clave_real_123456';
```

---

### ✓ Paso 3: Prueba con Mock Data (1 min)

En `lib/Menu.dart`, cambia:

```dart
// De esto:
future: _apiService.fetchProducts(),

// A esto (temporalmente):
future: _apiService.fetchMockProducts(),
```

Ejecuta:
```bash
flutter pub get
flutter run
```

Verifica que:
- ✅ Aparece el Shimmer loading
- ✅ Se cargan los productos mock
- ✅ Puedes cambiar de categoría
- ✅ Botón "Reintentar" funciona en error

---

### ✓ Paso 4: Conecta a API Real (2 min)

Una vez que todo funcione con mock:

1. Vuelve a cambiar en `lib/Menu.dart`:
```dart
future: _apiService.fetchProducts(),  // API real
```

2. Verifica que tu servidor devuelva JSON en este formato:
```json
[
  {
    "id": "1",
    "title": "Paquete Individual",
    "price": 105.00,
    "category": "Paquetes",
    "image": "url o path",
    "description": "...",
    "stock": 50,
    "available": true
  },
  ...
]
```

3. Ejecuta y verifica:
```bash
flutter run
```

---

## 📋 Siguiente: Refactoriza Menu.dart Completamente

Sigue la **guía paso a paso** en: `documentation/REFACTOR_MENU_PASO_A_PASO.md`

Tiempo estimado: 15 minutos

---

## 🎯 Próximos Endpoints (Esta Semana)

### Integra Promos.dart
```dart
FutureBuilder<List<PromoModel>>(
  future: _apiService.fetchPromos(),
  // ... similar a Menu.dart
)
```

### Integra Login.dart (Registro)
```dart
Future<void> registerUser() async {
  final user = UserModel(
    nombre: nameController.text,
    email: emailController.text,
    telefono: phoneController.text,
  );
  
  try {
    final registered = await _apiService.registerUser(user);
    Navigator.pop(context);
  } on ApiException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  }
}
```

### Integra Checkout (Enviar Pedido)
```dart
Future<void> submitOrder() async {
  final order = OrderModel(
    items: cartItems,
    clienteNombre: nameController.text,
    clienteTelefono: phoneController.text,
    direccionEntrega: addressController.text,
  );
  
  try {
    final submittedOrder = await _apiService.submitOrder(order);
    print('Pedido #${submittedOrder.id} creado exitosamente');
  } on ApiException catch (e) {
    showErrorDialog(e.message);
  }
}
```

---

## 🔐 Seguridad: Checklist Antes de Producción

- [ ] NO comittees API_KEY en Git (agregar a .gitignore)
- [ ] Usa HTTPS en producción (no HTTP)
- [ ] Implementa timeout en requests
- [ ] Valida TODAS las respuestas JSON
- [ ] Encripta datos sensibles en SharedPreferences
- [ ] Implementa refresh tokens para sesiones
- [ ] Loguea errores (pero NO datos sensibles)
- [ ] Prueba comportamiento offline

---

## 🐛 Troubleshooting Rápido

### Problema: "ApiException: No autorizado"
**Solución:**
- [ ] Verifica que `_apiKey` sea correcto
- [ ] Verifica que el servidor espera header `Authorization: Bearer <KEY>`
- [ ] Prueba con una herramienta como Postman

### Problema: "Error al parsear producto"
**Solución:**
- [ ] Verifica que el JSON tiene todos los campos obligatorios:
  - `id` (string)
  - `title` (string)
  - `price` (number)
- [ ] Si faltan campos, el modelo usará valores por defecto

### Problema: Productos no cargan
**Solución:**
- [ ] [ ] Verifica URL en ApiService.dart
- [ ] [ ] Prueba con fetchMockProducts() primero
- [ ] [ ] Revisa la consola para errores
- [ ] [ ] Desconecta internet y prueba error handling

### Problema: Cache no funciona
**Solución:**
- [ ] Llama `clearCache()` para limpiar manualmente
- [ ] El cache expira cada 15 minutos
- [ ] Modifica duración en CacheService.dart si lo necesitas

---

## 📱 Testing en Diferentes Escenarios

### Test 1: Sin Internet
```dart
// Desconecta WiFi/datos
flutter run
// Debe mostrar ErrorWidget con botón de reintento
```

### Test 2: Servidor Lento
```dart
// Espera 5+ segundos
// Debe mostrar Shimmer loading
```

### Test 3: Servidor Devuelve Error 500
```dart
// Configura tu servidor para devolver 500
// Debe mostrar ErrorWidget amigable
```

### Test 4: Cache Funciona
```dart
// Carga menú
// Aparece normalmente
// Vuelve al menú (sin recargar)
// Debe aparecer instantáneamente (desde cache)
```

---

## 📚 Documentación de Referencia

| Doc | Contenido |
|-----|-----------|
| [SPRINT2_SEGURIDAD.md](./SPRINT2_SEGURIDAD.md) | Seguridad, API_KEY, validación |
| [REFACTOR_MENU_PASO_A_PASO.md](./REFACTOR_MENU_PASO_A_PASO.md) | Cómo actualizar Menu.dart |
| [MENU_INTEGRATION_EXAMPLE.md](./MENU_INTEGRATION_EXAMPLE.md) | Código completo de ejemplo |
| [ARQUITECTURA_DIAGRAMA.md](./ARQUITECTURA_DIAGRAMA.md) | Flujos y diagramas |
| [SPRINT2_COMPLETADO.md](./SPRINT2_COMPLETADO.md) | Resumen completo |

---

## ✅ Cuándo Has Terminado Sprint 2

Verifica que:

- ✅ Menu.dart usa FutureBuilder con API
- ✅ Shimmer loading funciona
- ✅ Error handling muestra mensajes amigables
- ✅ Categorías se cargan dinámicamente
- ✅ Cache es instantáneo en segunda carga
- ✅ Botón "Reintentar" funciona
- ✅ CartProvider agrega productos
- ✅ Promos.dart está refactorizado
- ✅ Login.dart integra registerUser()
- ✅ Checkout integra submitOrder()

---

## 🎉 ¡Listo!

Sprint 2 está completado y funcionando. 

**Próximo paso:** Sprint 3 - Autenticación JWT y Persistencia Local

---

**Tiempo Total Estimado: 1-2 horas**
**Complejidad: Media**
**Impacto: Alto (transforma app de estática a dinámica)**
