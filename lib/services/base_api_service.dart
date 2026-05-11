import 'dart:convert';
import 'package:http/http.dart' as http;

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? response;

  ApiException({required this.message, this.statusCode, this.response});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Clase base abstracta para servicios de API
abstract class BaseApiService {
  /// URL base de la API
  String get baseUrl;

  /// API Key para autenticación
  String? get apiKey => null;

  /// Headers comunes para todas las peticiones
  Map<String, String> get commonHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (apiKey != null) 'Authorization': 'Bearer $apiKey',
    };
  }

  /// Cliente HTTP
  http.Client get httpClient => http.Client();

  /// Realiza un GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = {...commonHeaders, ...?additionalHeaders};
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await httpClient.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Error en GET $endpoint: $e');
    }
  }

  /// Realiza un POST request
  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = {...commonHeaders, ...?additionalHeaders};
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Error en POST $endpoint: $e');
    }
  }

  /// Realiza un PUT request
  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = {...commonHeaders, ...?additionalHeaders};
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await httpClient.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Error en PUT $endpoint: $e');
    }
  }

  /// Realiza un DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = {...commonHeaders, ...?additionalHeaders};
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await httpClient.delete(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Error en DELETE $endpoint: $e');
    }
  }

  /// Maneja la respuesta HTTP
  dynamic _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Éxito
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw ApiException(
          message: 'No autorizado. Verifica tus credenciales.',
          statusCode: response.statusCode,
          response: response.body,
        );
      } else if (response.statusCode == 404) {
        throw ApiException(
          message: 'Recurso no encontrado.',
          statusCode: response.statusCode,
          response: response.body,
        );
      } else if (response.statusCode == 500) {
        throw ApiException(
          message: 'Error del servidor. Intenta más tarde.',
          statusCode: response.statusCode,
          response: response.body,
        );
      } else {
        throw ApiException(
          message: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Error al procesar respuesta: $e');
    }
  }
}
