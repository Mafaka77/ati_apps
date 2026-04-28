import 'package:get/get.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/models/enrollment_detail_model.dart';
import 'package:training_apps/models/material_model.dart';
import 'package:training_apps/models/training_course_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class EnrollmentDetailServices extends GetxService {
  final base = Get.find<BaseService>();
  // Enrollment detail caching (per-ID) -----------------------------------------

  // Storage keys (changed from banner keys)
  static const String _kEnrollCacheKey =
      'enrollment_cache_v1'; // Map<String, Map>
  static const String _kEnrollTsKey =
      'enrollment_cache_v1_ts'; // Map<String, String ISO>
  static const Duration _ttl = Duration(minutes: 10);

  // In-memory caches
  final Map<String, EnrollmentDetailModel> _cacheEnrollment = {};
  final Map<String, DateTime> _cacheTs = {};

  bool _isFresh(DateTime? ts) =>
      ts != null && DateTime.now().difference(ts) < _ttl;

  // Call this once at startup (optional) to hydrate from GetStorage
  Future<void> initEnrollmentCache() async {
    final rawMap = storage.read<Map>(_kEnrollCacheKey);
    final rawTs = storage.read<Map>(_kEnrollTsKey);

    if (rawMap != null) {
      _cacheEnrollment.clear();
      rawMap.forEach((key, value) {
        try {
          _cacheEnrollment[key as String] = EnrollmentDetailModel.fromMap(
            Map<String, dynamic>.from(value as Map),
          );
        } catch (_) {
          /* ignore corrupt entry */
        }
      });
    }

    if (rawTs != null) {
      _cacheTs.clear();
      rawTs.forEach((key, value) {
        final dt = DateTime.tryParse(value as String);
        if (dt != null) _cacheTs[key as String] = dt;
      });
    }
  }

  Future<void> _persistEnrollment() async {
    // serialize: id -> map
    final Map<String, Map<String, dynamic>> data = {
      for (final e in _cacheEnrollment.entries) e.key: e.value.toMap(),
    };
    // serialize timestamps: id -> isoString
    final Map<String, String> ts = {
      for (final t in _cacheTs.entries) t.key: t.value.toIso8601String(),
    };

    await storage.write(_kEnrollCacheKey, data);
    await storage.write(_kEnrollTsKey, ts);
  }

  Future<void> invalidateEnrollmentCache() async {
    _cacheEnrollment.clear();
    _cacheTs.clear();
    await storage.remove(_kEnrollCacheKey);
    await storage.remove(_kEnrollTsKey);
  }

  /// Fetch enrollment detail with per-ID cache + TTL
  Future<EnrollmentDetailModel> enrollmentDetails(String id) async {
    try {
      final res = await base.client.get(Routes.ENROLLMENT_DETAILS(id));
      return EnrollmentDetailModel.fromMap(res.data['enrollment']);
    } catch (ex) {
      print(ex);
      return Future.error(ex);
    }
  }

  Future<List<TrainingCourseModel>> getCourseByTrainingId(String id) async {
    try {
      var response = await base.client.get(Routes.GET_COURSE_BY_PROGRAM(id));
      return TrainingCourseModel.fromJsonList(response.data['data']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<MaterialModel>> getMaterials(String id) async {
    try {
      var response = await base.client.get(Routes.GET_MATERIALS(id));
      return MaterialModel.fromJsonList(response.data['materials']);
    } catch (ex) {
      print(ex);
      return Future.error(ex);
    }
  }

  Future getSessionAttendance(String id, var date) async {
    try {
      var response = await base.client.get(
        Routes.GET_ATTENDANCE(id),
        queryParameters: {'date': date},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future markAttendane(
    String sessionId,
    String programId,
    var lat,
    var lng,
  ) async {
    try {
      var response = await base.client.post(
        Routes.MARK_ATTENDANCE,
        data: {
          'sessionId': sessionId,
          'programId': programId,
          'lat': lat,
          'lng': lng,
        },
      );
      return response;
    } catch (ex) {
      print(ex);
    }
  }

  Future getCertificateAndReleaseOrder(String trainingId) async {
    try {
      var response = await base.client.get(
        Routes.CERTIFICATEANDRELEASEORDER,
        queryParameters: {'trainingId': trainingId},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future checkEvaluationStatus(String trainingId) async {
    try {
      var response = await base.client.get(
        Routes.CHECK_EVALUATION_STATUS,
        queryParameters: {'training_id': trainingId},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
