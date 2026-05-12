# Santas Asadas

Aplicación Flutter de pedidos para una taquería / asadero con menú, promociones, chat, datos de envío y navegación entre secciones.

## Descripción

Este proyecto es una app móvil multiplataforma construida con Flutter que simula un sistema de pedidos para "Santas Asadas". Incluye:
- Pantalla de registro / login de usuario con datos de envío.
- Menú de productos y promociones.
- Sección de ubicación local.
- Chat / contacto.
- Manejo básico de estado con `provider`.
- Persistencia local de datos de usuario con `shared_preferences`.

## Tecnologías usadas

- Flutter
- Dart
- Provider
- HTTP
- Shared Preferences
- Google Maps Flutter
- Badges
- Material 3

## Estructura principal del proyecto

- `lib/main.dart` – Punto de entrada, tema, rutas y proveedor global.
- `lib/Login.dart` – Formulario de registro / inicio, validaciones y guardado local.
- `lib/Menu.dart` – Pantalla principal del menú y consumo de productos.
- `lib/Chat.dart` – Envío de pedidos por WhatsApp y chat de contacto.
- `lib/Inicio.dart` – Pantalla de bienvenida / home.
- `lib/Local.dart` – Ubicación local del negocio.
- `lib/Promos.dart` – Promociones disponibles.
- `lib/ApiService.dart` – Lógica de conexión a API y manejo de datos.
- `lib/services/base_api_service.dart` – Cliente HTTP base.
- `lib/providers/CartProvider.dart` – Estado del carrito de compras.

## Cómo ejecutar el proyecto

1. Abre una terminal en la carpeta del proyecto:
   ```powershell
   cd "c:\Users\Erick777rex\OneDrive\Escritorio\santas asadas\Santas-Asadas"
   ```
2. Instala dependencias:
   ```powershell
   flutter pub get
   ```
3. Ejecuta la app en un emulador o dispositivo:
   ```powershell
   flutter run
   ```

## Uso de la app

1. En la pantalla de inicio, completa los datos de usuario:
   - Nombre completo
   - Teléfono
   - Dirección
   - Referencias (opcional)
2. Presiona el botón para guardar y navegar a la app.
3. Navega entre las secciones con el menú inferior o el drawer.
4. `Menu` muestra productos y permite recargar el listado.
5. `Promos` muestra promociones.
6. `Local` muestra la ubicación y acceso a mapas.
7. `Chat` permite abrir WhatsApp con mensaje predefinido para hacer pedidos.

## Configuración de API

- `lib/ApiService.dart` contiene la URL base de la API.
- Actualmente la URL está en modo placeholder: `https://your-api-endpoint.com/api`.
- Para conectar con un backend real, actualiza esa URL y verifica los endpoints en el servicio.

## Limitaciones actuales

- No hay autenticación JWT completa en el código actual.
- El login usa datos locales en `SharedPreferences`, no un servicio de autenticación remoto.
- No existe aún configuración de CI/CD en este repositorio.
- No hay carpeta `evidencias/` incluida.

## Documentación adicional

- `documentation/QUICK_START.md`
- `documentation/SPRINT2_SEGURIDAD.md`
- `documentation/SPRINT2_COMPLETADO.md`
- `documentation/ARQUITECTURA_DIAGRAMA.md`

## Ejecutar pruebas

El proyecto incluye el archivo de prueba inicial:
- `test/widget_test.dart`

Para ejecutar pruebas:
```powershell
flutter test
```

## Notas

- Si deseas usar una API real, configura la URL y los tokens en `lib/ApiService.dart`.
- Para pruebas de UI o analítica, es necesario agregar nuevas implementaciones.

---

> Proyecto desarrollado en Flutter con enfoque en experiencia de usuario, navegación y consumo básico de servicios.
