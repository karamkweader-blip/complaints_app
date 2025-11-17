import 'package:buyro_app/core/routes/routes.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/checkcode.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:buyro_app/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:buyro_app/view/screen/auth/verifycode.dart';
import 'package:buyro_app/view/screen/auth/login.dart';
import 'package:buyro_app/view/screen/auth/signup.dart';
import 'package:buyro_app/view/screen/home/home.dart';
import 'package:buyro_app/view/screen/onboarding.dart';
import 'package:flutter/material.dart';

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
  AppRoute.onBoarding: (context) => const OnBoarding(),
  ////inside app
  AppRoute.home: (context) => const HomePage(),

};
