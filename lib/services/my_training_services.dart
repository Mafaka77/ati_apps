import 'package:get/get.dart';
import 'package:training_apps/models/enrollments_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class MyTrainingServices extends GetxService {
  final base = Get.find<BaseService>();
  Future<List<EnrollmentsModel>> myEnrollments(
    int offset,
    int limit,
    String search,
  ) async {
    try {
      var response = await base.client.get(
        Routes.ENROLLMENTS,
        queryParameters: {'offset': offset, 'limit': limit, 'search': search},
      );
      print(response.data);
      return EnrollmentsModel.fromJsonList(response.data['enrollments']);
    } catch (ex) {
      print(ex);
      return Future.error(ex);
    }
  }

  Future checkStatus(String id) async {
    try {
      var response = await base.client.get(Routes.CHECK_ENROLLMENT_STATUS(id));
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
