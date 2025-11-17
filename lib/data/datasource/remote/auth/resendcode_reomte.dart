import 'package:buyro_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResendCodeRemote {
  Future<http.Response> postData({required String email}) async {
    final response = await http.post(
      Uri.parse('${baseURL}resend-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }
}
