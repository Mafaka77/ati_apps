import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:training_apps/models/banner_model.dart';
import 'package:training_apps/models/faq_model.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/services/home_services.dart';

class HomeController extends GetxController {
  HomeServices services = Get.find(tag: 'homeServices');
  var carouselData = <BannerModel>[].obs;
  var upcomingTrainings = <TrainingProgramModel>[].obs;
  var faqs = <FaqModel>[].obs;
  var isFaqLoading = false.obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    loadAll();
    super.onInit();
  }

  Future<void> loadAll({bool force = false}) async {
    try {
      isLoading.value = true;
      await getBanner(force: force);
      await getUpcomingTraining(force: force);
      await getFaq(force: force);
      update();
    } catch (ex) {
      isLoading.value = false;
      update();
    }
  }

  Future<void> refreshAll() async => loadAll(force: true);
  Future<void> getBanner({bool force = false}) async {
    try {
      var response = await services.getBanners(forceRefresh: force);
      carouselData.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      print(ex);
    }
  }

  Future getUpcomingTraining({bool force = false}) async {
    try {
      var response = await services.getUpcoming(forceRefresh: force);
      print(response);
      upcomingTrainings.assignAll(response);
    } catch (ex) {
      print(ex);
    }
  }

  Future getFaq({bool force = false}) async {
    isFaqLoading.value = true;
    faqs.clear();
    try {
      var response = await services.getFaq(forceRefresh: force);
      faqs.assignAll(response);
      isFaqLoading.value = false;
    } catch (ex) {
      isFaqLoading.value = false;
    }
  }
}
