import 'dart:convert';
import 'package:buyro_app/Model/complaint_model.dart';
import 'package:buyro_app/constants.dart';
import 'package:http/http.dart' as http;

class ComplaintService {
  // final String baseUrl = "http://192.168.1.108:8000/api";

  Future<List<Complaint>> getUserComplaints(String token) async {
    final url = Uri.parse("${baseURL}complaints/get-user-complaints");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body["success"] == true) {
      List list = body["data"];
      return list.map((e) => Complaint.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch complaints");
    }
  }
}
