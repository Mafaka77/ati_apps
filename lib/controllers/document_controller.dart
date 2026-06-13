import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:training_apps/models/document_model.dart';
import 'package:training_apps/services/document_services.dart';

class DocumentController extends GetxController {
  final services = Get.find<DocumentServices>(tag: 'documentServices');

  var isLoading = false.obs;
  var documents = <DocumentModel>[].obs;
  var downloadProgresses = <String, double>{}.obs;
  var downloadedPaths = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getDocuments();
  }

  void getDocuments() async {
    try {
      isLoading.value = true;
      var response = await services.getDocuments();
      documents.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }

  Future<void> downloadAndViewFile(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/$fileName';

      // If file already exists, open directly
      if (File(savePath).existsSync()) {
        downloadedPaths[url] = savePath;
        OpenFile.open(savePath);
        return;
      }

      downloadProgresses[url] = 0.0; // Initialize progress
      Dio dio = Dio();

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            downloadProgresses[url] = receivedBytes / totalBytes;
          }
        },
      );

      downloadProgresses.remove(url); // Remove from progress
      downloadedPaths[url] = savePath; // Add to downloaded paths

      // Automatically open once downloaded
      OpenFile.open(savePath);
    } catch (e) {
      downloadProgresses.remove(url);
      print("Download error: $e");
      Get.snackbar('Error', 'Failed to download file.');
    }
  }

  void openFile(String url) {
    String? localPath = downloadedPaths[url];
    if (localPath != null && File(localPath).existsSync()) {
      OpenFile.open(localPath);
    }
  }
}
