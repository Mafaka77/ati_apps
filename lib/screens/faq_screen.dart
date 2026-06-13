import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/faq_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final controller = Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0),
          child: appBarBackButton(context), // Floating circular back button
        ),
        title: const Text(
          "FAQ Center",
          style: TextStyle(
            fontFamily: 'SN Pro',
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 1. FAQ CENTER HERO BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF06B6D4), // Cyan-500
                      Color(0xFF0891B2), // Cyan-600
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Knowledge Center",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Find quick, clear answers to common questions about training programs, notices, and trainee profiles.",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.question_answer_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. EXPANDABLE TILES SECTION
              Obx(() {
                if (controller.isLoading.isTrue) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                }

                if (controller.faqs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.faqs.length,
                  itemBuilder: (context, index) {
                    final data = controller.faqs[index];
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor:
                            Colors.transparent, // Remove default tile dividers
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                          ), // Slate-200
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ExpansionTile(
                            title: Text(
                              data.question,
                              style: const TextStyle(
                                fontFamily: 'SN Pro',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            iconColor: const Color(
                              0xFF06B6D4,
                            ), // Cyan active icon color
                            collapsedIconColor: const Color(
                              0xFF64748B,
                            ), // Slate inactive icon color
                            childrenPadding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              16,
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            expandedAlignment: Alignment.topLeft,
                            children: [
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                data.answer,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline_rounded,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No FAQs Available",
              style: TextStyle(
                fontFamily: 'SN Pro',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Answers to frequently asked questions will appear here shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
