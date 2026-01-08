import 'package:flutter/material.dart';
import 'package:buyro_app/core/constant/color.dart';

class CustomComplaintDropdown extends StatelessWidget {
  final int? value;
  final List<dynamic> items;
  final String hint;
  final IconData icon;
  final void Function(int?) onChanged;
  final String? Function(int?)? validator;

  const CustomComplaintDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = "اختر الجهة",
    this.icon = Icons.business_rounded,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Text(
            hint,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColor.primaryColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: value,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    hint: Text(hint, style: const TextStyle(fontSize: 13)),
                    items: items.map((e) {
                      return DropdownMenuItem<int>(
                        value: e['id'],
                        child: Text(
                          e['name'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    validator: validator,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}