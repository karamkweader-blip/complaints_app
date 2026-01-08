import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/view/widget/account_drawer.dart';
import 'package:buyro_app/view/widget/app/complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/core/constant/color.dart';

class ComplaintsPage extends StatelessWidget {
  ComplaintsPage({super.key}) {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      key: controller.scaffoldKey,
      drawer: const AccountDrawer(),
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primaryColor, Color(0xFF1B5E20)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          title: const Text(
            "قائمة الشكاوى",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.menu_open_rounded, size: 28),
            onPressed: controller.openDrawer,
          ),
          actions: [
            //  الإضافة
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                onPressed: () => Get.toNamed("/addComplaint"),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, size: 28),
                  onPressed: () => Get.toNamed("/notifications"),
                ),
                Obx(() => controller.unreadCount.value > 0
                    ? Positioned(
                        right: 8,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Center(
                            child: Text('${controller.unreadCount.value}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor));
        }

        if (controller.complaints.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 70, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text("لا توجد شكاوى حتى الآن", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            return ComplaintCard(complaint: controller.complaints[index]);
          },
        );
      }),
    );
  }
}