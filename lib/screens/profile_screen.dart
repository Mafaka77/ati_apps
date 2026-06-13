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
                fontWeight: FontWeight.w800,
                fontSize: 18,
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
            final userEmail = user?.email ?? "trainee.member@atimz.gov.in";
            final userMobile = user?.mobile ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. DYNAMIC HEADER SECTION CARD
                  _buildProfileHeaderCard(
                    context,
                    controller,
                    userName,
                    userEmail,
                    userMobile,
                  ),

                  const SizedBox(height: 28),

                  // 2. ACCOUNT SETTINGS GROUP
                  _buildSectionHeader("Account Settings"),
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.manage_accounts_rounded,
                      title: "Edit Profile",
                      iconColor: const Color(0xFF2563EB), // blue-600
                      iconBgColor: const Color(0xFFEFF6FF), // blue-50
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
                      icon: Icons.folder_shared_rounded,
                      title: "Notice",
                      iconColor: const Color(0xFF059669), // emerald-600
                      iconBgColor: const Color(0xFFECFDF5), // emerald-50
                      onTap: () => Get.toNamed('/document'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.security_rounded,
                      title: "App Permissions",
                      iconColor: const Color(0xFF7C3AED), // purple-600
                      iconBgColor: const Color(0xFFF5F3FF), // purple-50
                      onTap: () => Get.toNamed('/app-permission'),
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // 3. SUPPORT & LEGAL GROUP
                  _buildSectionHeader("Support & Legal"),
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.help_center_rounded,
                      title: "FAQ's",
                      iconColor: const Color(0xFF06B6D4), // cyan-600
                      iconBgColor: const Color(0xFFECFEFF), // cyan-50
                      onTap: () => Get.toNamed('/faq'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.confirmation_number_rounded,
                      title: "Raise a Ticket",
                      iconColor: const Color(0xFFD97706), // amber-600
                      iconBgColor: const Color(0xFFFFFBEB), // amber-50
                      onTap: () => Get.toNamed('/ticket'),
                    ),
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.policy_rounded,
                      title: "Terms and Policy",
                      iconColor: const Color(0xFF475569), // slate-600
                      iconBgColor: const Color(0xFFF1F5F9), // slate-50
                      onTap: () => Get.toNamed('/terms'),
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // 4. DANGER ZONE
                  _buildMenuContainer([
                    _buildMenuTile(
                      icon: Icons.delete_outline_rounded,
                      title: "Delete Account",
                      iconColor: const Color(0xFFEF4444),
                      iconBgColor: const Color(0xFFFEF2F2),
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
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // --- WIDGETS ---

  Widget _buildProfileHeaderCard(
    BuildContext context,
    ProfileController controller,
    String name,
    String email,
    String mobile,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
          // Background abstract graphic circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.02),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Glowing Avatar ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFFE2E8F0),
                    backgroundImage: AssetImage('assets/images/man.png'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Designation Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.2),
                          ),
                        ),
                        child: const Text(
                          "TRAINEE",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'SN Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),
                      if (mobile.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_iphone_rounded,
                              size: 11,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              mobile,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Top right Quick Edit Button
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: const Icon(
                Icons.mode_edit_outline_outlined,
                color: Colors.white60,
                size: 20,
              ),
              onPressed: () {
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF64748B), // Slate-500
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
    required Color iconBgColor,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'SN Pro',
          fontSize: 14,
          fontWeight: FontWeight.w700,
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
      indent: 52, // Start after the icon box
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.power_settings_new_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'SN Pro',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your trainee account?',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
            child: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
