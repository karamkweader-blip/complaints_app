import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/view/screen/home/ComplaintDetailsPage.dart';
import 'package:buyro_app/view/screen/home/edit_complaint_page.dart';
import 'package:buyro_app/view/widget/account_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/Model/complaint_model.dart';
import 'package:buyro_app/core/constant/color.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      key: controller.scaffoldKey,
  drawer: AccountDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: const Text(
          "شكاوى المستخدم",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: controller.openDrawer,
        ),
        actions: [
          IconButton(
  icon: Stack(
    children: [
      const Icon(Icons.notifications, color: Colors.white),
      Obx(() {
        if (controller.unreadCount > 0) {
          return Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  '${controller.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
  ),
  onPressed: () async{
    
 
Get.toNamed("/notifications");
  controller.unreadCount.value = 0;
  },
),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          Get.toNamed("/addComplaint");
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaints.isEmpty) {
          return const Center(child: Text("لا توجد شكاوى حتى الآن"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            final complaint = controller.complaints[index];
            return ComplaintCard(complaint);
          },
        );
      }),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard(this.complaint, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ComplaintDetailsPage(complaintId: complaint.id));
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    complaint.type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      complaint.status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                complaint.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),

              const SizedBox(height: 10),

              ///  الرقم المرجعي
              Row(
                children: [
                  const Icon(Icons.confirmation_number, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    complaint.referenceNumber,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),

              ///  الموقع
              if (complaint.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${complaint.location!.place} (${complaint.location!.latitude}, ${complaint.location!.longitude})",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              /// المرفقات
              if (complaint.attachments != null &&
                  complaint.attachments!.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  "📎 المرفقات:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      complaint.attachments!
                          .map(
                            (a) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "• ${a.fileName}",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],

              const SizedBox(height: 14),
              const Divider(),

              ///  أزرار التعديل والحذف
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.to(() => EditComplaintPage(complaint: complaint));
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text(
                      "تعديل",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "تأكيد الحذف",
                        middleText: "هل أنت متأكد من حذف هذه الشكوى؟",
                        textConfirm: "نعم",
                        textCancel: "إلغاء",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          final controller = Get.find<HomeController>();
                          controller.deleteComplaint(complaint.id);
                          Get.back();
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      "حذف",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
