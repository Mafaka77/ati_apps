import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/training_detail_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class OverviewWidget extends GetView<TrainingDetailController> {
  const OverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.trainingDetail.isEmpty) return const SizedBox.shrink();

    final data = controller.trainingDetail.first;
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.calendar_today_rounded,
                label: "Start Date",
                value: formatter.format(
                  DateTime.parse(data.t_start_date).toLocal(),
                ),
                iconColor: Colors.orange,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 0.5),
              ),
              _buildListTile(
                icon: Icons.event_available_rounded,
                label: "End Date",
                value: formatter.format(
                  DateTime.parse(data.t_end_date).toLocal(),
                ),
                iconColor: Colors.redAccent,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 0.5),
              ),
              _buildListTile(
                icon: Icons.business_center_rounded,
                label: "Organized By",
                value: data.t_organizer,
                iconColor: Colors.indigo,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 0.5),
              ),
              _buildListTile(
                icon: Icons.apartment,
                label: "Capacity ",
                value: data.t_capacity.toString(),
                iconColor: Colors.pinkAccent,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 0.5),
              ),
              _buildEligibilitySection(data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the detailed list items
  Widget _buildListTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEligibilitySection(var data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Eligibility (Group)",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              // Use Wrap to display all eligibility items as badges
              if (data.t_eligibility != null && data.t_eligibility!.isNotEmpty)
                Wrap(
                  spacing: 6, // Gap between adjacent chips
                  runSpacing: 6, // Gap between lines
                  children: data.t_eligibility!.map<Widget>((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), // Zinc-100
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                        ), // Zinc-200
                      ),
                      child: Text(
                        item.groupName.toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569), // Zinc-600
                          fontFamily: 'SN Pro',
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                const Text(
                  "Open Access",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
