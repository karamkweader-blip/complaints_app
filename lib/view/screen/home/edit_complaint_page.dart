import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/controller/home/edit_complaint_controller.dart';
import 'package:buyro_app/Model/complaint_model.dart';

class EditComplaintPage extends StatelessWidget {
  final Complaint complaint;

  const EditComplaintPage({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(EditComplaintController(complaint));

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الشكوى"),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildField("نوع الشكوى", controller.typeController),
              _buildField(
                  "الرقم المرجعي", controller.referenceController),
              _buildField(
                "الوصف",
                controller.descriptionController,
                maxLines: 4,
              ),

              const SizedBox(height: 16),

              /// ✅ الموقع الحالي (من الشكوى أو من المستخدم)
              Obx(
                () => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    controller.place.value.isEmpty
                        ? "لم يتم تحديد الموقع"
                        : controller.place.value,
                  ),
                  subtitle: Text(
                    controller.latitude.value.isEmpty
                        ? ""
                        : "${controller.latitude.value} , ${controller.longitude.value}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: controller.getUserLocation,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ✅ زر حفظ التعديلات
             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    onPressed: controller.updateComplaint, // ✅ استدعاء التعديل فقط
    child: const Text(
      "حفظ التعديلات",
      style: TextStyle(fontSize: 16),
    ),
  ),
),

            ],
          ),
        );
      }),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
