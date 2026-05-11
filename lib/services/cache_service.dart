/// Cache simple en memoria con expiración
class CacheService {
  static const Duration defaultExpiry = Duration(minutes: 15);

  static final CacheService _instance = CacheService._internal();

  final Map<String, _CacheEntry> _cache = {};

  CacheService._internal();

  factory CacheService() {
    return _instance;
  }

  /// Guarda un valor en el cache
  void set(String key, dynamic value, {Duration expiry = defaultExpiry}) {
    _cache[key] = _CacheEntry(
      value: value,
      expiryTime: DateTime.now().add(expiry),
    );
  }

  /// Obtiene un valor del cache
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Verificar si ha expirado
    if (DateTime.now().isAfter(entry.expiryTime)) {
      _cache.remove(key);
      return null;
    }

    return entry.value as T?;
  }

  /// Verifica si existe una clave en el cache
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;

    // Verificar si ha expirado
    if (DateTime.now().isAfter(entry.expiryTime)) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Elimina una entrada del cache
  void remove(String key) {
    _cache.remove(key);
  }

  /// Limpia todo el cache
  void clear() {
    _cache.clear();
  }

  /// Obtiene el número de entradas activas en el cache
  int get length => _cache.length;
}

/// Clase interna para almacenar entradas del cache con expiración
class _CacheEntry {
  final dynamic value;
  final DateTime expiryTime;

  _CacheEntry({required this.value, required this.expiryTime});
}
