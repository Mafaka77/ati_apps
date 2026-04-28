import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/models/training_course_model.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/services/training_detail_services.dart';

class TrainingDetailController extends GetxController {
  TrainingDetailServices services = Get.find(tag: 'trainingDetailServices');
  late final String trainingId;
  var trainingDetail = <TrainingProgramModel>{}.obs;
  var trainingCourse = <TrainingCourseModel>[].obs;
  var groupedCourses = <String, List<TrainingCourseModel>>{}.obs;
  var isLoading = false.obs;
  var isSelectedIndex = 0.obs;

  @override
  void onInit() {
    trainingId = Get.parameters['trainingId'] ?? '';
    getTraining();
    super.onInit();
  }

  Future getTraining() async {
    isLoading.value = true;
    trainingDetail.clear();
    try {
      var response = await services.getTrainingDetail(trainingId);
      trainingDetail.add(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
      print(ex);
    }
  }

  Future enroll() async {
    try {
      var response = await services.enroll(trainingId);
      var statusCode =
          response.statusCode == 200 && response.data['status'] == 201;
      if (statusCode) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex.toString()};
    }
  }

  Future getCourseByTrainingId(
    String id,
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    trainingCourse.clear();
    onLoading();

    try {
      final List<TrainingCourseModel> response = await services
          .getCourseByTrainingId(id);

      if (response.isEmpty) {
        trainingCourse.assignAll([]);
        groupedCourses.clear();
        onSuccess();
        return;
      }

      // 1. Grouping and Sorting Logic
      final formatter = DateFormat('dd MMM yyyy');
      final Map<String, List<TrainingCourseModel>> grouped = {};

      // Sort the list first
      response.sort((a, b) {
        // Create full DateTime for 'a'
        final timeA = a.tc_start_time.split(':');
        final dtA = DateTime(
          a.tc_date.year,
          a.tc_date.month,
          a.tc_date.day,
          int.parse(timeA[0]),
          int.parse(timeA[1]),
        );

        // Create full DateTime for 'b'
        final timeB = b.tc_start_time.split(':');
        final dtB = DateTime(
          b.tc_date.year,
          b.tc_date.month,
          b.tc_date.day,
          int.parse(timeB[0]),
          int.parse(timeB[1]),
        );

        return dtA.compareTo(dtB);
      });

      // 2. Group by Date
      for (var course in response) {
        // Use tc_date for the header label
        final dateKey = formatter.format(course.tc_date.toLocal());

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(course);
      }

      // 3. Update Observables
      trainingCourse.assignAll(response);
      groupedCourses.value = grouped;

      onSuccess();
    } catch (ex) {
      print("Error in getCourseByTrainingId: $ex");
      onError();
    }
  }
}
