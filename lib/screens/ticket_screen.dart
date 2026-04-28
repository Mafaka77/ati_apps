import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/ticket_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class TicketScreen extends StatelessWidget {
  TicketScreen({super.key});
  final controller = Get.find<TicketController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF1E293B),
          ),
        ),
        title: const Text(
          "Support Tickets",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildBottomButton(context),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tickets.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            100,
          ), // Extra bottom padding for button
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final data = controller.tickets[index];
            return _buildTicketCard(context, data);
          },
        );
      }),
    );
  }

  // --- Widget: Ticket Card ---
  Widget _buildTicketCard(BuildContext context, var data) {
    // Determine status color scheme
    final Color statusColor = _getStatusColor(data.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleTicketTap(context, data.id),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        data.status?.toUpperCase() ?? 'UNKNOWN',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Date display
                    Text(
                      _formatTicketDate(data.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  data.subject ?? 'No Subject',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number_outlined,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "ID: #${data.id.toString().substring(0, 8).toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget: New Ticket Button ---
  Widget _buildBottomButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
        ),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed('/ticket/new-ticket'),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              "Raise New Ticket",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B), // Dark Slate
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open':
        return Colors.blue;
      case 'In Progress':
        return Colors.amber.shade700;
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatTicketDate(dynamic rawDate) {
    try {
      final date = DateTime.tryParse(rawDate.toString().trim());
      if (date == null) return 'N/A';
      return DateFormat('MMM dd, yyyy').format(date.toLocal());
    } catch (_) {
      return 'N/A';
    }
  }

  void _handleTicketTap(BuildContext context, String id) {
    controller.getTicketDetails(id, () => showLoader(), () {
      hideLoader();
      Get.toNamed('/ticket/details');
    }, (message) => hideLoader());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "No tickets found",
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "If you need help, raise a new ticket below.",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
