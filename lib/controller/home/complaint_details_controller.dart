import 'dart:convert';
import 'package:get/get.dart';
import 'package:buyro_app/data/datasource/remote/complaints/complaints_remote.dart';
import 'package:buyro_app/core/services/services.dart';

class ComplaintDetailsController extends GetxController {
  final int complaintId;

  ComplaintDetailsController(this.complaintId);

  bool isLoading = true;
  Map<String, dynamic>? complaint;

  @override
  void onInit() {
    super.onInit();
    fetchComplaintDetails();
  }

  fetchComplaintDetails() async {
    try {
      // 🔥 جلب التوكن من الـ SharedPreferences
      final prefs = Get.find<MyServices>().sharedPreferences;
      final token = prefs.getString("user_token") ?? prefs.getString("token");

      print("🔍 FETCH DETAILS FOR ID = $complaintId");
      print("🔑 TOKEN = $token");

      // 🔥 إرسال الطلب
      var response = await ComplaintRemote().getComplaintDetails(
        complaintId,
        token: token!,
      );

      var bodyString = await response.stream.bytesToString();
      print("📩 RAW RESPONSE = $bodyString");

      var data = json.decode(bodyString);

      // 🔥 قراءة الداتا
      complaint = data["data"];

      print("📌 COMPLAINT DATA = $complaint");
    } catch (e) {
      print("❌ ERROR FETCHING DETAILS: $e");
    }

    isLoading = false;
    update();
  }
}
