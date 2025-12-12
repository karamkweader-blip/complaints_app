import 'dart:io';
import 'package:buyro_app/controller/home/complaint_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class ComplaintScreen extends StatelessWidget {
  ComplaintScreen({Key? key}) : super(key: key);
  final ComplaintController controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        title: const Text("تقديم شكوى"),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<ComplaintController>(
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formState,
            child: ListView(
              children: [
                DropdownButtonFormField<int>(
                  value: controller.selectedGovernmentEntityId,
                  decoration: InputDecoration(
                    labelText: "الجهة",
                    border: OutlineInputBorder(),
                    fillColor: AppColor.backgroundcolor,
                  ),
                  items: controller.governmentEntities
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e['id'],
                          child: Text(e['name']),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    controller.selectedGovernmentEntityId = val;
                  },
                  validator: (val) => val == null ? "اختر الجهة" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.description,
                  decoration: const InputDecoration(
                    labelText: "وصف الشكوى",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (val) => val!.isEmpty ? "ادخل وصف الشكوى" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.type,
                  decoration: const InputDecoration(
                    labelText: "نوع الشكوى",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? "ادخل نوع الشكوى" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.location,
                  decoration: const InputDecoration(
                    labelText: "الموقع",
                    border: OutlineInputBorder(),
                    hintText: "اكتب الموقع هنا",
                  ),
                  validator: (val) => val!.isEmpty ? "ادخل الموقع" : null,
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      controller.chooseFile(File(result.files.single.path!));
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(controller.selectedFile != null
                          ? "تم اختيار ملف"
                          : "اختر ملف"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.backgroundcolor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          controller.submitComplaint();
                        },
                        child: const Text("ارسال الشكوى"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
