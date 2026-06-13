import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/document_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';

class DocumentScreen extends StatelessWidget {
  DocumentScreen({super.key});
  final controller = Get.find<DocumentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0),
          child: appBarBackButton(context), // Floating circular back button
        ),
        title: const Text(
          "Notice Board",
          style: TextStyle(
            fontFamily: 'SN Pro',
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }

        if (controller.documents.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: controller.documents.length,
          itemBuilder: (context, index) {
            final data = controller.documents[index];
            return _buildDocumentCard(context, data);
          },
        );
      }),
    );
  }

  Widget _buildDocumentCard(BuildContext context, var data) {
    final String fileUrl = Routes.IMAGE_URL + (data.fileUrl ?? '');
    final String fileName = data.fileUrl?.split('/').last ?? 'document.pdf';
    print(fileUrl);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Slate-200
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (data.fileUrl != null && data.fileUrl!.isNotEmpty) {
              if (controller.downloadedPaths.containsKey(fileUrl)) {
                controller.openFile(fileUrl);
              } else {
                controller.downloadAndViewFile(fileUrl, fileName);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Emerald Colored Document Icon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5), // emerald-50
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    size: 22,
                    color: Color(0xFF059669), // emerald-600
                  ),
                ),
                const SizedBox(width: 16),

                // Notice Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title ?? 'Official Notice',
                        style: const TextStyle(
                          fontFamily: 'SN Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.description ?? 'No description provided.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Download/Open Interactive Action Box
                Obx(() {
                  final isDownloading = controller.downloadProgresses
                      .containsKey(fileUrl);
                  final isDownloaded = controller.downloadedPaths.containsKey(
                    fileUrl,
                  );

                  if (isDownloading) {
                    final double progress =
                        controller.downloadProgresses[fileUrl] ?? 0.0;
                    return SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: progress > 0 ? progress : null,
                        strokeWidth: 2.5,
                        color: const Color(0xFF059669),
                      ),
                    );
                  }

                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDownloaded
                          ? const Color(0xFFE8F5E9) // Light Green
                          : const Color(0xFFF1F5F9), // Slate-100
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDownloaded
                          ? Icons.folder_open_rounded
                          : Icons.file_download_outlined,
                      size: 18,
                      color: isDownloaded
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF475569),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_off_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Notices Found",
              style: TextStyle(
                fontFamily: 'SN Pro',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Important announcements, official guidelines, and training notices will be shown here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
