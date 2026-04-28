import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/controllers/nav_controller.dart';
import 'package:training_apps/controllers/ticket_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class TicketDetailScreen extends GetView<TicketController> {
  TicketDetailScreen({super.key});
  final navController = Get.find<NavController>();

  @override
  Widget build(BuildContext context) {
    final data = controller.ticketDetails.first;
    final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
    final String currentUserEmail = navController.user.first.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50
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
        title: Text(
          "Ticket #${data.id.toString().substring(0, 5).toUpperCase()}",
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildChatInput(context, data),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TICKET HEADER CARD
            _buildTicketInfoCard(data),

            const SizedBox(height: 24),

            // 2. REPLIES SECTION HEADER
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                "CONVERSATION",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 1.1,
                ),
              ),
            ),

            // 3. CHAT BUBBLES
            if (data.replies!.isEmpty)
              _buildEmptyReplies()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.replies!.length,
                itemBuilder: (context, index) {
                  final reply = data.replies![index];
                  final bool isMe = reply.senderEmail == currentUserEmail;
                  return _buildChatBubble(reply, isMe, formatter);
                },
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildTicketInfoCard(var data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusBadge(data.status),
              const Spacer(),
              _buildMetaChip(
                Icons.priority_high_rounded,
                data.priority ?? 'Normal',
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.subject,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.description ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              _buildMetaChip(
                Icons.category_outlined,
                data.category ?? 'General',
                Colors.blue,
              ),
              const Spacer(),
              const Text(
                "Posted by ",
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              Text(
                data.user!.email?.split('@').first ?? 'User',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(var reply, bool isMe, DateFormat formatter) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            if (!isMe)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                reply.senderEmail!.split('@').first.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.blueAccent,
                ),
              ),
            if (!isMe) const SizedBox(height: 4),
            Text(
              reply.message,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : const Color(0xFF334155),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatter.format(
                  DateTime.parse(reply.createdAt.toString().trim()),
                ),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white60 : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context, var data) {
    if (data.status == 'Closed') return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.replyText,
                decoration: InputDecoration(
                  hintText: 'Message support...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFF1E293B),
              child: IconButton(
                onPressed: () => _sendReply(context, data.id),
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status == 'Resolved') color = Colors.green;
    if (status == 'Closed') color = Colors.grey;
    if (status == 'In Progress') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status?.toUpperCase() ?? '',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  void _sendReply(BuildContext context, dynamic id) {
    if (controller.replyText.text.trim().isEmpty) return;
    controller.replyTicket(
      id,
      () => showLoader(),
      (msg) {
        hideLoader();
        controller.replyText.clear();
        Get.back();
      },
      (msg) {
        hideLoader();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(myErrorSnackBar('Error', msg));
      },
    );
  }

  Widget _buildEmptyReplies() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text(
          "Waiting for support to reply...",
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      ),
    );
  }
}
