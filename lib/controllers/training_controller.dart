import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/services/training_services.dart';

class TrainingController extends GetxController {
  TrainingServices services = Get.find(tag: 'trainingServices');
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  var isSearching = false.obs;
  var searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  var allTrainings = <TrainingProgramModel>[].obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var limit = 10.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final isInitialLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    _loadFirstPage();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> _loadFirstPage() async {
    isInitialLoading.value = true;
    // fresh paging state
    offset.value = 0;
    hasMore.value = true;
    try {
      final items = await services.getAllTraining(offset.value, limit.value);
      allTrainings.assignAll(items);
      hasMore.value = items.length == limit.value;
      offset.value += items.length;

      // IMPORTANT: allow load-more again after a new first page
      refreshController.resetNoData();
    } finally {
      isInitialLoading.value = false;
    }
  }

  // Pull-to-refresh
  Future<void> onRefresh() async {
    try {
      offset.value = 0;
      hasMore.value = true;
      final items = await services.getAllTraining(offset.value, limit.value);
      allTrainings.assignAll(items);
      hasMore.value = items.length == limit.value;
      offset.value += items.length;

      refreshController.refreshCompleted();
      // <- Key: re-enable load more after refresh
      refreshController.resetNoData();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  // Load more
  Future<void> onLoading() async {
    if (!hasMore.value) {
      refreshController.loadNoData();
      return;
    }
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final items = await services.getAllTraining(offset.value, limit.value);

      if (items.isEmpty) {
        hasMore.value = false;
        refreshController.loadNoData();
      } else {
        allTrainings.addAll(items);
        offset.value += items.length;
        hasMore.value = items.length == limit.value;

        if (hasMore.value) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }
    } catch (e) {
      refreshController.loadFailed();
    } finally {
      isLoadingMore.value = false;
    }
  }
}
