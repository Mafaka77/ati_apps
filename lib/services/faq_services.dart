import 'package:training_apps/models/faq_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class FaqServices extends BaseService {
  Future<List<FaqModel>> getFaqs(int offset, int limit) async {
    try {
      var response = await client.get(
        Routes.FAQ,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      return FaqModel.fromJsonList(response.data['faq']);
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
