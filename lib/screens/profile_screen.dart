import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/profile_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "My Profile",
              style: TextStyle(
                fontFamily: 'SN Pro',
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
              // Quick Logout Icon
              IconButton(
                onPressed: () => _showLogoutDialog(context, controller),
                icon: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.isTrue) {
              return const Center(child: CircularProgressIndicator());
            }

            // Safe access to user data
            final user = controller.user.isNotEmpty
                ? controller.user.first
                : null;
            final userName = user?.full_name ?? "User";
            // final userEmail = user?.email ?? "email@example.com"; // If you have email

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // 1. HEADER SECTION
                  _buildProfileHeader(userName),

                  const SizedBox(height: 24),

                  // 2. ACCOUNT SETTINGS GROUP
                  _buildSectionHeader("Account"),
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.person_outline_rounded,
                      title: "Edit Profile",
                      onTap: () {
                        controller.getUserDetails(
                          () => showLoader(),
                          () {
                            hideLoader();
                            Get.toNamed('/edit-profile');
                          },
                          (msg) {
                            hideLoader();
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(myErrorSnackBar('Error', msg));
                          },
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.folder_open_rounded,
                      title: "Documents",
                      onTap: () => Get.toNamed('/document'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.settings_outlined,
                      title: "App Permissions",
                      onTap: () => Get.toNamed('/app-permission'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // 3. SUPPORT & LEGAL GROUP
                  _buildSectionHeader("Support & Legal"),
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.help_outline_rounded,
                      title: "FAQ's",
                      onTap: () => Get.toNamed('/faq'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.confirmation_number_outlined,
                      title: "Raise a Ticket",
                      onTap: () => Get.toNamed('/ticket'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.policy_outlined,
                      title: "Terms and Policy",
                      onTap: () => Get.toNamed('/terms'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // 4. DANGER ZONE
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.delete_outline_rounded,
                      title: "Delete Account",
                      isDestructive: true,
                      onTap: () {
                        // Add delete logic dialog here
                      },
                    ),
                  ]),

                  const SizedBox(height: 40),

                  // Version Text
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // --- WIDGETS ---

  Widget _buildProfileHeader(String name) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFE2E8F0),
                backgroundImage: AssetImage('assets/images/man.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'SN Pro',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: Color(0xFF94A3B8), // Slate-400
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFEF2F2)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDestructive ? Colors.redAccent : const Color(0xFF64748B),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'SN Pro',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.redAccent : const Color(0xFF334155),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Color(0xFFCBD5E1),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9), // Slate-100
      indent: 60, // Start after the icon
    );
  }

  // --- LOGIC ---

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              controller.logout(
                () => showLoader(),
                (msg) {
                  Navigator.of(context).pop();
                  hideLoader();
                  Get.offAndToNamed('/');
                },
                (msg) {
                  hideLoader();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(myErrorSnackBar('Warning', msg));
                },
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
