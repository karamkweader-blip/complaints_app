import 'package:buyro_app/controller/home/complaint_details_controller.dart';
import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
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
        return Scaffold(
          backgroundColor: AppColor.backgroundcolor,
          appBar: AppBar(
            title: Text(
              "تفاصيل الشكوى",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColor.primaryColor,
          ),
          
          body: controller!.isLoading
              ? Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
              : controller.complaint == null
                  ? Center(child: Text("لا توجد بيانات"))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoRow("رقم الشكوى:", controller.complaint!["id"].toString()),
                              infoRow("المرجع:", controller.complaint!["reference_number"]),
                              infoRow("النوع:", controller.complaint!["type"]),
                              infoRow("الوصف:", controller.complaint!["description"]),
                              infoRow("الحالة:", controller.complaint!["status"]),
                              infoRow("التاريخ:", controller.complaint!["created_at"]),
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
