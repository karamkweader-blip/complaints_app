import 'package:buyro_app/controller/home/complaint_details_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/screen/home/AttachmentViewerPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final int complaintId;

  const ComplaintDetailsPage({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintDetailsController>(
      init: ComplaintDetailsController(complaintId),
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            backgroundColor: AppColor.backgroundcolor,
            body: Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            ),
          );
        }

        final data = controller.complaint;

        if (data == null) {
          return Scaffold(
            body: Center(child: Text("لا توجد بيانات")),
          );
        }

        // ✨ قراءة أول ملف مرفق
        final attachments = data["attachments"] as List<dynamic>?;

        return Scaffold(
          backgroundColor: AppColor.backgroundcolor,
          appBar: AppBar(
            title: Text("تفاصيل الشكوى", style: TextStyle(color: Colors.white)),
            backgroundColor: AppColor.primaryColor,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow("رقم الشكوى:", data["id"].toString()),
                    infoRow("المرجع:", data["reference_number"]),
                    infoRow("النوع:", data["type"]),
                    infoRow("الوصف:", data["description"]),
                    infoRow("الحالة:", data["status"]),
                    infoRow("التاريخ:", data["created_at"]),

                    const SizedBox(height: 20),

                    // -------------------------------
                    //  زر عرض الملف المرفق
                    // -------------------------------
                   if (attachments != null && attachments.isNotEmpty)
  Center(
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        final file = attachments[0];

        Get.to(() => AttachmentViewerPage(
              fileId: file["id"],
              mimeType: file["mime_type"],
              fileName: file["file_name"],
              token: controller.token!,
        ));
      },
      icon: Icon(Icons.attach_file, color: Colors.white),
      label: Text("عرض الملف المرفق", style: TextStyle(color: Colors.white)),
    ),
  )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
