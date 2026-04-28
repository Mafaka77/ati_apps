import 'package:get/get.dart';
import 'package:training_apps/models/faq_model.dart';
import 'package:training_apps/services/faq_services.dart';

class FaqController extends GetxController {
  FaqServices services = Get.find(tag: 'faqServices');
  var faqs = <FaqModel>[].obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var limit = 10.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getFaqs();
    super.onInit();
  }

  Future getFaqs() async {
    isLoading.value = true;
    try {
      var response = await services.getFaqs(offset.value, limit.value);
      faqs.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }
}
