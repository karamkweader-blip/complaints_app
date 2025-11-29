import 'package:buyro_app/core/routes/routes.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/checkcode.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:buyro_app/view/screen/auth/verifycode.dart';
import 'package:buyro_app/view/screen/auth/login.dart';
import 'package:buyro_app/view/screen/auth/signup.dart';
import 'package:buyro_app/view/screen/home/ComplaintDetailsPage.dart';
import 'package:buyro_app/view/screen/home/complaint_screen.dart';
import 'package:buyro_app/view/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Map<String, Widget Function(BuildContext)> routes = {
  /////// Auth
  AppRoute.login: (context) => const Login(),
  AppRoute.signUp: (context) => const SignUp(),
  AppRoute.forgetPassword: (context) => const ForgetPassword(),
  AppRoute.verfiyCode: (context) => const VerfiyCode(),
  AppRoute.checkCode: (context) => const CheckCode(),
  AppRoute.resetPassword: (context) => const ResetPassword(),
  AppRoute.successResetpassword: (context) => const SuccessResetPassword(),
  ///OnBoarding
  ////inside app
AppRoute.home: (context) => const ComplaintsPage(),


  //// Add Complaint
  "/addComplaint": (context) => ComplaintScreen(),

"/complaintDetails": (context) => ComplaintDetailsPage(
      complaintId: Get.arguments,
    ),






};
