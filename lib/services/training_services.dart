import 'package:get/get.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class TrainingServices extends GetxService {
  final base = Get.find<BaseService>();
  Future<List<TrainingProgramModel>> getAllTraining(
    int offset,
    int limit,
  ) async {
    try {
      var response = await base.client.get(
        Routes.TRAININGS,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        var data = response.data['programs'];
        return TrainingProgramModel.fromJsonList(data);
      }
      return [];
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
