import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/models/training_course_model.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class TrainingDetailServices extends GetxService {
  final base = Get.find<BaseService>();
  // Enrollment detail caching (per-ID) -----------------------------------------

  // Storage keys (changed from banner keys)
  static const String _kTDetailCacheKey =
      't_detail_cache_v1'; // Map<String, Map>
  static const String _kTDetailTsKey =
      't_detail_cache_v1_ts'; // Map<String, String ISO>
  static const Duration _ttl = Duration(minutes: 10);

  // In-memory caches
  final Map<String, TrainingProgramModel> _cacheTDetail = {};
  final Map<String, DateTime> _cacheTs = {};

  bool _isFresh(DateTime? ts) =>
      ts != null && DateTime.now().difference(ts) < _ttl;

  // Call this once at startup (optional) to hydrate from GetStorage
  Future<void> initEnrollmentCache() async {
    final rawMap = storage.read<Map>(_kTDetailCacheKey);
    final rawTs = storage.read<Map>(_kTDetailTsKey);

    if (rawMap != null) {
      _cacheTDetail.clear();
      rawMap.forEach((key, value) {
        try {
          _cacheTDetail[key as String] = TrainingProgramModel.fromMap(
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
      for (final e in _cacheTDetail.entries) e.key: e.value.toMap(),
    };
    // serialize timestamps: id -> isoString
    final Map<String, String> ts = {
      for (final t in _cacheTs.entries) t.key: t.value.toIso8601String(),
    };

    await storage.write(_kTDetailCacheKey, data);
    await storage.write(_kTDetailTsKey, ts);
  }

  Future<void> invalidateEnrollmentCache() async {
    _cacheTDetail.clear();
    _cacheTs.clear();
    await storage.remove(_kTDetailCacheKey);
    await storage.remove(_kTDetailTsKey);
  }

  Future<TrainingProgramModel> getTrainingDetail(
    String id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cacheTDetail.containsKey(id) &&
        _isFresh(_cacheTs[id])) {
      return _cacheTDetail[id]!;
    }

    try {
      final response = await base.client.get(Routes.TRAINING(id));
      print(response);
      final model = TrainingProgramModel.fromMap(response.data['training']);
      _cacheTDetail[id] = model;
      _cacheTs[id] = DateTime.now();
      await _persistEnrollment();
      return model;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future enroll(String id) async {
    try {
      var response = await base.client.post(Routes.ENROLL(id));
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<TrainingCourseModel>> getCourseByTrainingId(String id) async {
    try {
      var response = await base.client.get(Routes.GET_COURSE_BY_PROGRAM(id));
      return TrainingCourseModel.fromJsonList(response.data['data']);
    } catch (ex) {
      print(ex);
      return Future.error(ex);
    }
  }
}
