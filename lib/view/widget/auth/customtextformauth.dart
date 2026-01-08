import 'package:flutter/material.dart';

class CustonTextFormAuth extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool? obscureText;
  final void Function()? onTapIcon;
  final int maxLines;

  const CustonTextFormAuth({
    super.key,
    this.obscureText,
    this.onTapIcon,
    required this.hinttext,
    required this.labeltext,
    required this.iconData,
    required this.mycontroller,
    required this.valid,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        validator: valid,
        controller: mycontroller,
        obscureText: obscureText ?? false,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? 14 : 8,
            horizontal: 24,
          ),
          label: Container(
            margin: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(labeltext),
          ),
          suffixIcon: InkWell(onTap: onTapIcon, child: Icon(iconData)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
