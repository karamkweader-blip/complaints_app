import 'dart:convert';
import 'package:buyro_app/Model/complaint_model.dart';
import 'package:get/get.dart';
import 'package:buyro_app/data/datasource/remote/complaints/complaints_remote.dart';
import 'package:buyro_app/core/services/services.dart';

class ComplaintDetailsController extends GetxController {
  final int complaintId;

  ComplaintDetailsController(this.complaintId);

  bool isLoading = true;
  Map<String, dynamic>? complaint;
  String? token;

  @override
  void onInit() {
    super.onInit();
    fetchComplaintDetails();
  }

  fetchComplaintDetails() async {
    try {
      final prefs = Get.find<MyServices>().sharedPreferences;
      token = prefs.getString("user_token") ?? prefs.getString("token");

      var response = await ComplaintRemote().getComplaintDetails(
        complaintId,
        token: token!,
      );

      var bodyString = await response.stream.bytesToString();
      var data = json.decode(bodyString);

      complaint = data["data"];
    } catch (e) {
      print("❌ ERROR FETCHING = $e");
    }

    isLoading = false;
    update();
  }
}
