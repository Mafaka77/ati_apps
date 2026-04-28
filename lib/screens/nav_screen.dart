import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/nav_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class NavScreen extends GetView<NavController> {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.home_background,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Main content
          Obx(
            () => controller.widgetOptions.elementAt(
              controller.selectedIndex.value,
            ),
          ),

          // Custom Glass Bottom Nav
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                MediaQuery.of(context).padding.bottom + 10,
              ),
              child: Obx(() => _buildGlassNav()),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.home_background,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          _buildGreetingText(context),
        ],
      ),
    );
  }

  Widget _buildGlassNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70, // Fixed height for consistent industrial feel
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(
              0.7,
            ), // Solider dark glass like web sidebar
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Perfectly equal spacing
            children: [
              _navItem(asset: 'assets/images/home.svg', index: 0),
              _navItem(asset: 'assets/images/calendar.svg', index: 1),
              _navItem(asset: 'assets/images/settings.svg', index: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({required String asset, required int index}) {
    final bool isSelected = controller.selectedIndex.value == index;

    return InkWell(
      onTap: () => controller.selectedIndex.value = index,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          asset,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  // Helper UI Methods
  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
      ),
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(Icons.person_outline, color: Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildGreetingText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getGreeting().toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w900,
            color: Colors.black45,
          ),
        ),
        Obx(
          () => Text(
            controller.user.isEmpty ? 'User' : controller.user.first.full_name!,
            style: textStyle(
              16,
              Colors.black87,
              FontWeight.w800,
              context: context,
            ),
          ),
        ),
      ],
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }
}
