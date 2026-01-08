// controllers/responsive_controller.dart
import 'package:get/get.dart';

class ResponsiveController extends GetxController {
  // متغيرات لتتبع حجم الشاشة
  var screenWidth = 0.0.obs;
  var screenHeight = 0.0.obs;
  var isDesktop = false.obs;
  var isTablet = false.obs;
  var isMobile = true.obs;

  void updateScreenSize() {
    screenWidth.value = Get.width;
    screenHeight.value = Get.height;
    
    isMobile.value = Get.width < 600;
    isTablet.value = Get.width >= 600 && Get.width < 1200;
    isDesktop.value = Get.width >= 1200;
  }
}