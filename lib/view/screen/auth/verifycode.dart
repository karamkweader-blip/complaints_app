import 'package:buyro_app/controller/auth/verifycode_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/widget/auth/customtextbodyauth.dart';
import 'package:buyro_app/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class VerfiyCode extends StatelessWidget {
  const VerfiyCode({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final VerifyCodeType type = args['type'];
    final String email = args['email'];

    VerifyCodeControllerImp controller = Get.put(
      VerifyCodeControllerImp(type: type, email: email),
    );

       // دالة لحساب عرض الحقل بناءً على حجم الشاشة
    double calculateFieldWidth() {
      double width = Get.width;
      if (width > 600) { // Tablet
        return 60;
      } else if (width > 400) { // Mobile كبير
        return 50;
      } else { // Mobile صغير
        return 45;
      }
    }

    // دالة لحساب حجم الخط
    double getResponsiveFontSize(double baseSize) {
      double width = Get.width;
      if (width > 600) { // Tablet
        return baseSize * 1.1;
      } else if (width > 400) { // Mobile كبير
        return baseSize;
      } else { // Mobile صغير
        return baseSize * 0.9;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          'رمز التحقق',
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(color: AppColor.grey),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.03,
          horizontal: Get.width * 0.07,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const CustomTextTitleAuth(text: "تحقق من الرمز"),
            const SizedBox(height: 10),
            const CustomTextBodyAuth(
              text: "يرجى إدخال رمز التحقق المرسل إلى بريدك الإلكتروني",
            ),
            const SizedBox(height: 15),
            OTPTextField(
              length: 6,
               width: Get.width * 0.9, 
                fieldWidth: calculateFieldWidth(),
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              otpFieldStyle: OtpFieldStyle(
                borderColor: const Color(0xFF512DA8),
              ),
              onChanged: (String code) {},
              onCompleted: (String verificationCode) {
                controller.code = verificationCode;
                controller.checkCode();
              },
            ),
            const SizedBox(height: 10),
            InkWell(
              child: Text('اعادة ارسال الكود', style: TextStyle(fontSize: 16)),
              onTap: () {
                controller.resendCode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
