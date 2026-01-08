import 'package:buyro_app/controller/auth/signup_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/core/functions/validinput.dart';
import 'package:buyro_app/view/widget/auth/custombuttonauth.dart';
import 'package:buyro_app/view/widget/auth/customtextbodyauth.dart';
import 'package:buyro_app/view/widget/auth/customtextformauth.dart';
import 'package:buyro_app/view/widget/auth/customtexttitleauth.dart';
import 'package:buyro_app/view/widget/auth/logoauth.dart';
import 'package:buyro_app/view/widget/auth/textsignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpControllerImp controller = Get.put(SignUpControllerImp());

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          '17'.tr,
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(color: AppColor.grey),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.02,
          horizontal: Get.width * 0.06,
        ),
        child: Form(
             key: controller.formstate,
          child: ListView(
            children: [
                const LogoAuth(),
              const SizedBox(height: 20),
              CustomTextTitleAuth(text: "10".tr),
              const SizedBox(height: 10),
              CustomTextBodyAuth(text: "24".tr),
              const SizedBox(height: 15),
              CustonTextFormAuth(
                valid: (val) {
                  return validInput(val!, 3, 20, "username");
                },
                mycontroller: controller.username,
                hinttext: "23".tr,
                iconData: Icons.person_outline,
                labeltext: "20".tr,
                // mycontroller: ,
              ),
              CustonTextFormAuth(
                valid: (val) {
                  return validInput(val!, 5, 100, "email");
                },
                mycontroller: controller.email,
                hinttext: "12".tr,
                iconData: Icons.email_outlined,
                labeltext: "18".tr,
                // mycontroller: ,
              ),
              CustonTextFormAuth(
                valid: (val) {
                  return validInput(val!, 8, 50, "password");
                },
                mycontroller: controller.password,
                hinttext: "13".tr,
                iconData: Icons.lock_outline,
                labeltext: "19".tr,
                // mycontroller: ,
              ),
              CustonTextFormAuth(
                valid: (val) {
                   if (val == null || val.isEmpty) {
                return "can't be Empty";
              }
              if (val != controller.password.text) {
                return "passwords do not match";
              }
              return null;
                },
                mycontroller: controller.confpassword,
                hinttext: "22".tr,
                iconData: Icons.lock_outline,
                labeltext: "19".tr,
                // mycontroller: ,
              ),
              CustomButtomAuth(
                text: "17".tr,
                onPressed: () {
                  controller.signUp();
                },
              ),
              const SizedBox(height: 40),
              CustomTextSignUpOrSignIn(
                textone: "25".tr,
                texttwo: "26".tr,
                onTap: () {
                  controller.goToSignIn();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
