// ignore_for_file: deprecated_member_use

import 'package:buyro_app/controller/auth/login_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/core/functions/alertexitapp.dart';
import 'package:buyro_app/core/functions/validinput.dart';
import 'package:buyro_app/view/widget/auth/custombuttonauth.dart';
import 'package:buyro_app/view/widget/auth/customtextbodyauth.dart';
import 'package:buyro_app/view/widget/auth/customtextformauth.dart';
import 'package:buyro_app/view/widget/auth/customtexttitleauth.dart';
import 'package:buyro_app/view/widget/auth/logoauth.dart';
import 'package:buyro_app/view/widget/auth/textsignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    LoginControllerImp controller = Get.put(LoginControllerImp());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'Sign In',
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(color: AppColor.grey),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await alertExitApp();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
            key: controller.formstate,
            child: ListView(
              children: [
                const LogoAuth(),
                const SizedBox(height: 20),
                CustomTextTitleAuth(text: "10".tr),
                const SizedBox(height: 10),
                CustomTextBodyAuth(text: "11".tr),
                const SizedBox(height: 15),
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
                  obscureText: controller.isshowpassword,
                  onTapIcon: () {
                    controller.showPassword();
                  },
                  valid: (val) {
                    return validInput(val!, 5, 30, "password");
                  },
                  mycontroller: controller.password,
                  hinttext: "13".tr,
                  iconData: Icons.lock_outline,
                  labeltext: "19".tr,
                ),

                InkWell(
                  onTap: () {
                    controller.goToForgetPassword();
                  },
                  child: Text("14".tr, textAlign: TextAlign.right),
                ),
                CustomButtomAuth(
                  text: "15".tr,
                  onPressed: () {
                    controller.login();
                  },
                ),

                const SizedBox(height: 20),
                CustomTextSignUpOrSignIn(
                  textone: "16".tr,
                  texttwo: "17".tr,
                  onTap: () {
                    controller.goToSignUp();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
