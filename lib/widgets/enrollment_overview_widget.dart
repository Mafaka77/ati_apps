import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class EnrollmentOverviewWidget extends GetView<EnrollmentDetailController> {
  const EnrollmentOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.enrollmentDetail.isEmpty) return const SizedBox.shrink();

    final data = controller.enrollmentDetail.first;
    final program = data.training_program;
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    // Handle the room list logic
    String roomDisplay = "No room assigned";
    if (program.t_room != null && program.t_room!.isNotEmpty) {
      roomDisplay = program.t_room!.map((r) => r.room_name).join(", ");
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                program.t_name,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              sizedBoxHeight(20),

              _buildListTile(
                icon: Icons.calendar_today_rounded,
                label: "Start Date",
                value: formatter.format(
                  DateTime.parse(program.t_start_date).toLocal(),
                ),
                iconColor: Colors.orange,
              ),

              const _CustomDivider(),

              _buildListTile(
                icon: Icons.event_available_rounded,
                label: "End Date",
                value: formatter.format(
                  DateTime.parse(program.t_end_date).toLocal(),
                ),
                iconColor: Colors.redAccent,
              ),

              const _CustomDivider(),

              _buildListTile(
                icon: Icons.room_rounded,
                label: program.t_room!.length > 1 ? "Rooms" : "Room",
                value: roomDisplay,
                iconColor: Colors.indigo,
              ),

              const _CustomDivider(),

              _buildListTile(
                icon: Icons.apartment,
                label: "Capacity",
                value: program.t_capacity.toString(),
                iconColor: Colors.pinkAccent,
              ),

              const _CustomDivider(),

              _buildEligibilitySection(data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Better for multi-line room names
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
        Expanded(
          // Wrap in Expanded to prevent overflow if room names are long
          child: Column(
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
        ),
      ],
    );
  }

  Widget _buildEligibilitySection(var data) {
    final eligibility = data.training_program.t_eligibility;

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
              if (eligibility != null && eligibility.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: eligibility.map<Widget>((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        item.groupName.toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
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

// Small helper widget to keep build method clean
class _CustomDivider extends StatelessWidget {
  const _CustomDivider();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 0.5),
    );
  }
}
