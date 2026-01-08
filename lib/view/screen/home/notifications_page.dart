import 'package:buyro_app/controller/notifications/notifications_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
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
            "مركز التنبيهات",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          foregroundColor: Colors.white,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primaryColor),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 10),
                const Text(
                  "لا توجد إشعارات حالياً",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            final createdAt = DateTime.parse(notif['created_at']);
            final diff = DateTime.now().difference(createdAt);
            final isFresh = diff.inHours < 1;

            String timeLabel;

            if (diff.inMinutes < 1) {
              timeLabel = "الآن";
            } else if (diff.inMinutes < 60) {
              timeLabel = "منذ ${diff.inMinutes} دقيقة";
            } else if (diff.inHours < 24) {
              timeLabel = "منذ ${diff.inHours} ساعة";
            } else {
              timeLabel = DateFormat('yyyy-MM-dd | HH:mm').format(createdAt);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border(
                  right: BorderSide(
                    color: isFresh ? AppColor.primaryColor : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor:
                      isFresh
                          ? AppColor.primaryColor.withOpacity(0.1)  //الداائرة حول الايقونة
                          : Colors.grey.shade100,
                  child: Icon(
                    isFresh
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                    color: isFresh ? AppColor.primaryColor : Colors.grey,
                  ),
                ),
                title: Text(
                  notif['title'] ?? '',
                  style: TextStyle(
                    fontWeight: isFresh ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                    color: isFresh ? Colors.black : Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      notif['body'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
