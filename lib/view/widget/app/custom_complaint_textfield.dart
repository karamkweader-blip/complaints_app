import 'package:flutter/material.dart';
import 'package:buyro_app/core/constant/color.dart';

class CustomComplaintTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? mycontroller;
  final String? Function(String?)? valid;
  final int maxLines;

  const CustomComplaintTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.mycontroller,
    this.valid,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
        ),
        TextFormField(
          controller: mycontroller,
          validator: valid,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            prefixIcon: Icon(icon, color: AppColor.primaryColor, size: 22),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            // الحدود في الحالة العادية
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            // الحدود عند الضغط على الحقل
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
            ),
            // الحدود في حالة الخطأ
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}