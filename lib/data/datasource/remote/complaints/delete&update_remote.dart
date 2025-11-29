import 'package:buyro_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAndUpdateComplaints {
  /// ✅ حذف الشكوى
  Future<http.Response> deleteComplaint({required String complaintId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    final response = await http.delete(
      Uri.parse('${baseURL}complaints/delete/$complaintId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("DELETE RESPONSE: ${response.body}");
    return response;
  }

  /// ✅ تعديل الشكوى
  Future<http.Response> updateComplaint({
    required int complaintId,
    required Map<String, dynamic> body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    final response = await http.post(
      Uri.parse('${baseURL}complaints/update/$complaintId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print("UPDATE RESPONSE: ${response.body}");
    return response;
  }
}
