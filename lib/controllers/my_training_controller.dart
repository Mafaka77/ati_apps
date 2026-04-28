import 'package:get/get.dart';
import 'package:training_apps/models/enrollments_model.dart';
import 'package:training_apps/services/my_training_services.dart';

class MyTrainingController extends GetxController {
  MyTrainingServices services = Get.find(tag: 'myTrainingServices');

  var myEnrollments = <EnrollmentsModel>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getMyTraining();
    super.onInit();
  }

  Future getMyTraining() async {
    isLoading.value = true;
    try {
      var response = await services.myEnrollments();
      myEnrollments.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }

  Future checkStatus(String id) async {
    try {
      var response = await services.checkStatus(id);
      var status = response.statusCode == 200 && response.data['status'] == 200;
      if (status) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex.toString()};
    }
  }
}
