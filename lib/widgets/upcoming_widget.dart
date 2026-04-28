import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/models/training_program_model.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';

class UpcomingWidget extends GetView<HomeController> {
  const UpcomingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingWidget(
          'Upcoming'.toUpperCase(),
          Ionicons.flash_outline,
          () => Get.toNamed('/trainings'),
          context,
        ),
        sizedBoxHeight(16),
        Obx(() {
          if (controller.upcomingTrainings.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: controller.upcomingTrainings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final data = controller.upcomingTrainings[index];
              return _buildVerticalCard(context, data, formatter);
            },
          );
        }),
      ],
    );
  }

  Widget _buildVerticalCard(
    BuildContext context,
    TrainingProgramModel data,
    DateFormat formatter,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Subtle shadow instead of heavy borders
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)), // Zinc-100
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/training-details/${data.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image Section - Fixed Square for consistency
              Hero(
                tag: 'training-${data.id}',
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: NetworkImage(
                        Routes.IMAGE_URL + (data.t_banner ?? ''),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCompactEligibility(data),
                        // Status Indicator Dot
                        const Icon(Icons.circle, size: 6, color: Colors.amber),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.t_name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'SN Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827), // Zinc-900
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Minimalist Date
                    Row(
                      children: [
                        const Icon(
                          Ionicons.calendar_clear_outline,
                          size: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${formatter.format(DateTime.parse(data.t_start_date).toLocal())} — ${formatter.format(DateTime.parse(data.t_end_date).toLocal())}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B), // Zinc-500
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          const Icon(Ionicons.file_tray_outline, color: Colors.grey, size: 30),
          const SizedBox(height: 10),
          Text(
            'NO UPCOMING SESSIONS',
            style: textStyle(
              10,
              Colors.grey,
              FontWeight.w900,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactEligibility(TrainingProgramModel data) {
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
