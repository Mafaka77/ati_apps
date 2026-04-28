import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionController extends GetxController {
  // Reactive statuses
  final cameraStatus = PermissionStatus.denied.obs;
  final locationStatus = PermissionStatus.denied.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAllStatuses();
  }

  Future<void> refreshAllStatuses() async {
    final cam = await Permission.camera.status;
    final loc = await Permission.locationWhenInUse.status;

    cameraStatus.value = cam;
    locationStatus.value = loc;
  }

  String statusText(PermissionStatus s) {
    if (s.isGranted) return 'Granted';
    if (s.isDenied) return 'Denied';
    if (s.isPermanentlyDenied) return 'Permanently Denied';
    if (s.isRestricted) return 'Restricted';
    if (s.isLimited) return 'Limited';
    return s.toString();
  }

  bool canRequest(PermissionStatus s) {
    return !s.isGranted && !s.isPermanentlyDenied;
  }

  Color statusColor(PermissionStatus s) {
    if (s.isGranted) return Colors.green;
    if (s.isPermanentlyDenied) return Colors.red.shade700;
    if (s.isDenied || s.isRestricted) return Colors.orange;
    return Colors.grey;
  }

  // Requests
  Future<void> requestCamera() async {
    final r = await Permission.camera.request();
    cameraStatus.value = r;
  }

  Future<void> requestLocation() async {
    final r = await Permission.locationWhenInUse.request();
    locationStatus.value = r;
  }

  // Open app settings
  Future<void> openSettings() async {
    await openAppSettings();
    await Future.delayed(const Duration(milliseconds: 300));
    await refreshAllStatuses();
  }
}
