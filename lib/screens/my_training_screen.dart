import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/controllers/my_training_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/reusables/shimmer.dart';
import 'package:training_apps/routes/routes.dart';

class MyTrainingScreen extends StatelessWidget {
  MyTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return GetBuilder<MyTrainingController>(
      init: MyTrainingController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.home_background,
          body: SafeArea(
            child: Obx(() {
              if (controller.isLoading.isTrue &&
                  controller.myEnrollments.isEmpty) {
                return const ShimmerCarouselWithHints();
              }

              return Column(
                children: [
                  // 1. Fixed Top Action Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _buildTopActionBar(context, controller),
                  ),

                  // 2. Expandable Search Bar (Animated)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: controller.isSearchVisible.value
                        ? _buildSearchBar(controller)
                        : const SizedBox.shrink(),
                  ),

                  // 3. Main List Content
                  Expanded(
                    child: controller.myEnrollments.isEmpty
                        ? _buildEmptyState()
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: const WaterDropHeader(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            controller: controller.refreshController,
                            onRefresh: controller.onRefresh,
                            onLoading: controller.onLoadMore,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.myEnrollments.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final enrollment =
                                    controller.myEnrollments[index];
                                final tp = enrollment.training_program;
                                return _buildEnrollmentCard(
                                  context,
                                  enrollment,
                                  tp,
                                  formatter,
                                  controller,
                                );
                              },
                            ),
                          ),
                  ),
                  sizedBoxHeight(70),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildTopActionBar(
    BuildContext context,
    MyTrainingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Ionicons.apps_outline, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 12),
          const Text(
            "My Enrollment",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          _buildActionIcon(Ionicons.filter_outline),
          const SizedBox(width: 8),

          // Make Search Icon Clickable
          GestureDetector(
            onTap: () {
              controller.isSearchVisible.toggle();
            },
            child: Obx(
              () => _buildActionIcon(
                Ionicons.search_outline,
                isActive: controller.isSearchVisible.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(MyTrainingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchEditingController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            // Trigger search via controller
            controller.search.value = value;
            controller.onRefresh(); // Re-fetch from start
          },
          decoration: InputDecoration(
            hintText: "Search training...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(
              Ionicons.search_outline,
              color: Colors.blueAccent,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Ionicons.close_circle,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                // Clear search and reset list
                controller.searchEditingController.clear();
                controller.search.value = '';
                controller.onRefresh();
                controller.isSearchVisible.value =
                    false; // Hide bar when cleared
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // Updated to support an "active" state color when search is open
  Widget _buildActionIcon(IconData icon, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.blueAccent.withOpacity(0.1)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isActive ? Colors.blueAccent : const Color(0xFF4B5563),
      ),
    );
  }

  Widget _buildEnrollmentCard(
    BuildContext context,
    var enrollment,
    var tp,
    DateFormat formatter,
    MyTrainingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () async {
            showLoader();
            var response = await controller.checkStatus(enrollment.id);
            if (response['success']) {
              hideLoader();
              Get.toNamed('/enrollment-details/${enrollment.id}');
            } else {
              hideLoader();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(myWarningSnackBar('Warning', response['message']));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 21 / 9,
                    child: tp?.t_banner != null
                        ? Image.network(
                            Routes.IMAGE_URL + tp.t_banner,
                            fit: BoxFit.cover,
                          )
                        : Container(color: const Color(0xFFF3F4F6)),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildTrainingStatusBadge(tp?.t_status),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tp?.t_name ?? 'Untitled Training',
                      style: const TextStyle(
                        fontFamily: 'SN Pro',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    sizedBoxHeight(10),
                    _buildCompactEligibility(tp),
                    sizedBoxHeight(10),
                    _buildIconText(
                      Ionicons.people_outline,
                      "${tp?.t_capacity ?? 0} Seats",
                    ),
                    sizedBoxHeight(10),
                    _buildIconText(
                      Ionicons.calendar_outline,
                      tp != null
                          ? "${formatter.format(DateTime.parse(tp.t_start_date).toLocal())} - ${formatter.format(DateTime.parse(tp.t_end_date).toLocal())}"
                          : "Date N/A",
                    ),
                  ],
                ),
              ),
              _buildEnrollmentStatusBar(enrollment.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingStatusBadge(String? status) {
    final style = getStatusStyle(status ?? 'Unknown');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: style.borderColor),
      ),
      child: Text(
        (status ?? 'Unknown').toUpperCase(),
        style: TextStyle(
          color: style.textColor,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEnrollmentStatusBar(String? status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Approved':
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF166534);
        icon = Ionicons.checkmark_circle;
        break;
      case 'Pending':
        bgColor = const Color(0xFFFFFBEB);
        textColor = const Color(0xFF92400E);
        icon = Ionicons.time;
        break;
      default:
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFF991B1B);
        icon = Ionicons.close_circle;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: textColor.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 8),
          Text(
            "Enrollment ${status ?? 'Unknown'}",
            style: TextStyle(
              fontFamily: 'SN Pro',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactEligibility(var data) {
    final String text =
        (data.t_eligibility != null && data.t_eligibility!.isNotEmpty)
        ? data.t_eligibility!
              .map((e) => e.groupName.toString().toUpperCase())
              .join(' • ')
        : 'OPEN ACCESS';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 8,
          fontFamily: 'SN Pro',
          fontWeight: FontWeight.w900,
          color: Colors.blueAccent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Ionicons.albums_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "No Enrollments Found",
            style: TextStyle(
              fontFamily: 'SN Pro',
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
