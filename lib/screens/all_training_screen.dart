import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:training_apps/controllers/training_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/reusables/shimmer.dart';
import 'package:training_apps/routes/routes.dart';

class AllTrainingScreen extends GetView<TrainingController> {
  const AllTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: MyColors.home_background,
      appBar: AppBar(
        backgroundColor: MyColors.home_background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Ionicons.chevron_back,
            size: 20,
            color: Color(0xFF111827),
          ),
        ),
        title: Text(
          "Trainings",
          style: TextStyle(
            color: const Color(0xFF111827),
            fontFamily: 'SN Pro',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isInitialLoading.isTrue) {
          return const ShimmerCarouselWithHints();
        }

        return SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoading,
          header: const ClassicHeader(
            idleText: "Pull to refresh",
            completeText: "Updated",
            refreshingIcon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blueAccent,
              ),
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. DASHBOARD HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: _buildTopActionBar(context),
                ),
              ),

              // 2. TRAINING LIST
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = controller.allTrainings[index];
                    return _buildModernIndustrialCard(context, data, formatter);
                  }, childCount: controller.allTrainings.length),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Icon(Ionicons.grid_outline, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 12),
          const Text(
            "Program Registry",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          _buildActionIcon(Ionicons.filter_outline),
          const SizedBox(width: 8),
          _buildActionIcon(Ionicons.search_outline),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF4B5563)),
    );
  }

  Widget _buildModernIndustrialCard(
    BuildContext context,
    var data,
    DateFormat formatter,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => Get.toNamed('/training-details/${data.id}'),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // SECTION: Image (Left)
                Container(
                  width: 110,
                  padding: const EdgeInsets.all(12),
                  child: AspectRatio(
                    aspectRatio: 0.85, // Slightly taller profile for the image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        Routes.IMAGE_URL + (data.t_banner ?? ''),
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Ionicons.image_outline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // SECTION: Content (Right)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamic Header: Status Badge + Eligibility
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusBadge(data.t_status),
                            _buildCompactEligibility(data),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Title
                        Text(
                          data.t_name ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),

                        // Footer: Date Timeline
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.black.withOpacity(0.03),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Ionicons.time_outline,
                                size: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${formatter.format(DateTime.parse(data.t_start_date).toLocal())} - ${formatter.format(DateTime.parse(data.t_end_date).toLocal())}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final style = getStatusStyle(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(6), // Tailwind-style rounded-md
        border: Border.all(color: style.borderColor),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: style.textColor,
          fontWeight: FontWeight.w800,
          fontSize: 7.5,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCompactEligibility(var data) {
    // Map the list to strings and join them
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
        overflow:
            TextOverflow.ellipsis, // Prevents crashing if the list is too long
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
}
