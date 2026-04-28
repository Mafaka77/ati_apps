import 'package:get/get.dart';
import 'package:training_apps/models/evaluation_question_model.dart';
import 'package:training_apps/services/evaluation_services.dart';

class EvaluationController extends GetxController {
  EvaluationServices services = Get.find<EvaluationServices>(
    tag: 'evaluationServices',
  );
  late final String trainingId;
  var isLoading = false.obs;
  var evaluationQuestions = <EvaluationQuestionMode>[].obs;
  var answers = <String, dynamic>{}.obs;
  @override
  void onInit() {
    trainingId = Get.parameters['trainingId'] ?? '';
    getEvaluationQuestions();
    super.onInit();
  }

  void getEvaluationQuestions() async {
    isLoading.value = true;
    try {
      var response = await services.getEvaluationQuestions();
      evaluationQuestions.addAll(response);
    } catch (ex) {
      print(ex);
    } finally {
      isLoading.value = false;
    }
  }

  void updateAnswer(String questionId, dynamic answer) {
    answers[questionId] = answer;
  }

  Future saveEvaluation() async {
    try {
      var response = await services.saveEvaluation(trainingId, answers);
      if (response.statusCode == 200 && response.data['status'] == 201) {
        return {'status': true, 'message': 'Evaluation saved successfully'};
      } else {
        return {
          'status': false,
          'message': response.data['message'] ?? 'Failed to save evaluation',
        };
      }
    } catch (ex) {
      return {'status': false, 'message': 'An error occurred: $ex'};
    }
  }
}
