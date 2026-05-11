# Sprint 2: Arquitectura de Capas - Diagrama

## Arquitectura General

```
┌─────────────────────────────────────────────────────────────┐
│                        UI LAYER                              │
│  (Menu.dart, Promos.dart, Login.dart, Checkout.dart)         │
│                                                              │
│  Widgets:                                                    │
│  - FutureBuilder (manejo de async)                          │
│  - ShimmerLoading (animación de carga)                      │
│  - ProductsSkeletonGrid (esqueleto de carga)                │
│  - ErrorWidget (mensaje de error + reintento)              │
└──────────────────┬──────────────────────────────────────────┘
                   │ (Consumer/Provider)
┌──────────────────▼──────────────────────────────────────────┐
│                   STATE LAYER                                │
│  (Provider - CartProvider, UserProvider, etc.)              │
│                                                              │
│  Responsabilidades:                                         │
│  - Gestionar estado global                                  │
│  - Notificar cambios a widgets                             │
└──────────────────┬──────────────────────────────────────────┘
                   │ (ChangeNotifier)
┌──────────────────▼──────────────────────────────────────────┐
│                  SERVICES LAYER                              │
│  (ApiService, CacheService)                                 │
│                                                              │
│  ApiService:                                                │
│  ├── fetchProducts() → GET /productos                      │
│  ├── fetchPromos() → GET /promociones                       │
│  ├── registerUser() → POST /clientes                       │
│  ├── submitOrder() → POST /pedidos                         │
│  └── ...                                                    │
│                                                              │
│  CacheService:                                              │
│  ├── set(key, value) - Guarda en cache                     │
│  ├── get(key) - Lee del cache                              │
│  └── has(key) - Verifica existencia                        │
└──────────────────┬──────────────────────────────────────────┘
                   │ (HTTP Requests)
┌──────────────────▼──────────────────────────────────────────┐
│                 MODELS LAYER                                 │
│  (ProductModel, UserModel, OrderModel, PromoModel)          │
│                                                              │
│  Características:                                           │
│  ✓ Validación de JSON                                      │
│  ✓ fromJson() - Deserialización                            │
│  ✓ toJson() - Serialización                                │
│  ✓ Manejo de datos anidados                                │
└──────────────────┬──────────────────────────────────────────┘
                   │ (HTTP + Headers + Auth)
┌──────────────────▼──────────────────────────────────────────┐
│              BASE API SERVICE LAYER                          │
│  (BaseApiService - Clase Abstracta)                         │
│                                                              │
│  Métodos HTTP Abstractos:                                   │
│  ├── get(endpoint, headers)                                │
│  ├── post(endpoint, body, headers)                         │
│  ├── put(endpoint, body, headers)                          │
│  └── delete(endpoint, headers)                             │
│                                                              │
│  Manejo Centralizado:                                       │
│  ├── Headers comunes (Authorization, Content-Type)         │
│  ├── Respuestas HTTP (200, 201, 400, 401, 404, 500)       │
│  └── Excepciones (ApiException personalizada)              │
└──────────────────┬──────────────────────────────────────────┘
                   │ (HTTP Client - http package)
┌──────────────────▼──────────────────────────────────────────┐
│                   BACKEND API                                │
│  (REST Endpoints)                                           │
│                                                              │
│  GET  /api/productos          - Lista de productos         │
│  GET  /api/promociones        - Promociones activas        │
│  POST /api/clientes           - Registrar cliente          │
│  POST /api/pedidos            - Crear pedido              │
│  GET  /api/pedidos/:id        - Detalles de pedido        │
│  ...                                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Flujo de Datos: Ejemplo - Cargar Productos

```
Menu.dart
    │
    ├─→ FutureBuilder(future: apiService.fetchProducts())
    │
    ├─→ ApiService.fetchProducts()
    │   │
    │   ├─→ CacheService.has('products_menu')?
    │   │   ├─ YES → return cached products (instantáneo) ✓
    │   │   └─ NO  → continue...
    │   │
    │   ├─→ BaseApiService.get('/productos')
    │   │   │
    │   │   ├─→ HTTP Client
    │   │   │   ├─ Headers: {
    │   │   │   │   'Content-Type': 'application/json',
    │   │   │   │   'Authorization': 'Bearer API_KEY'
    │   │   │   ├─ }
    │   │   │   └─ GET https://api.example.com/api/productos
    │   │   │
    │   │   └─→ Response Handler
    │   │       ├─ 200-299: Parse JSON ✓
    │   │       ├─ 401: Not authorized (login)
    │   │       ├─ 404: Not found
    │   │       ├─ 500: Server error
    │   │       └─ 4xx/5xx: Throw ApiException
    │   │
    │   ├─→ Parse JSON to ProductModel list
    │   │   ├─ Validate each product
    │   │   ├─ Filter out invalid items
    │   │   └─ Return List<ProductModel>
    │   │
    │   └─→ CacheService.set('products_menu', products)
    │
    └─→ FutureBuilder states:
        ├─ ConnectionState.waiting → ProductsSkeletonGrid (shimmer)
        ├─ snapshot.hasError → ErrorWidget (+ retry button)
        └─ snapshot.hasData → GridView of products ✓
```

---

## Estados de Conexión (FutureBuilder)

```
┌─────────────────────────────────────────┐
│       FutureBuilder Connection States    │
└─────────────────────────────────────────┘

1. WAITING (Mientras carga)
   ┌─────────────────────────────┐
   │   Mostrando Skeletons       │
   │   [████░░░░]  [████░░░░]   │  ← Shimmer effect
   │   [████░░░░]  [████░░░░]   │
   └─────────────────────────────┘

2. ERROR (Si falla)
   ┌─────────────────────────────┐
   │  ⚠️  Error al cargar        │
   │     productos:             │
   │     Socket exception        │
   │     [REINTENTAR]           │  ← Botón para retry
   └─────────────────────────────┘

3. SUCCESS (Datos listos)
   ┌─────────────────────────────┐
   │  🥩 Paquete Individual      │
   │     $105.00                 │
   │  [+] AGREGAR AL CARRITO     │
   │                             │
   │  🥩 Paquete Familiar        │
   │     $355.00                 │
   │  [+] AGREGAR AL CARRITO     │
   └─────────────────────────────┘
```

---

## Flujo de Errores

```
┌─────────────────────────────────────────────────┐
│             ERROR HANDLING FLOW                  │
└─────────────────────────────────────────────────┘

API Error (HTTP)
       │
       ├─→ 401 Unauthorized
       │   └─→ ApiException("No autorizado")
       │       └─→ Menu: "Verifica tus credenciales"
       │           └─→ Redirige a Login
       │
       ├─→ 404 Not Found
       │   └─→ ApiException("Recurso no encontrado")
       │       └─→ Menu: "Productos no disponibles"
       │
       ├─→ 500 Server Error
       │   └─→ ApiException("Error del servidor")
       │       └─→ Menu: "El servidor está teniendo problemas"
       │
       └─→ 4xx/5xx Otros
           └─→ ApiException("Error: XXX")
               └─→ Menu: ErrorWidget + [REINTENTAR]
                   └─→ onClick: clearCache() + setState()
                       └─→ Reintenta la petición
```

---

## Cache Flow

```
┌─────────────────────────────────────────────────┐
│           CACHE LIFECYCLE                       │
└─────────────────────────────────────────────────┘

First Load:
  fetchProducts()
  └─→ Cache miss
      └─→ HTTP Request to API
          └─→ Response: 200 OK
              └─→ Parse JSON
                  └─→ CacheService.set(key, products, expires_in: 15min)
                      └─→ Return products

Second Load (within 15 min):
  fetchProducts()
  └─→ Cache hit ✓ (instantaneous)
      └─→ Return products from cache
          └─→ No HTTP Request needed

After 15 minutes:
  Cache entry expires
  └─→ Next fetchProducts()
      └─→ Cache miss (expired)
          └─→ Fresh HTTP Request
              └─→ New cache entry

Manual Cache Clear:
  apiService.clearCache()
  └─→ All entries removed
      └─→ Next request = fresh HTTP
```

---

## Modelo de Datos: ProductModel

```
┌─────────────────────────────────────────────────┐
│           ProductModel Structure                 │
└─────────────────────────────────────────────────┘

API Response JSON:
{
  "id": "1",
  "title": "Paquete Individual",
  "price": 105.00,
  "category": "Paquetes",
  "image": "assets/Paquetes/Paquete1.jpg",
  "description": "...",
  "stock": 50,
  "available": true
}
       │
       ├─→ ProductModel.fromJson(json)
       │   ├─ Validación de campos obligatorios
       │   │  ├─ id: required (string)
       │   │  ├─ title: required (string)
       │   │  └─ price: required (double)
       │   │
       │   ├─ Conversión de tipos
       │   │  ├─ price: num → double
       │   │  ├─ stock: int? (nullable)
       │   │  └─ available: bool?
       │   │
       │   ├─ Valores por defecto seguros
       │   │  ├─ image: "assets/LandingFoto.jpg" (si falta)
       │   │  ├─ category: "Otros" (si falta)
       │   │  └─ description: "Sin descripción" (si falta)
       │   │
       │   └─→ ProductModel instance ✓
       │
       └─→ ProductModel.toJson()
           └─ Serialización inversa para enviar al servidor
```

---

## Validación Robusta

```
┌─────────────────────────────────────────────────┐
│      Validation Layers                          │
└─────────────────────────────────────────────────┘

Level 1: Type Safety (Dart)
  ├─ id: String
  ├─ price: double
  └─ ... (type-checked at compile time)

Level 2: Constructor Assertions
  ├─ assert(price >= 0) - No precios negativos
  ├─ assert(id.isNotEmpty) - ID obligatorio
  └─ assert(title.isNotEmpty) - Título obligatorio

Level 3: fromJson() Validation
  ├─ if (json['id'] == null) throw FormatException
  ├─ if (json['price'] == null) throw FormatException
  └─ ... (validates required fields)

Level 4: Error Handling
  ├─ try/catch in ApiService
  ├─ ApiException wraps errors
  └─ UI shows friendly error message

Result: ✓ No crashes, graceful degradation
```

---

**Diagrama completo del Sprint 2: Arquitectura profesional, segura y escalable.**
