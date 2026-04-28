import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/helpers/file_type_helper.dart';
import 'package:training_apps/models/material_model.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';

class EnrollmentMaterialWidget extends GetView<EnrollmentDetailController> {
  const EnrollmentMaterialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Obx(() {
        if (controller.materials.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // A soft-colored icon container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Ionicons.document_text_outline,
                    size: 64,
                    color: Colors.blue.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 20),
                // Structured Text
                const Text(
                  "No Materials Found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "There are currently no learning materials uploaded for this course. Please check back later.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Added to prevent scrolling conflicts if inside a SingleChildScrollView
          itemCount: controller.materials.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final material = controller.materials[index];
            return _buildMaterialCard(material);
          },
        );
      }),
    );
  }

  // Extracted Component for better readability
  Widget _buildMaterialCard(MaterialModel material) {
    final String url = '${Routes.IMAGE_URL}${material.file_url}';
    print("Material URL: $url"); // Debugging log
    final String fileName = '${material.title}.pdf';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: material.mime_type.toFileColor.withOpacity(0.1),
          child: Icon(
            material.mime_type.toFileIcon,
            color: material.mime_type.toFileColor,
          ),
        ),
        title: Text(
          material.title ?? 'Untitled Document',
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          material.mime_type.toFileLabel,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),

        // Dynamic Trailing Widget for Download/Progress/View
        trailing: Obx(() {
          // STATE 1: Downloading (Show Progress Indicator)
          if (controller.downloadProgresses.containsKey(url)) {
            double progress = controller.downloadProgresses[url]!;
            return SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade200,
                    color: material
                        .mime_type
                        .toFileColor, // Matches the file type color!
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

          // STATE 2: Downloaded (Show View Button)
          if (controller.downloadedPaths.containsKey(url)) {
            return CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1),
              child: IconButton(
                icon: const Icon(
                  Ionicons.eye_outline,
                  color: Colors.green,
                  size: 20,
                ),
                onPressed: () => controller.openFile(url),
                tooltip: "View File",
              ),
            );
          }

          // STATE 3: Not Downloaded (Show Download Button)
          return CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: IconButton(
              icon: const Icon(
                Ionicons.cloud_download_outline,
                color: Colors.blue,
                size: 20,
              ),
              onPressed: () {
                if (url.isNotEmpty) {
                  controller.downloadAndViewFile(url, fileName);
                } else {
                  Get.snackbar(
                    "Error",
                    "File URL is missing or invalid.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              tooltip: "Download File",
            ),
          );
        }),
      ),
    );
  }
}
