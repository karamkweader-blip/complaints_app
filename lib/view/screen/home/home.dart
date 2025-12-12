import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/view/screen/home/ComplaintDetailsPage.dart';
import 'package:buyro_app/view/screen/home/edit_complaint_page.dart';
import 'package:buyro_app/view/widget/account_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buyro_app/Model/complaint_model.dart';
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
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.to(() => ComplaintDetailsPage(complaintId: complaint.id)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// عنوان نوع الشكوى + الحالة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    complaint.type,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryColor,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color.fromARGB(255, 107, 234, 158), const Color.fromARGB(255, 5, 121, 36)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      complaint.status,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// وصف الشكوى
              Text(
                complaint.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade800),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.confirmation_number, size: 17, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(complaint.referenceNumber, style: TextStyle(color: Colors.black54)),
                ],
              ),

           if (complaint.location != null) ...[
  const SizedBox(height: 8),
  Row(
    children: [
      const Icon(Icons.location_on, size: 17, color: Colors.red),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          complaint.location!.place,  // فقط الاسم
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ),
    ],
  ),
],


              if (complaint.attachments != null && complaint.attachments!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text("📎 المرفقات:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...complaint.attachments!.map((a) => Text("• ${a.fileName}", style: const TextStyle(fontSize: 14))),
              ],

              const SizedBox(height: 16),
              const Divider(thickness: .6),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: ()  async {

    final result = await Get.to(() => EditComplaintPage(complaint: complaint));


    if (result == true) {
      final homeController = Get.find<HomeController>();
      await homeController.fetchComplaints();
    }
  },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text("تعديل", style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "تأكيد الحذف",
                        middleText: "هل أنت متأكد من حذف هذه الشكوى؟",
                        textConfirm: "نعم", textCancel: "إلغاء",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.find<HomeController>().deleteComplaint(complaint.id);
                          Get.back();
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text("حذف", style: TextStyle(color: Colors.red)),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }











  
}
