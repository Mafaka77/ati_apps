import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';

// Helper function to handle the formatting logic
String formatTime(String time) {
  try {
    DateTime tempDate = DateFormat("HH:mm").parse(time);
    return DateFormat("h:mm a").format(tempDate);
  } catch (e) {
    return time;
  }
}

class EnrollmentCourseWidget extends GetView<EnrollmentDetailController> {
  const EnrollmentCourseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.groupedCourses.isEmpty) {
        return _buildNoSessions();
      }

      final entries = controller.groupedCourses.entries.toList();

      return Column(
        children: entries.map((entry) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                dense: true,
                tilePadding: EdgeInsets.all(10),
                iconColor: const Color(0xFF64748B),
                title: Text(
                  entry.key, // The Date Label
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                children: entry.value.map((data) {
                  return _buildMinimalSessionItem(data);
                }).toList(),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildMinimalSessionItem(var data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF8FAFC))),
      ),
      child: Row(
        children: [
          // 1. Session Counter (Small & Subtle)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                data.tc_session.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.tc_topic,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${formatTime(data.tc_start_time)} - ${formatTime(data.tc_end_time)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSessions() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Text(
          'No sessions scheduled.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
