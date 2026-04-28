import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/controllers/auth_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. STYLISH HEADER
                _buildModernHeader(),

                // 2. OVERLAPPING FORM CARD
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.24),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E293B).withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Login to access your training dashboard",
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF64748B).withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),

                          _buildInputLabel("Mobile"),
                          _buildCustomField(
                            controller: controller.loginMobileText,
                            hint: "Enter registered details",
                            icon: Ionicons.mail_unread_outline,
                          ),

                          const SizedBox(height: 20),

                          _buildInputLabel("Password"),
                          Obx(
                            () => _buildCustomField(
                              controller: controller.loginPasswordText,
                              hint: "••••••••",
                              icon: Ionicons.lock_closed_outline,
                              isPassword: true,
                              obscure: controller.isLoginPasswordHidden.value,
                              toggle: () =>
                                  controller.isLoginPasswordHidden.toggle(),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Get.toNamed('/forgot-password-otp-screen'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // PREMIUM LOGIN BUTTON
                          _buildLoginButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // REGISTER LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New to the platform?",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.loginMobileText.clear();
                    controller.loginPasswordText.clear();
                    Get.toNamed('/auth/otp');
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
      height: Get.height * 0.35,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Decorative Circle Background
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "ATI G0M",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 40), // Spacing for the overlap
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return TextFormField(
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.phone,
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: toggle,
                icon: Icon(
                  obscure ? Ionicons.eye_off_outline : Ionicons.eye_outline,
                  size: 20,
                ),
              )
            : null,
        fillColor: const Color(0xFFF8FAFC),
        filled: true,
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _handleLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGN IN',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Icon(Ionicons.arrow_forward, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    if (controller.loginFormKey.currentState!.validate()) {
      controller.login(
        () => showLoader(),
        (message) {
          hideLoader();
          Get.offAllNamed('/');
        },
        (message) {
          hideLoader();
          ScaffoldMessenger.of(context).showSnackBar(
            myWarningSnackBar(
              'Access Denied',
              message ?? "Invalid Credentials",
            ),
          );
        },
      );
    }
  }
}
