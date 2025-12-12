import 'package:buyro_app/data/datasource/remote/complaints/delete&update_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buyro_app/Model/complaint_model.dart';
import 'dart:convert';

class EditComplaintController extends GetxController {
  final Complaint complaint;

  EditComplaintController(this.complaint);

  final _api = DeleteAndUpdateComplaints();

  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController referenceController;
 late TextEditingController locationController;
  var latitude = ''.obs;
  var longitude = ''.obs;
  var place = ''.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    typeController = TextEditingController(text: complaint.type);
    descriptionController =
        TextEditingController(text: complaint.description);
    referenceController =
        TextEditingController(text: complaint.referenceNumber);
locationController = TextEditingController(
  text: complaint.location?.place ?? '',
);
    // latitude.value = complaint.location?.latitude ?? '';
    // longitude.value = complaint.location?.longitude ?? '';
    // place.value = complaint.location?.place ?? '';
  }

  ///  تحديث الموقع
  // Future<void> getUserLocation() async {
  //   try {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       permission = await Geolocator.requestPermission();
  //     }

  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       Get.snackbar("خطأ", "لا توجد أذونات للموقع");
  //       return;
  //     }

  //     final pos = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     latitude.value = pos.latitude.toString();
  //     longitude.value = pos.longitude.toString();
  //     place.value = "موقعك الحالي";
  //   } catch (e) {
  //     Get.snackbar("خطأ", "فشل تحديد الموقع");
  //   }
  // }

  
  Future<void> updateComplaint() async {
    try {
      isLoading.value = true;

      final body = {
        "type": typeController.text,
        "description": descriptionController.text,
        "reference_number": referenceController.text,
          "location": {
  "place": locationController.text,
},
        //   "latitude": latitude.value,
        //   "longitude": longitude.value,
        //   "place": place.value,
        // },
      };

      final response = await _api.updateComplaint(
        complaintId: complaint.id,
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(result: true);
        Get.snackbar("نجاح", "تم تعديل الشكوى بنجاح");
      } else {
        Get.snackbar("خطأ", data["message"] ?? "فشل تعديل الشكوى");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء التعديل");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteComplaint() async {
    try {
      isLoading.value = true;

      final response = await _api.deleteComplaint(
        complaintId: complaint.id.toString(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.back(result: "deleted");
        Get.snackbar("تم", "تم حذف الشكوى بنجاح");
      } else {
        Get.snackbar("خطأ", data["message"] ?? "فشل حذف الشكوى");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الحذف");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    typeController.dispose();
    descriptionController.dispose();
    referenceController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
