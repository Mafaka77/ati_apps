import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // Added intl import
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';

class EnrollmentCertificateWidget extends GetView<EnrollmentDetailController> {
  const EnrollmentCertificateWidget({super.key});

  // Helper method to beautifully format the date string
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown date';
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      // Formats to: "Oct 25, 2023 • 10:30 AM"
      return DateFormat('MMM dd, yyyy • hh:mm a').format(parsedDate);
    } catch (e) {
      return dateString; // Fallback to raw string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            const Text(
              "Office Order & Certificates",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Download your official release orders and completion certificates here.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),

            // Release Order Section
            Obx(
              () => _buildDocumentCard(
                sectionTitle: 'Release Order',
                data: controller.releaseOrder,
                url: controller.releaseOrder.isNotEmpty
                    ? '${Routes.IMAGE_URL}${controller.releaseOrder['release_order_url']}'
                    : '',
                emptyMessage: 'Release order is not available yet.',
                icon: Icons.local_post_office_rounded,
                themeColor: const Color(0xFFE68A00), // Elegant Amber/Orange
              ),
            ),

            const SizedBox(height: 10),

            // Certificate Section
            Obx(
              () => _buildDocumentCard(
                sectionTitle: 'Completion Certificate',
                data: controller.certificate,
                url: controller.certificate.isNotEmpty
                    ? '${Routes.IMAGE_URL}${controller.certificate['certificate_url']}'
                    : '',
                emptyMessage: 'Certificate will be available upon completion.',
                icon: Icons.card_membership_rounded,
                themeColor: const Color(0xFF059669), // Elegant Emerald Green
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // A highly aesthetic, reusable widget for displaying documents
  Widget _buildDocumentCard({
    required String sectionTitle,
    required Map<dynamic, dynamic> data,
    required String url,
    required String emptyMessage,
    required IconData icon,
    required Color themeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: data.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      emptyMessage,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Beautiful Soft-Tinted Icon Container
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: themeColor, size: 26),
                      ),
                      const SizedBox(width: 16),

                      // File Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['file_name'] ?? 'Unknown Document',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(data['createdAt']),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Obx(() {
                        final fileName = data['file_name'] ?? 'document.pdf';

                        // State 1: DOWNLOADING (Show Progress)
                        if (controller.downloadProgresses.containsKey(url)) {
                          double progress = controller.downloadProgresses[url]!;
                          return SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.grey.shade200,
                                  color: themeColor,
                                ),
                                Text(
                                  "${(progress * 100).toInt()}%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // State 2: DOWNLOADED (Show View Button)
                        if (controller.downloadedPaths.containsKey(url)) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.openFile(url),
                              child: CircleAvatar(
                                backgroundColor: themeColor.withOpacity(0.1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      color: themeColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // State 3: NOT DOWNLOADED YET (Show Download Button)
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (url.isNotEmpty) {
                                controller.downloadAndViewFile(url, fileName);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.file_download_outlined,
                                color: Colors.black87,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void downloadFile(String url) {
    print("Downloading file from URL: $url");
  }
}
