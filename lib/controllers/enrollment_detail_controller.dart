import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/models/enrollment_detail_model.dart';
import 'package:training_apps/models/material_model.dart';
import 'package:training_apps/models/training_course_model.dart';
import 'package:training_apps/services/enrollment_detail_services.dart';

class EnrollmentDetailController extends GetxController {
  EnrollmentDetailServices services = Get.find(tag: 'enrollmentDetailServices');
  var isSelectedIndex = 0.obs;
  late final String enrollmentId;
  var enrollmentDetail = <EnrollmentDetailModel>{}.obs;
  var isLoading = false.obs;
  var trainingCourse = <TrainingCourseModel>[].obs;
  var groupedCourses = <String, List<TrainingCourseModel>>{}.obs;
  var materials = <MaterialModel>[].obs;
  var sessionsList = [].obs;
  var totalSessions = 0.obs;
  var attendedCount = 0.obs;
  var percentage = 0.obs;
  var groupedSessions = <String, List>{}.obs;
  //MAPS
  final isMapReady = false.obs;
  final isLoadingLocation = false.obs;
  final mapError = RxnString();
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  final initialPosition = const LatLng(0, 0).obs;
  final initialZoom = 16.0.obs;
  var address = ''.obs;
  var error = ''.obs;
  var certificate = {}.obs;
  var releaseOrder = {}.obs;
  var downloadProgresses = <String, double>{}.obs;
  var downloadedPaths = <String, String>{}.obs;

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  void onInit() {
    _handleLocationPermission();
    enrollmentId = Get.parameters['enrollmentId'] ?? '';
    enrollmentDetails();
    super.onInit();
  }

  Future enrollmentDetails() async {
    isLoading.value = true;
    try {
      var response = await services.enrollmentDetails(enrollmentId);
      enrollmentDetail.assignAll({response});
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
      print(ex);
    }
  }

  Future refreshEnrollmentDetails() async {
    await enrollmentDetails();
    refreshController.refreshCompleted();
    print(enrollmentDetail.first);
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

      final formatter = DateFormat('dd MMM yyyy');
      final Map<String, List<TrainingCourseModel>> grouped = {};

      response.sort((a, b) {
        final timeA = a.tc_start_time.split(':');
        final dtA = DateTime(
          a.tc_date.year,
          a.tc_date.month,
          a.tc_date.day,
          int.parse(timeA[0]),
          int.parse(timeA[1]),
        );

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

      for (var course in response) {
        final dateKey = formatter.format(course.tc_date.toLocal());

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(course);
      }
      trainingCourse.assignAll(response);
      groupedCourses.value = grouped;
      onSuccess();
    } catch (ex) {
      print("Error in getCourseByTrainingId: $ex");
      onError();
    }
  }

  // Future getMySessionAttendance(
  //   String id,
  //   Function onLoading,
  //   Function onSuccess,
  //   Function onError,
  // ) async {
  //   try {
  //     onLoading();
  //     var response = await services.getSessionAttendance(id);

  //     if (response != null && response['success'] == true) {
  //       totalSessions.value = response['totalSessions'] ?? 0;
  //       attendedCount.value = response['attendedCount'] ?? 0;
  //       percentage.value = response['percentage'] ?? 0;

  //       if (response['sessions'] != null) {
  //         List sessions = response['sessions'];

  //         // 1. Sort sessions by time first
  //         sessions.sort((a, b) {
  //           DateTime dateTimeA = DateTime.parse(
  //             "${a['date'].split('T')[0]} ${a['start_time']}",
  //           );
  //           DateTime dateTimeB = DateTime.parse(
  //             "${b['date'].split('T')[0]} ${b['start_time']}",
  //           );
  //           return dateTimeA.compareTo(dateTimeB);
  //         });

  //         // 2. Group by Date
  //         Map<String, List> tempGrouped = {};
  //         for (var session in sessions) {
  //           String dateKey = session['date'].split(
  //             'T',
  //           )[0]; // Result: "2026-02-17"
  //           if (tempGrouped[dateKey] == null) {
  //             tempGrouped[dateKey] = [];
  //           }
  //           tempGrouped[dateKey]!.add(session);
  //         }

  //         groupedSessions.value = tempGrouped;
  //       } else {
  //         groupedSessions.clear();
  //       }
  //       onSuccess();
  //     } else {
  //       onError(response?['message'] ?? "Failed to fetch attendance data");
  //     }
  //   } catch (ex) {
  //     debugPrint("Parsing Error: $ex");
  //     onError("An error occurred while parsing attendance data.");
  //   }
  // }
  var selectedDate = DateTime.now().obs;
  var filteredSessions = [].obs;

  Future getAttendanceByDate(DateTime date, String trainingId) async {
    try {
      selectedDate.value = date;
      // Format date to match your DB storage (YYYY-MM-DD)
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      var response = await services.getSessionAttendance(
        trainingId,
        formattedDate,
      );
      var statusCode =
          response.statusCode == 200 && response.data['status'] == 200;
      if (statusCode) {
        filteredSessions.assignAll(response.data['sessions'] ?? []);
        // Update summary stats if provided in the response
        percentage.value = response.data['percentage'] ?? 0;
        totalSessions.value = response.data['totalSessions'] ?? 0;
        attendedCount.value = response.data['attendedCount'] ?? 0;
        percentage.value = response.data['percentage'] ?? 0;
        return {'success': true, 'message': 'Success'};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger alert: Location services are disabled.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    _setInitialPosition();
    return true;
  }

  Future<void> _setInitialPosition() async {
    isLoadingLocation.value = true;
    try {
      final pos = await getCurrentLocation();
      if (pos != null) {
        initialPosition.value = LatLng(pos.latitude, pos.longitude);
      }
    } catch (e) {
      error.value = 'Failed to get location: $e';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<Position?> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      error.value = 'Location services disabled';
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      error.value = 'Location permission denied';
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future markAttendance(String sessionId, String programId) async {
    try {
      var lat = initialPosition.value.latitude;
      var lng = initialPosition.value.longitude;
      print(lat);
      var response = await services.markAttendane(
        sessionId,
        programId,
        lat,
        lng,
      );
      var statusCode =
          response.statusCode == 200 && response.data['status'] == 200;
      if (statusCode) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex};
    }
  }

  Future getMaterials(String trainingId) async {
    try {
      var response = await services.getMaterials(trainingId);
      print(response);
      materials.assignAll(response);
      return {'success': true, 'message': 'Success'};
    } catch (ex) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future checkEvaluationStatus(String trainingId) async {
    try {
      var response = await services.checkEvaluationStatus(trainingId);
      if (response.statusCode == 200 && response.data['status'] == 200) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex};
    }
  }

  Future getCertificateAndReleaseOrder(String trainingId) async {
    try {
      var response = await services.getCertificateAndReleaseOrder(trainingId);
      if (response.statusCode == 200 && response.data['status'] == 200) {
        certificate.value = response.data['certificate'] ?? {};
        releaseOrder.value = response.data['releaseOrder'] ?? {};
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex};
    }
  }

  Future<void> downloadAndViewFile(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/$fileName';

      // 2. Check if file already exists!
      // If it does, we don't need to download it again, just open it.
      if (File(savePath).existsSync()) {
        downloadedPaths[url] = savePath;
        OpenFile.open(savePath);
        return;
      }

      // 3. Start Download
      downloadProgresses[url] = 0.0; // Initialize progress
      Dio dio = Dio();

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            downloadProgresses[url] = receivedBytes / totalBytes;
          }
        },
      );

      // 4. Download Complete
      downloadProgresses.remove(url); // Remove from progress map
      downloadedPaths[url] = savePath; // Add to downloaded map

      // Automatically open the file once downloaded
      OpenFile.open(savePath);
    } catch (e) {
      downloadProgresses.remove(url);
      print("Download error: $e");
      Get.snackbar('Error', 'Failed to download file.');
    }
  }

  void openFile(String url) {
    String? localPath = downloadedPaths[url];
    if (localPath != null && File(localPath).existsSync()) {
      OpenFile.open(localPath);
    }
  }
}
