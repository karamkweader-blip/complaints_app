import 'package:flutter/material.dart';
import 'package:buyro_app/core/constant/color.dart';

class CustomInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const CustomInfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColor.primaryColor.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}