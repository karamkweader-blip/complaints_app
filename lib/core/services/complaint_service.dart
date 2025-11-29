import 'dart:io';
import 'package:buyro_app/constants.dart';
import 'package:buyro_app/core/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ComplaintService {

  Future<http.StreamedResponse> createComplaint({
    required int governmentEntityId,
    required String description,
    required String type,
    File? file,
  }) async {
    // هنا فقط بعد التأكد أن MyServices مهيأ
    MyServices myServices = Get.find();

    String? token = myServices.sharedPreferences.getString("token");

    var url = Uri.parse("${baseURL}/api/complaints/create");

    var request = http.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer $token";

    request.fields["government_entity_id"] = governmentEntityId.toString();
    request.fields["description"] = description;
    request.fields["type"] = type;

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "attachment",
        file.path,
      ));
    }

    return await request.send();
  }
}
