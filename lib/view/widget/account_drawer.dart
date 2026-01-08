import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/screen/home/language_page.dart';
import 'package:buyro_app/view/widget/account_menu-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/controller/home/home_controller.dart';

class AccountDrawer extends StatelessWidget {
  const AccountDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // الجزء العلوي (Header) مدمج مباشرة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primaryColor, Color(0xFF1B5E20)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "مرحباً بك في",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const Text(
                  "نظام إدارة الشكاوى",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "تاريخ اليوم: ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                // عنوان القسم الأول وضعته كنص عادي مباشرة
                const Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 12),
                  child: Text(
                    "الإعدادات العامة",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                AccountMenuItem(
                  icon: Icons.language_rounded,
                  label: "تغيير اللغة",
                  onTap: () {
                    Get.back();
                    Get.to(() => const Language());
                  },
                ),

                const SizedBox(height: 12),

                AccountMenuItem(
                  icon: Icons.info_outline_rounded,
                  label: "عن التطبيق",
                  onTap: () {
                    Get.back();
                    Get.defaultDialog(
                      title: "حول التطبيق",
                      middleText:
                          "نظام إدارة الشكاوى الذكي\nkaramalah.kweader@gmail.com",
                      radius: 15,
                    );
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                ),

                // عنوان القسم الثاني
                const Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 12),
                  child: Text(
                    "الحساب",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                AccountMenuItem(
                  icon: Icons.logout_rounded,
                  label: "تسجيل الخروج",
                  color: Colors.redAccent,
                  onTap: () {
                    Get.back();
                    controller.logout();
                  },
                ),
              ],
            ),
          ),

          // الإصدار في الأسفل
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "الإصدار 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
