import 'dart:convert';
import 'dart:io';
import 'package:buyro_app/core/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:buyro_app/constants.dart';

class ComplaintRemote {

Future<http.StreamedResponse> createComplaint({
  required int governmentEntityId,
  required String description,
  required String type,
  File? file,
  Map<String, dynamic>? location,
}) async {

  MyServices myServices = Get.find();
  String? token = myServices.sharedPreferences.getString("user_token");

  if (token == null || token.isEmpty) {
    Get.snackbar("خطأ", "رجاءً سجل الدخول قبل إرسال الشكوى");
    return Future.error("No token found");
  }

  var url = Uri.parse("${baseURL}complaints/create");

  var request = http.MultipartRequest("POST", url);
  request.headers["Authorization"] = "Bearer $token";

  request.fields["government_entity_id"] = governmentEntityId.toString();
  request.fields["description"] = description;
  request.fields["type"] = type;

  // 🟢 إرسال الموقع كما يريده الباك
  if (location != null) {
    request.fields["location[latitude]"] = location["latitude"].toString();
    request.fields["location[longitude]"] = location["longitude"].toString();
    request.fields["location[place]"] = location["place"];
  }

  if (file != null) {
    request.files.add(await http.MultipartFile.fromPath(
      "file",   // اسم من البوست مان
      file.path,
    ));
  }

  print("====== DATA YOU ARE SENDING ======");
  request.fields.forEach((key, value) {
    print("  $key : $value");
  });
  print("==================================");

  return await request.send();
}


  Future<List<dynamic>> getUserComplaints(String token) async {
    final url = Uri.parse("${baseURL}complaints/get-user-complaints");

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("===== GET USER COMPLAINTS RESPONSE =====");
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["success"] == true) {
        return json["data"];
      }
    }

    throw Exception("Failed to load complaints");
  }

  Future<http.StreamedResponse> getComplaintDetails(int id, {required String token}) async {
    var url = Uri.parse("${baseURL}complaints/show/$id");

    print("📡 DETAILS URL = $url");

    var request = http.Request("GET", url);
    request.headers["Authorization"] = "Bearer $token";

    return await request.send();
  }

  // -----------------------------
  // 🔹 جديد: جلب الجهات الحكومية
  // -----------------------------
  Future<List<dynamic>> getGovernmentEntities() async {
    MyServices myServices = Get.find();
    String? token = myServices.sharedPreferences.getString("user_token");

    if(token == null || token.isEmpty){
      Get.snackbar("خطأ", "رجاءً سجل الدخول");
      return Future.error("No token found");
    }

    final url = Uri.parse("${baseURL}government-entities/all-entities");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    print("===== GET GOVERNMENT ENTITIES RESPONSE =====");
    print(response.body);

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      if(json["success"] == true){
        return json["data"];
      }
    }

    throw Exception("Failed to load government entities");
  }

}
