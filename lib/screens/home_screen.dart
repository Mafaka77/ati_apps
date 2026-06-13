import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/reusables/shimmer.dart';
import 'package:training_apps/widgets/app_bar_widget.dart';
import 'package:training_apps/widgets/carousel_widget.dart';
import 'package:training_apps/widgets/faq_widget.dart';
import 'package:training_apps/widgets/upcoming_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent, // Seamless blend with NavScreen
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshAll, // pull-to-refresh callback
              color: Colors.blueAccent, // refresh spinner color
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // required
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => controller.isLoading.isTrue
                            ? const ShimmerCarouselWithHints()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Announcements Carousel Section
                                  _buildSectionHeader(
                                    context,
                                    "Featured Updates",
                                    Ionicons.megaphone_outline,
                                  ),
                                  sizedBoxHeight(10),
                                  const CarouselWidget(),
                                  sizedBoxHeight(24),

                                  // 2. Motivational Premium Banner
                                  // _buildMotivationalBanner(context),
                                  // sizedBoxHeight(24),

                                  // 3. Quick Actions Dashboard Grid
                                  _buildSectionHeader(
                                    context,
                                    "Quick Access",
                                    Ionicons.grid_outline,
                                  ),
                                  sizedBoxHeight(12),
                                  _buildQuickActionsGrid(context),
                                  sizedBoxHeight(28),

                                  // 4. Upcoming Trainings Section
                                  const UpcomingWidget(),
                                  sizedBoxHeight(8),

                                  // 5. Help & FAQs Section
                                  const FaqWidget(),
                                  sizedBoxHeight(60),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.blueAccent),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.blueAccent,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A), // Slate-900
            Color(0xFF1E293B), // Slate-800
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle design circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.02),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Elevate Your Skills",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SN Pro',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Explore certified professional courses and unlock new milestones today.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () => Get.toNamed('/trainings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Get Certified",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Glowing Trophy or Badge Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: const Icon(
                    Ionicons.trophy_outline,
                    size: 32,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Slate-200
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            context,
            title: "Trainings",
            icon: Ionicons.school_outline,
            backgroundColor: const Color(0xFFEFF6FF), // blue-50
            iconColor: const Color(0xFF2563EB), // blue-600
            onTap: () => Get.toNamed('/trainings'),
          ),
          _buildActionItem(
            context,
            title: "Notice",
            icon: Ionicons.folder_open_outline,
            backgroundColor: const Color(0xFFECFDF5), // emerald-50
            iconColor: const Color(0xFF059669), // emerald-600
            onTap: () => Get.toNamed('/document'),
          ),
          _buildActionItem(
            context,
            title: "Support",
            icon: Ionicons.chatbubble_ellipses_outline,
            backgroundColor: const Color(0xFFFFFBEB), // amber-50
            iconColor: const Color(0xFFD97706), // amber-600
            onTap: () => Get.toNamed('/ticket'),
          ),
          _buildActionItem(
            context,
            title: "FAQs",
            icon: Ionicons.help_circle_outline,
            backgroundColor: const Color(0xFFF5F3FF), // purple-50
            iconColor: const Color(0xFF7C3AED), // purple-600
            onTap: () => Get.toNamed('/faq'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155), // Slate-700
              ),
            ),
          ],
        ),
      ),
    );
  }
}
