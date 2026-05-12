import 'dart:convert';

class JwtHelper {
  static bool tokenExpirado(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      String payload = parts[1];
      payload += '=' * ((4 - payload.length % 4) % 4);
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> data = json.decode(decoded);

      if (!data.containsKey('exp')) return false;

      final exp = data['exp'] as int;
      final ahora = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return ahora >= exp;
    } catch (_) {
      return true;
    }
  }
}