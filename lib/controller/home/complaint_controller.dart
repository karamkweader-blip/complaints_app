import 'dart:io';
import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/data/datasource/remote/complaints/complaints_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController location = TextEditingController(); // نص الموقع
  int? selectedGovernmentEntityId;
  File? selectedFile;
  bool isLoading = false;

  // الوزارات من الباك
  List<Map<String, dynamic>> governmentEntities = [];

  @override
  void onInit() {
    super.onInit();
    fetchGovernmentEntities();
  }

  // -----------------------------
  // جلب الجهات الحكومية من السيرفر
  // -----------------------------
  Future<void> fetchGovernmentEntities() async {
    try {
      isLoading = true;
      update();
      var entities = await ComplaintRemote().getGovernmentEntities();
      governmentEntities =
          entities.map<Map<String, dynamic>>((e) => {"id": e["id"], "name": e["name"]}).toList();
      update();
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب الجهات الحكومية");
    } finally {
      isLoading = false;
      update();
    }
  }

  // -----------------------------
  // اختيار ملف من الهاتف
  // -----------------------------
  chooseFile(File file) {
    selectedFile = file;
    update();
  }

  // -----------------------------
  // ارسال الشكوى
  // -----------------------------
  submitComplaint() async {
    if (formState.currentState!.validate() && selectedGovernmentEntityId != null) {
      isLoading = true;
      update();

      try {
        print("====== CONTROLLER SEND DATA ======");
        print("government_entity_id: $selectedGovernmentEntityId");
        print("description: ${description.text}");
        print("type: ${type.text}");
        print("file: ${selectedFile?.path ?? "NO FILE"}");
        print("location: ${location.text}");
        print("==================================");

        var response = await ComplaintRemote().createComplaint(
          governmentEntityId: selectedGovernmentEntityId!,
          description: description.text,
          type: type.text,
          file: selectedFile,
          location: {"place": location.text}, // الباك يحتاج مصفوفة/كائن
        );

        print("Status Code: ${response.statusCode}");
        var responseData = await response.stream.bytesToString();
        print("Response Body: $responseData");

        if (response.statusCode == 201) {
          Get.snackbar("نجاح", "تم ارسال الشكوى بنجاح");

          description.clear();
          type.clear();
          location.clear();
          selectedGovernmentEntityId = null;
          selectedFile = null;
          update();

          await Get.find<HomeController>().fetchComplaints();
          Get.back();
        } else {
          Get.snackbar("فشل", "حدث خطأ حاول مرة اخرى");
        }
      } catch (e) {
        Get.snackbar("خطأ", e.toString());
      }

      isLoading = false;
      update();
    } else {
      Get.snackbar("تنبيه", "رجاءً أكمل جميع الحقول");
    }
  }

  @override
  void onClose() {
    description.dispose();
    type.dispose();
    location.dispose();
    super.onClose();
  }
}
