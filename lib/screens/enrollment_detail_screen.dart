import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/models/enrollment_detail_model.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/reusables/shimmer.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/widgets/enrollment_attendance_widget.dart';
import 'package:training_apps/widgets/enrollment_course_widget.dart';
import 'package:training_apps/widgets/enrollment_material_widget.dart';
import 'package:training_apps/widgets/enrollment_overview_widget.dart';
import 'package:training_apps/widgets/enrollment_certificate_widget.dart';
import 'package:training_apps/widgets/skeleton/enrollment_detail_skeleton.dart';

class EnrollmentDetailScreen extends StatelessWidget {
  EnrollmentDetailScreen({super.key});

  final controller = Get.find<EnrollmentDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.home_background, // Or Colors.grey[50]
      appBar: AppBar(
        backgroundColor: MyColors.home_background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Training Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: appBarBackButton(context),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.isTrue) return const SizedBox.shrink();
        if (controller.enrollmentDetail.isEmpty) return const SizedBox.shrink();

        final data = controller.enrollmentDetail.first;
        if (data.training_program.t_status != 'Completed') {
          return const SizedBox.shrink();
        }
        // Wrap the button in a SafeArea
        return SafeArea(
          child: Padding(
            // Add padding so it doesn't hug the absolute edge of the safe zone
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: MaterialButton(
              height: 50, // Give it a nice touchable height
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Match your app's rounded corners
              ),
              color: const Color(
                0xFF073E6C,
              ), // Using your app's primary color from earlier
              child: const Text(
                'Evaluation Feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                var response = await controller.checkEvaluationStatus(
                  data.training_program.id,
                );
                if (response['success'] == true) {
                  Get.toNamed('/evaluation/${data.training_program.id}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    myWarningSnackBar('Warning', response['message']),
                  );
                }
              },
            ),
          ),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return EnrollmentDetailSkeleton();
        }

        if (controller.enrollmentDetail.isEmpty) {
          return const Center(child: Text("No details found."));
        }
        final data = controller.enrollmentDetail.first;

        return SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshEnrollmentDetails,
          enablePullDown: true,
          enablePullUp: false,
          header: const MaterialClassicHeader(
            color: Color(0xFF073E6C), // Keeping your brand color
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildHeaderImage(data, context),
                  sizedBoxHeight(10),
                  _buildCustomTabBar(context, data),
                  sizedBoxHeight(10),
                  _buildTabContent(data),
                  sizedBoxHeight(100),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- Widgets ---

  Widget _buildHeaderImage(EnrollmentDetailModel data, BuildContext context) {
    return Container(
      height: Get.height * 0.24,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: Routes.IMAGE_URL + (data.training_program.t_banner!),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay for text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
            ),
            // Status Badge
            Positioned(
              left: 15,
              bottom: 15,
              child: _buildStatusBadge(data.training_program.t_status, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    final style = getStatusStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(20), // Pill shape
        border: Border.all(color: style.borderColor), // Subtle border
      ),
      child: Text(
        status, // e.g., "Upcoming"
        style: TextStyle(
          color: style.textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCustomTabBar(BuildContext context, EnrollmentDetailModel data) {
    return Container(
      height: 48, // Slightly increased height for better scroll interaction
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        // Added to ensure scroll ripple effects stay inside the rounded corners
        borderRadius: BorderRadius.circular(50),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics:
              const BouncingScrollPhysics(), // Adds a nice bounce effect when scrolling
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ), // Padding at the edges
          children: [
            _buildTabButton(
              context,
              "Overview",
              0,
              Ionicons.information_circle_outline,
            ),
            _buildTabButton(
              context,
              "Sessions",
              1,
              Ionicons.play_circle_outline,
              onTap: () {
                controller.getCourseByTrainingId(
                  data.training_program.id,
                  () => showLoader(),
                  () {
                    hideLoader();
                    controller.isSelectedIndex.value = 1;
                  },
                  () => hideLoader(),
                );
              },
            ),
            if (data.training_program.t_status != 'Upcoming' &&
                data.training_program.t_status != 'Draft') ...[
              _buildTabButton(
                context,
                "Attendance",
                2,
                Ionicons.finger_print_outline,
                onTap: () async {
                  showLoader();
                  var response = await controller.getAttendanceByDate(
                    DateTime.now(),
                    data.training_program.id,
                  );
                  if (response['success'] == true) {
                    hideLoader();
                    controller.isSelectedIndex.value = 2;
                  } else {
                    hideLoader();
                  }
                },
              ),
            ],
            if (data.training_program.t_status != 'Upcoming' &&
                data.training_program.t_status != 'Draft') ...[
              _buildTabButton(
                context,
                "Materials",
                3,
                Ionicons.document_outline,
                onTap: () async {
                  showLoader();
                  var response = await controller.getMaterials(
                    data.training_program.id,
                  );
                  if (response['success'] == true) {
                    hideLoader();
                    controller.isSelectedIndex.value = 3;
                  } else {
                    hideLoader();
                  }
                },
              ),
            ],
            if (data.training_program.t_status == 'Completed') ...[
              _buildTabButton(
                context,
                "Certificate",
                4,
                Ionicons.ribbon_outline,
                onTap: () async {
                  showLoader();
                  var response = await controller.getCertificateAndReleaseOrder(
                    data.training_program.id,
                  );
                  if (response['success'] == true) {
                    hideLoader();
                    controller.isSelectedIndex.value = 4;
                  } else {
                    hideLoader();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String title,
    int index,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    // Removed the 'Expanded' widget here
    return Obx(() {
      final isSelected = controller.isSelectedIndex.value == index;

      return GestureDetector(
        onTap: onTap ?? () => controller.isSelectedIndex.value = index,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width:
              80, // Added a fixed width to keep buttons uniform in the scrollable list
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF073E6C) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF073E6C).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent(EnrollmentDetailModel data) {
    // Obx is already parent in build(), but this ensures specific rebuilds
    switch (controller.isSelectedIndex.value) {
      case 0:
        return const EnrollmentOverviewWidget();
      case 1:
        // Removed fixed height constraint. Let CourseWidget define its size or wrap in Container if needed.
        return const EnrollmentCourseWidget();
      case 2:
        return EnrollmentAttendanceWidget(programId: data.training_program.id);
      case 3:
        return EnrollmentMaterialWidget();
      case 4:
        return EnrollmentCertificateWidget();
      default:
        return const SizedBox();
    }
  }
}
