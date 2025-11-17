import 'package:buyro_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInRemote {
  Future<http.Response> postData({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${baseURL}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response;
  }
}
