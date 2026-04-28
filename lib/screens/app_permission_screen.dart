import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:training_apps/controllers/app_permission_controller.dart';
import 'package:training_apps/reusables/colors.dart';

class AppPermissionScreen extends StatelessWidget {
  const AppPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AppPermissionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF1E293B),
          ),
        ),
        title: const Text(
          "Permissions",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SECTION
              const Text(
                "App Capabilities",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Management",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "To provide a seamless experience, especially for location-based attendance, please ensure the following permissions are granted.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B), // Slate-500
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // 2. PERMISSION LIST CONTAINER
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      _buildPermissionRow(
                        icon: Icons.camera_alt_rounded,
                        title: 'Camera Access',
                        description: 'Needed for profile photos and QR scans.',
                        status: controller.cameraStatus.value,
                        statusColor: controller.statusColor(
                          controller.cameraStatus.value,
                        ),
                        statusText: controller.statusText(
                          controller.cameraStatus.value,
                        ),
                        onAction: () async {
                          if (controller
                              .cameraStatus
                              .value
                              .isPermanentlyDenied) {
                            controller.openSettings();
                          } else {
                            await controller.requestCamera();
                            await controller.refreshAllStatuses();
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildPermissionRow(
                        icon: Icons.location_on_rounded,
                        title: 'Location Services',
                        description: 'Required for Geofence-based attendance.',
                        status: controller.locationStatus.value,
                        statusColor: controller.statusColor(
                          controller.locationStatus.value,
                        ),
                        statusText: controller.statusText(
                          controller.locationStatus.value,
                        ),
                        onAction: () async {
                          if (controller
                              .locationStatus
                              .value
                              .isPermanentlyDenied) {
                            controller.openSettings();
                          } else {
                            await controller.requestLocation();
                            await controller.refreshAllStatuses();
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 32),

              // 3. GLOBAL SETTINGS BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => controller.openSettings(),
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  label: const Text(
                    "System App Settings",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B), // Dark Slate
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRow({
    required IconData icon,
    required String title,
    required String description,
    required PermissionStatus status,
    required Color statusColor,
    required String statusText,
    required VoidCallback onAction,
  }) {
    bool isGranted = status.isGranted;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF64748B), size: 24),
          ),
          const SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),

                // Status Badge & Action Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (!isGranted)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          status.isPermanentlyDenied
                              ? "Open Settings"
                              : "Enable",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    if (isGranted)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9),
      indent: 16,
      endIndent: 16,
    );
  }
}
