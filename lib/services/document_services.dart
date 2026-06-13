import 'package:get/get.dart';
import 'package:training_apps/models/document_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class DocumentServices extends GetxService {
  final base = Get.find<BaseService>();

  Future<List<DocumentModel>> getDocuments() async {
    try {
      var response = await base.client.get(Routes.GET_DOCUMENTS);
      if (response.statusCode == 200) {
        var data = response.data['documents'];
        return DocumentModel.fromJsonList(data);
      } else {
        return Future.error('Failed to load documents');
      }
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
