import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:open_file/open_file.dart';
import 'package:buyro_app/constants.dart';
import 'package:buyro_app/core/constant/color.dart';

class AttachmentViewerPage extends StatelessWidget {
  final int fileId;
  final String mimeType;
  final String fileName;
  final String token;

  const AttachmentViewerPage({
    super.key,
    required this.fileId,
    required this.mimeType,
    required this.fileName,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final url = "${baseURL}attachments/show/$fileId";

    //  تحديد نوع الملف
    if (mimeType == "application/pdf") {
      return Scaffold(
        appBar: AppBar(
          title: Text("عرض ملف PDF", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.primaryColor,
        ),
        body: SfPdfViewer.network(
          url,
          headers: {"Authorization": "Bearer $token"},
        ),
      );
    }

    //  إذا كان الملف صورة
    if (mimeType.startsWith("image/")) {
      return Scaffold(
        appBar: AppBar(
          title: Text("عرض صورة", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.primaryColor,
        ),
        body: Center(
          child: Image.network(
            url,
            headers: {"Authorization": "Bearer $token"},
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    //  باقي الأنواع (word - txt - zip - ... )
    return Scaffold(
      appBar: AppBar(
        title: Text("فتح ملف", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          ),
          onPressed: () async {
            await _downloadAndOpenFile(url);
          },
          icon: Icon(Icons.open_in_new, color: Colors.white),
          label: Text("فتح الملف", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // -----------------------------
  //  تنزيل الملف + فتحه خارجياً
  // -----------------------------
  Future<void> _downloadAndOpenFile(String url) async {
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
