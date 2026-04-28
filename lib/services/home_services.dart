import 'package:get/get.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/models/banner_model.dart';
import 'package:training_apps/models/faq_model.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class HomeServices extends GetxService {
  final base = Get.find<BaseService>();
  //BANNER CACHE
  static const String _cacheKey = 'banners_cache_v1';
  static const String _cacheTsKey = 'banners_cache_v1_ts';
  static const Duration _ttl = Duration(minutes: 10);
  List<BannerModel>? _cacheBanner;
  DateTime? _cacheTs;

  //UPCOMINGS
  static const String _upcomingCacheKey = 'upcoming_cache_key';
  static const String _upcomingTsKey = 'upcoming_cache_ts';
  List<TrainingProgramModel>? _cacheUpcoming;

  //FAQS
  static const String _faqCacheKey = 'faq_cache_key';
  static const String _faqTsKey = 'faq_cache_ts';
  List<FaqModel>? _cacheFaq;

  /// Initialize service (load persisted cache if any)
  Future<HomeServices> init() async {
    final rawList = storage.read<List>(_cacheKey);
    final tsString = storage.read<String>(_cacheTsKey);
    final upcomingList = storage.read<List>((_upcomingCacheKey));
    final upcomingTsString = storage.read<String>((_upcomingTsKey));
    final faqList = storage.read<List>((_faqCacheKey));
    final faqTsString = storage.read<String>((_faqTsKey));

    if (rawList != null && tsString != null) {
      try {
        _cacheBanner = rawList
            .cast<Map>()
            .map((e) => BannerModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        _cacheTs = DateTime.tryParse(tsString);
        _cacheUpcoming = upcomingList!
            .cast<Map>()
            .map(
              (e) => TrainingProgramModel.fromMap(Map<String, dynamic>.from(e)),
            )
            .toList();
        _cacheTs = DateTime.tryParse(upcomingTsString.toString());
        _cacheFaq = faqList!
            .cast<Map>()
            .map((e) => FaqModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        _cacheTs = DateTime.tryParse(faqTsString.toString());
      } catch (_) {
        _cacheBanner = null;
        _cacheTs = null;
        _cacheUpcoming = null;
        _cacheFaq = null;
      }
    }
    return this;
  }

  bool _isFresh(DateTime? ts) =>
      ts != null && DateTime.now().difference(ts) < _ttl;

  Future<void> _persistBanner(List<BannerModel> banners) async {
    await storage.write(_cacheKey, banners.map((b) => b.toMap()).toList());
    await storage.write(_cacheTsKey, DateTime.now().toIso8601String());
  }

  Future<void> _persistUpcoming(List<TrainingProgramModel> training) async {
    await storage.write(
      _upcomingCacheKey,
      training.map((b) => b.toMap()).toList(),
    );
    await storage.write(_upcomingTsKey, DateTime.now().toIso8601String());
  }

  Future<void> _persistFaq(List<FaqModel> faq) async {
    await storage.write(_faqCacheKey, faq.map((b) => b.toMap()).toList());
    await storage.write(_faqTsKey, DateTime.now().toIso8601String());
  }

  Future<void> invalidateCache() async {
    _cacheBanner = null;
    _cacheTs = null;
    await storage.remove(_cacheKey);
    await storage.remove(_cacheTsKey);
    await storage.remove(_upcomingCacheKey);
    await storage.remove(_upcomingTsKey);
    await storage.remove(_faqCacheKey);
    await storage.remove(_faqTsKey);
  }

  Future<List<BannerModel>> getBanners({bool forceRefresh = false}) async {
    if (!forceRefresh && _cacheBanner != null && _isFresh(_cacheTs)) {
      return _cacheBanner!;
    }
    try {
      var response = await base.client.get(Routes.BANNER);
      final List rawList = response.data is Map
          ? response.data['banners'] as List
          : response.data as List;
      final banners = BannerModel.fromJsonList(rawList);
      _cacheBanner = banners;
      _cacheTs = DateTime.now();
      await _persistBanner(banners);
      return banners;
    } catch (ex) {
      // fallback to cache if available
      if (_cacheBanner != null) return _cacheBanner!;

      return Future.error(ex);
    }
  }

  Future<List<TrainingProgramModel>> getUpcoming({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cacheUpcoming != null && _isFresh(_cacheTs)) {
      return _cacheUpcoming!;
    }
    try {
      var response = await base.client.get(Routes.UPCOMING);
      final List rawList = response.data is Map
          ? response.data['trainings'] as List
          : response.data as List;
      final trainings = TrainingProgramModel.fromJsonList(rawList);

      _cacheUpcoming = trainings;
      _cacheTs = DateTime.now();
      await _persistUpcoming(trainings);
      return trainings;
      // return TrainingProgramModel.fromJsonList(response.data['trainings']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<TrainingProgramModel>> getAllTrainings() async {
    try {
      var response = await base.client.get(Routes.TRAININGS);
      return TrainingProgramModel.fromJsonList(response.data['trainings']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<FaqModel>> getFaq({bool forceRefresh = false}) async {
    if (!forceRefresh && _cacheFaq != null && _isFresh(_cacheTs)) {
      return _cacheFaq!;
    }
    try {
      var response = await base.client.get(
        Routes.FAQ,
        queryParameters: {'offset': 0, 'limi': 5},
      );
      final List rawList = response.data is Map
          ? response.data['faq'] as List
          : response.data as List;
      final faq = FaqModel.fromJsonList(rawList);
      _cacheFaq = faq;
      _cacheTs = DateTime.now();
      await _persistFaq(faq);
      return faq;
      // return FaqModel.fromJsonList(response.data['faq']);
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
