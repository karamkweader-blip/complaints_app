import 'package:buyro_app/controller/onboarding_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/widget/onboarding/custombutton.dart';
import 'package:buyro_app/view/widget/onboarding/customslider.dart';
import 'package:buyro_app/view/widget/onboarding/dotcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp()) ;
    return Scaffold(
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          child: Column(children: [
            const Expanded(
              flex: 4,
              child: CustomSliderOnBoarding(),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    CustomDotControllerOnBoarding(),
                    Spacer(flex: 2),
                    CustomButtonOnBoarding()
                  ],
                ))
          ]),
        ));
  }
}
