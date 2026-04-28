import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class EnrollmentAttendanceWidget extends GetView<EnrollmentDetailController> {
  final String programId;
  const EnrollmentAttendanceWidget({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    // Initial fetch for today's date when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var response = await controller.getAttendanceByDate(
        DateTime.now(),
        programId,
      );
      if (response['success'] == true) {
        print('Found');
      } else {
        print('Not Found');
      }
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // 1. Dashboard Summary (Percentage & Stats)
          _buildDashboardSummary(),

          const SizedBox(height: 10),

          // 2. Horizontal Calendar
          _buildHorizontalCalendar(context),

          const SizedBox(height: 10),

          // 3. Attendance Content
          Obx(() {
            if (controller.filteredSessions.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              itemCount: controller.filteredSessions.length,
              itemBuilder: (context, index) {
                final session = controller.filteredSessions[index];
                final bool isPresent = session['status'] == 'Present';
                final bool isToday = isSameDay(
                  controller.selectedDate.value,
                  DateTime.now(),
                );

                return _buildSessionCard(context, session, isPresent, isToday);
              },
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Obx(() {
      final int pct = controller.percentage.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF334155)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Circular Progress
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 65,
                      width: 65,
                      child: CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          pct > 75 ? Colors.greenAccent : Colors.blueAccent,
                        ),
                      ),
                    ),
                    Text(
                      "$pct%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Attendance Overview",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${controller.attendedCount.value} / ${controller.totalSessions.value} Sessions",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHorizontalCalendar(BuildContext context) {
    return EasyDateTimeLine(
      disabledDates: [],
      initialDate: controller.selectedDate.value,
      onDateChange: (selectedDate) async {
        showLoader();
        var response = await controller.getAttendanceByDate(
          selectedDate,
          programId,
        );
        if (response['success'] == true) {
          hideLoader();
        } else {
          hideLoader();
        }
      },
      headerProps: const EasyHeaderProps(
        monthStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        selectedDateStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(horizontal: 11),
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
      ),
      dayProps: const EasyDayProps(
        height: 45,
        width: 40,
        dayStructure: DayStructure.dayStrDayNum,
        inactiveDayStyle: DayStyle(
          dayNumStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topLeft, // Changed
              end: Alignment.bottomRight, // Changed
              colors: [Color(0xFF073E6C), Color(0xFF073E6C)],
            ),
          ),
          dayNumStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          dayStrStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    dynamic session,
    bool isPresent,
    bool isToday,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  session['topic'] ?? 'No Topic',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              _buildStatusBadge(isPresent),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                "${formatTime(session['start_time'])} - ${formatTime(session['end_time'])}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          if (isToday && !isPresent) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () async {
                  showLoader();
                  var response = await controller.markAttendance(
                    session['sessionId'],
                    programId,
                  );
                  if (response['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      mySuccessSnackBar('Success', response['message']),
                    );
                    hideLoader();
                    controller.getAttendanceByDate(DateTime.now(), programId);
                  } else {
                    hideLoader();
                    ScaffoldMessenger.of(context).showSnackBar(
                      myWarningSnackBar('Warning', response['message']),
                    );
                  }
                },
                icon: const Icon(Icons.fingerprint, size: 18),
                label: const Text("MARK ATTENDANCE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3371FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isPresent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPresent ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPresent ? "Present" : "Absent",
        style: TextStyle(
          color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 50,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            const Text(
              "No sessions scheduled for this day",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
