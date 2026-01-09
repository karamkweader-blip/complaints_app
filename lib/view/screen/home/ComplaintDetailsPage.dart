import 'dart:io';
import 'package:buyro_app/constants.dart';
import 'package:buyro_app/controller/home/complaint_details_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/widget/app/custom_info_row.dart';
import 'package:buyro_app/view/widget/app/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final int complaintId;

  const ComplaintDetailsPage({super.key, required this.complaintId});

// دالة لحساب حجم الخط المتجاوب
  double getResponsiveFontSize(double baseSize) {
    double width = Get.width;
    if (width > 600) { // Tablet
      return baseSize * 1.2;
    } else if (width > 400) { // Mobile كبير
      return baseSize;
    } else { // Mobile صغير
      return baseSize * 0.9;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintDetailsController>(
      init: ComplaintDetailsController(complaintId),
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FD),
            body: Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            ),
          );
        }

        final data = controller.complaint;

        if (data == null) {
          return const Scaffold(body: Center(child: Text("لا توجد بيانات")));
        }

        final attachments = data["attachments"] as List<dynamic>?;

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
                "تفاصيل الشكوى",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              foregroundColor: Colors.white,
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SectionCardWidget(
                title: "بيانات الشكوى",
                icon: Icons.assignment_outlined,
                children: [
                  CustomInfoRow(
                    title: "رقم الشكوى",
                    value: data["id"].toString(),
                    icon: Icons.numbers_rounded,
                  ),
                  CustomInfoRow(
                    title: "المرجع",
                    value: data["reference_number"] ?? "لا يوجد",
                    icon: Icons.fingerprint_rounded,
                  ),
                  CustomInfoRow(
                    title: "النوع",
                    value: data["type"] ?? "",
                    icon: Icons.category_outlined,
                  ),
                  CustomInfoRow(
                    title: "الوصف",
                    value: data["description"] ?? "",
                    icon: Icons.description_outlined,
                  ),
                  CustomInfoRow(
                    title: "الحالة",
                    value: data["status"] ?? "",
                    icon: Icons.hourglass_bottom_rounded,
                  ),
                  CustomInfoRow(
                    title: "التاريخ",
                    value: _formatDate(data["created_at"]),
                    icon: Icons.calendar_month_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (attachments != null && attachments.isNotEmpty)
                SectionCardWidget(
                  title: "المرفقات",
                  icon: Icons.attach_file_rounded,
                  children: attachments.map((file) {
                    final mime = file["mime_type"] ?? "";
                    final url = "${baseURL}attachments/show/${file["id"]}";
                    final fileName = file["file_name"] ?? "";

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
                            headers: {
                              "Authorization": "Bearer ${controller.token}",
                            },
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file_outlined, color: AppColor.primaryColor),
                        title: Text(
                          fileName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility_outlined, color: AppColor.primaryColor),
                          onPressed: () async {
                            await _downloadAndOpenFile(url, fileName, controller.token!);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _downloadAndOpenFile(String url, String fileName, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/$fileName");
      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(file.path);
    } catch (e) {
      Get.snackbar("خطأ", "لا يمكن فتح الملف: $e");
    }
  }
}
String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "غير محدد";
  
  try {
  
    DateTime dateTime = DateTime.parse(dateStr).toLocal(); 
    
  
    String date = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    
    
    String time = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    
    return "$date | $time";
  } catch (e) {
    return dateStr; 
  }
}