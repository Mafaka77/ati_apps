import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/training_detail_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class CourseWidget extends GetView<TrainingDetailController> {
  const CourseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat timeOnly = DateFormat('hh:mm a');

    return Obx(() {
      if (controller.groupedCourses.isEmpty) {
        return _buildNoSessions();
      }

      final entries = controller.groupedCourses.entries.toList();
      print(entries);
      return Column(
        // Use Column instead of ListView to avoid scroll conflicts
        children: entries.map((entry) {
          final dateLabel = entry.key;
          final courses = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Text(
                  dateLabel,
                  style: const TextStyle(
                    fontFamily: 'SN Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                subtitle: Text(
                  '${courses.length} Session${courses.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                children: courses.map((data) {
                  // return Container();
                  return _buildSessionItem(context, data, timeOnly);
                }).toList(),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSessionItem(
    BuildContext context,
    var data,
    DateFormat timeOnly,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Zinc-50
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Session Number Indicator
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              data.tc_session.toString(),
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.tc_topic,
                  style: const TextStyle(
                    fontFamily: 'SN Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B), // Zinc-800
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(data.tc_start_time))} - '
                      '${DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(data.tc_end_time))}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
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

  void _handleAttendance(var data) {
    // Navigate to QR Scanner or call Attendance Controller
    print("Marking attendance for session: ${data.tc_session}");
  }

  Widget _buildNoSessions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.event_busy_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text(
              'No sessions scheduled yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
