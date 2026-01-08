import 'package:buyro_app/Model/complaint_model.dart';
import 'package:buyro_app/controller/home/home_controller.dart';
import 'package:buyro_app/core/constant/color.dart';
import 'package:buyro_app/view/screen/home/ComplaintDetailsPage.dart';
import 'package:buyro_app/view/screen/home/edit_complaint_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Get.to(() => ComplaintDetailsPage(complaintId: complaint.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.12),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6, color: AppColor.primaryColor),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 16, 8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                complaint.type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            const Spacer(),
                            
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Text(
                                complaint.status,
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.grey),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  final result = await Get.to(() => EditComplaintPage(complaint: complaint));
                                  if (result == true) Get.find<HomeController>().fetchComplaints();
                                } else if (value == 'delete') {
                                  Get.defaultDialog(
                                    title: "تأكيد الحذف",
                                    middleText: "هل أنت متأكد من حذف هذه الشكوى؟",
                                    textConfirm: "نعم",
                                    textCancel: "إلغاء",
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.red,
                                    onConfirm: () {
                                      Get.find<HomeController>().deleteComplaint(complaint.id);
                                      Get.back();
                                    },
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Text("تعديل", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      SizedBox(width: 12),
                                      Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Text("حذف", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      SizedBox(width: 12),
                                      Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // الفاصل
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(height: 1, thickness: 1.2, color: Colors.grey.shade100),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Text(
                          complaint.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade800,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      if (complaint.location != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border(top: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_rounded, size: 16, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  complaint.location!.place,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueGrey.shade900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}