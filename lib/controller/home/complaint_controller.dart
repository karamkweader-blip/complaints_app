import 'dart:io';
import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/data/datasource/remote/complaints/complaints_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ComplaintController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController type = TextEditingController();
  int? selectedGovernmentEntityId;
  File? selectedFile;
  bool isLoading = false;

  // الوزارات من الباك
  List<Map<String, dynamic>> governmentEntities = [];

  // الموقع
  Map<String, dynamic>? location;

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
          entities
              .map<Map<String, dynamic>>(
                (e) => {"id": e["id"], "name": e["name"]},
              )
              .toList();
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
  // تحديد موقع المستخدم
  Future<void> getUserLocation() async {
    try {
      // 1️⃣ التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("خطأ", "لا توجد أذونات للوصول إلى الموقع");
        return;
      }

      // 2️⃣ الحصول على الموقع
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3️⃣ بدون Google API (لتجنب 403)
      location = {
        "latitude": pos.latitude.toString(),
        "longitude": pos.longitude.toString(),
        "place": " موقعك الحالي ",
      };

      update();
      print("📍 الموقع تم تحديده: $location");
    } catch (e) {
      print("⚠️ خطأ تحديد الموقع: $e");
      Get.snackbar("خطأ", "تعذر تحديد الموقع");
    }
  }

  // -----------------------------
  // ارسال الشكوى
  // -----------------------------
  submitComplaint() async {
    if (formState.currentState!.validate() &&
        selectedGovernmentEntityId != null &&
        location != null) {
      isLoading = true;
      update();

      try {
        print("====== CONTROLLER SEND DATA ======");
        print("government_entity_id: $selectedGovernmentEntityId");
        print("description: ${description.text}");
        print("type: ${type.text}");
        print("file: ${selectedFile?.path ?? "NO FILE"}");
        print("location: $location");
        print("==================================");

        var response = await ComplaintRemote().createComplaint(
          governmentEntityId: selectedGovernmentEntityId!,
          description: description.text,
          type: type.text,
          file: selectedFile,
          location: location!,
        );

        print("Status Code: ${response.statusCode}");
        var responseData = await response.stream.bytesToString();
        print("Response Body: $responseData");

        if (response.statusCode == 201) {
          Get.snackbar("نجاح", "تم ارسال الشكوى بنجاح");

          description.clear();
          type.clear();
          selectedGovernmentEntityId = null;
          selectedFile = null;
          location = null;
          update();

          await Get.find<HomeController>().fetchComplaints();

          Get.offAllNamed("/home");
        } else {
          Get.snackbar("فشل", "حدث خطأ حاول مرة اخرى");
        }
      } catch (e) {
        Get.snackbar("خطأ", e.toString());
      }

      isLoading = false;
      update();
    } else {
      Get.snackbar("تنبيه", "رجاءً أكمل جميع الحقول واختر الموقع");
    }
  }

  @override
  void onClose() {
    description.dispose();
    type.dispose();
    super.onClose();
  }
}
