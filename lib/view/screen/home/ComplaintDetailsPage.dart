import 'dart:io';

import 'package:buyro_app/constants.dart';
import 'package:buyro_app/controller/home/complaint_details_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/screen/home/AttachmentViewerPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

        //  قراءة أول ملف مرفق
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
              child: SingleChildScrollView(
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
                
                // ==============================
                if (attachments != null && attachments.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text("المرفقات:", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                
                  ...attachments.map((file) {
                    final mime = file["mime_type"] ?? "";
                    final url = "${baseURL}attachments/show/${file["id"]}";
                
                    /// **********  أولاً: إذا كانت صورة -> نعرضها فوراً **********
final fileName = file["file_name"] ?? "";

// نتحقق إذا هو صورة عبر mimeType أو امتداد
bool isImage = mime.startsWith("image/") ||
    fileName.toLowerCase().endsWith(".png") ||
    fileName.toLowerCase().endsWith(".jpg") ||
    fileName.toLowerCase().endsWith(".jpeg");

if (isImage) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        headers: {"Authorization": "Bearer ${controller.token}"},
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

                    /// **********  ثانيًا: إذا كان PDF أو WORD او ZIP → يظهر اسمه فقط **********
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.attach_file, color: Colors.black),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(file["file_name"], style: TextStyle(fontSize: 15)),
                          ),
                
               IconButton(
  icon: Icon(Icons.visibility, color: AppColor.primaryColor),
  onPressed: () async {
    await _downloadAndOpenFile(url, file["file_name"]);
  },
)


                        ],
                      ),
                    );
                  }).toList(),
                ]
                
                    
                  
                
                    ],
                  ),
                ),
              ),
            ),
          ),
       
       
       
       
       
       
        );
      },
    );
  }

Future<void> _downloadAndOpenFile(String url, String fileName) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${Get.find<ComplaintDetailsController>().token}"},
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(response.bodyBytes);

    await OpenFile.open(file.path);
  } catch (e) {
    Get.snackbar("خطأ", "لا يمكن فتح الملف: $e");
  }
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
