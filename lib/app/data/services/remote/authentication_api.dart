import 'dart:convert';
import 'package:http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._client);

  final Client _client;
  final _baseUrl = 'http://10.0.2.2:8080';

  Future<String> createRequestToken(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/api/auth/authenticate');

    // Construir el cuerpo de la solicitud con el JSON de autenticación
    final Map<String, String> data = {
      "username": username,
      "password": password,
    };

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Solicitud exitosa, puedes manejar la respuesta aquí
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token =
          responseData['token']; // Ajusta esto según tu respuesta real
      return token;
    } else {
      // Manejar errores de la solicitud
      print('Error en la solicitud: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      throw Exception('Error en la autenticación');
    }
  }
}
