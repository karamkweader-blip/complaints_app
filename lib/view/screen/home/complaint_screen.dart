import 'package:buyro_app/controller/home/complaint_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/widget/app/custom_complaint_dropdown.dart';
import 'package:buyro_app/view/widget/app/custom_complaint_textfield.dart';
import 'package:buyro_app/view/widget/app/custom_file_picker.dart';
import 'package:buyro_app/view/widget/app/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintScreen extends StatelessWidget {
  ComplaintScreen({super.key});

  final ComplaintController controller = Get.put(ComplaintController());

// دالة لحساب حجم الخط المتجاوب
  double getResponsiveFontSize(double baseSize) {
    double width = Get.width;
    if (width > 600) { // Tablet
      return baseSize * 1.2;
    } else if (width > 400) { // Mobile كبير
      return baseSize;
    } else { // Mobile صغير
      return baseSize * 0.9;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height * 0.1), // 10% من ارتفاع الشاشة
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
            "تقديم شكوى جديدة",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          foregroundColor: Colors.white,
        ),
      ),
      body: GetBuilder<ComplaintController>(
        builder: (_) => Form(
          key: controller.formState,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              SectionCardWidget(
                title: "معلومات الشكوى",
                icon: Icons.assignment_rounded,
                children: [
                  CustomComplaintDropdown(
                    value: controller.selectedGovernmentEntityId,
                    items: controller.governmentEntities,
                    onChanged: (val) => controller.selectedGovernmentEntityId = val,
                    validator: (val) => val == null ? "الرجاء اختيار الجهة" : null,
                  ),
                  const SizedBox(height: 15),
                  CustomComplaintTextField(
                    label: "نوع الشكوى",
                    hint: "مثلاً: عطل فني، سوء خدمة...",
                    icon: Icons.category_rounded,
                    mycontroller: controller.type,
                    valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  CustomComplaintTextField(
                    label: "تفاصيل المشكلة",
                    hint: "اشرح ما حدث معك بكل وضوح...",
                    icon: Icons.description_rounded,
                    mycontroller: controller.description,
                    maxLines: 4,
                    valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SectionCardWidget(
                title: "الموقع والملفات",
                icon: Icons.pin_drop_rounded,
                children: [
                  CustomComplaintTextField(
                    label: "العنوان / الموقع",
                    hint: "دقة الموقع تساعد في الحل السريع",
                    icon: Icons.location_on_rounded,
                    mycontroller: controller.location,
                    valid: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
                  ),
                  const SizedBox(height: 10),
                  CustomFilePicker(
                    selectedFile: controller.selectedFile,
                    onFileChosen: (file) => controller.chooseFile(file),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
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
                        onPressed: controller.submitComplaint,
                        child: const Text(
                          "إرسال الشكوى الآن",
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
          ),
        ),
      ),
    );
  }
}