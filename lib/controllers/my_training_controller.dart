import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/models/enrollments_model.dart';
import 'package:training_apps/services/my_training_services.dart';

class MyTrainingController extends GetxController {
  MyTrainingServices services = Get.find(tag: 'myTrainingServices');
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  var myEnrollments = <EnrollmentsModel>[].obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var limit = 10.obs;
  var search = ''.obs;
  final RxBool isSearchVisible = false.obs;
  final TextEditingController searchEditingController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    getMyTraining();
    super.onInit();
  }

  Future getMyTraining() async {
    isLoading.value = true;
    try {
      var response = await services.myEnrollments(
        offset.value,
        limit.value,
        search.value,
      );
      myEnrollments.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }

  // Pull down to refresh (Reset everything)
  Future<void> onRefresh() async {
    offset.value = 0; // Reset offset to 0
    try {
      var response = await services.myEnrollments(
        offset.value,
        limit.value,
        search.value,
      );

      myEnrollments.assignAll(response); // Overwrite list
      refreshController.refreshCompleted();

      // If the response is smaller than the limit, there's no more data to load
      if (response.length < limit.value) {
        refreshController.loadNoData();
      } else {
        // Reset loadState in case it was previously 'noData'
        refreshController.resetNoData();
      }
    } catch (ex) {
      refreshController.refreshFailed();
    }
  }

  // Pull up to load more
  Future<void> onLoadMore() async {
    offset.value += limit.value; // Increment offset

    try {
      var response = await services.myEnrollments(
        offset.value,
        limit.value,
        search.value,
      );

      if (response.isEmpty) {
        refreshController.loadNoData();
      } else {
        myEnrollments.addAll(response); // Append to existing list
        refreshController.loadComplete();

        // Check if this was the last batch of data
        if (response.length < limit.value) {
          refreshController.loadNoData();
        }
      }
    } catch (ex) {
      refreshController.loadFailed();
      offset.value -= limit.value; // Roll back the offset if the API call fails
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
