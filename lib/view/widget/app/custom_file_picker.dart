import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:buyro_app/core/constant/color.dart';

class CustomFilePicker extends StatelessWidget {
  final File? selectedFile;
  final Function(File) onFileChosen;

  const CustomFilePicker({
    super.key,
    required this.selectedFile,
    required this.onFileChosen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          onFileChosen(File(result.files.single.path!));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColor.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_upload_rounded, color: AppColor.primaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                selectedFile != null ? "تم اختيار الملف بنجاح" : "إرفاق صورة أو مستند",
                style: TextStyle(
                  color: selectedFile != null ? Colors.green : Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (selectedFile != null)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}