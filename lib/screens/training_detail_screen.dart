import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/training_detail_controller.dart';
import 'package:training_apps/models/training_program_model.dart'; // Ensure this import points to your model
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/widgets/course_widget.dart';
import 'package:training_apps/widgets/material_widget.dart';
import 'package:training_apps/widgets/overview_widget.dart';

class TrainingDetailScreen extends GetView<TrainingDetailController> {
  const TrainingDetailScreen({super.key});

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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomDock(context),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (controller.trainingDetail.isEmpty) {
          return const Center(child: Text("No details found."));
        }

        final data = controller.trainingDetail.first;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeaderImage(data, context),
                sizedBoxHeight(10),
                Text(
                  data.t_name,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 14,
                      color: Colors.amberAccent,
                    ),
                    sizedBoxWidth(5),
                    Text(
                      data.t_category?.name ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                sizedBoxHeight(10),
                _buildCustomTabBar(context, data),
                sizedBoxHeight(10),
                _buildTabContent(),
                sizedBoxHeight(100),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- Widgets ---

  Widget _buildHeaderImage(TrainingProgramModel data, BuildContext context) {
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
              imageUrl: Routes.IMAGE_URL + (data.t_banner!),
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
              child: _buildStatusBadge(data.t_status, context),
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

  Widget _buildCustomTabBar(BuildContext context, TrainingProgramModel data) {
    return Container(
      height: 40,
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
      child: Row(
        children: [
          _buildTabButton(context, "Overview", 0),
          _buildTabButton(
            context,
            "Session",
            1,
            onTap: () {
              controller.getCourseByTrainingId(data.id, () => showLoader(), () {
                hideLoader();
                controller.isSelectedIndex.value = 1;
              }, () => hideLoader());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String title,
    int index, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.isSelectedIndex.value == index;
        return GestureDetector(
          onTap: onTap ?? () => controller.isSelectedIndex.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent() {
    // Obx is already parent in build(), but this ensures specific rebuilds
    switch (controller.isSelectedIndex.value) {
      case 0:
        return const OverviewWidget();
      case 1:
        // Removed fixed height constraint. Let CourseWidget define its size or wrap in Container if needed.
        return const CourseWidget();
      case 2:
        return const MaterialWidget();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomDock(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue || controller.trainingDetail.isEmpty) {
        return const SizedBox();
      }

      final data = controller.trainingDetail.first;
      if (data.t_status != 'Upcoming') return const SizedBox();

      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        // Use SafeArea here to handle system navigation conflicts
        child: SafeArea(
          bottom: true,
          child: Padding(
            // Adjusted padding: removed the large bottom padding (30)
            // because SafeArea now handles it dynamically.
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
            child: ElevatedButton(
              onPressed: () async {
                var response = await controller.enroll();
                if (response['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySuccessSnackBar('Success', response['message']),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    myWarningSnackBar('Warning', response['message']),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF111827,
                ), // Zinc-900 for our theme
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Enroll Now',
                style: TextStyle(
                  fontFamily: 'SN Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
