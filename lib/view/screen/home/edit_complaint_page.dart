import 'package:buyro_app/Model/complaint_model.dart';
import 'package:buyro_app/controller/home/edit_complaint_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/widget/app/custom_complaint_textfield.dart';
import 'package:buyro_app/view/widget/app/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditComplaintPage extends StatelessWidget {
  final Complaint complaint;

  const EditComplaintPage({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditComplaintController(complaint));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primaryColor, Color(0xFF1B5E20)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          title: const Text(
            "تعديل بيانات الشكوى",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          foregroundColor: Colors.white,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCardWidget(
              title: "تحديث المعلومات",
              icon: Icons.edit_note_rounded,
              children: [
                CustomComplaintTextField(
                  label: "نوع الشكوى",
                  hint: "عدل نوع الشكوى...",
                  icon: Icons.category_rounded,
                  mycontroller: controller.typeController,
                  valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                ),
                CustomComplaintTextField(
                  label: "تفاصيل المشكلة",
                  hint: "عدل تفاصيل المشكلة هنا...",
                  icon: Icons.description_rounded,
                  mycontroller: controller.descriptionController,
                  maxLines: 4,
                  valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                ),
                CustomComplaintTextField(
                  label: "الموقع",
                  hint: "عدل العنوان أو الموقع...",
                  icon: Icons.location_on_rounded,
                  mycontroller: controller.locationController,
                  valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                ),
              ],
            ),

            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: controller.updateComplaint,
                child: const Text(
                  "حفظ التغييرات الآن",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}