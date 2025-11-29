import 'package:buyro_app/Model/complaint_model.dart';
import 'package:buyro_app/data/datasource/remote/complaints/complaints_remote.dart';
import 'package:buyro_app/data/datasource/remote/complaints/delete&update_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/core/services/services.dart';
import 'dart:convert';

class HomeController extends GetxController {
  var complaints = <Complaint>[].obs;
  var isLoading = false.obs;
  
  var unreadCount = 0.obs;

  ComplaintRemote service = ComplaintRemote();
  final complaintService = DeleteAndUpdateComplaints();
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  /// ✅ جلب الشكاوى
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;

      final token = myServices.sharedPreferences.getString("user_token");
      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكن");
        return;
      }

      final data = await service.getUserComplaints(token);

      complaints.assignAll(
        data.map((json) => Complaint.fromJson(json)).toList(),
      );
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar("خطأ", "فشل في جلب الشكاوى");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteComplaint(int complaintId) async {
    try {
      isLoading.value = true;

      final response = await complaintService.deleteComplaint(
        complaintId: complaintId.toString(),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        complaints.removeWhere((c) => c.id == complaintId);

        Get.snackbar(
          "تم الحذف",
          "تم حذف الشكوى بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "خطأ",
          data["message"] ?? "فشل حذف الشكوى",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("DELETE ERROR: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الحذف",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ تحديث القائمة
  Future<void> refreshPage() async {
    await fetchComplaints();
  }
}
