import 'package:get/get.dart';
import 'package:training_apps/models/evaluation_question_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class EvaluationServices extends GetxService {
  final base = Get.find<BaseService>();

  Future<List<EvaluationQuestionMode>> getEvaluationQuestions() async {
    try {
      final res = await base.client.get(Routes.GET_EVALUATION_QUESTIONS);
      return EvaluationQuestionMode.fromJsonList(res.data['data']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future saveEvaluation(String trainingId, Map<String, dynamic> answers) async {
    try {
      var response = await base.client.post(
        Routes.SAVE_EVALUATION,
        data: {'answers': answers, 'training_id': trainingId},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
