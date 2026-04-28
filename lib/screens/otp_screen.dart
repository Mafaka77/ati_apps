import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/auth_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  static const Color primaryNavy = Color(0xff191c51);
  static const Color slateGrey = Color(0xff64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryNavy,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. Minimalist Header
              const Text(
                'AUTHENTICATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: primaryNavy,
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Identity Verification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: primaryNavy,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please enter your registered mobile number to receive OTP.',
                style: TextStyle(
                  color: slateGrey.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // 2. Sophisticated Form
              Form(
                key: controller.otpFormKey,
                child: Column(
                  children: [
                    Obx(() {
                      return _buildInputField(
                        label: "MOBILE NUMBER",
                        controller: controller.otpMobileText,
                        isReadOnly: controller.isOtpSent.value,
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      );
                    }),

                    Obx(
                      () => controller.isOtpSent.isTrue
                          ? Column(
                              children: [
                                const SizedBox(height: 24),
                                _buildInputField(
                                  label: "OTP",
                                  controller: controller.otpText,
                                  isReadOnly: false,
                                  icon: Icons.lock_outline_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.isOtpSent.value = false;
                                      controller.otpMobileText.clear();
                                      controller.otpText.clear();
                                    },
                                    child: const Text(
                                      'Change Number?',
                                      style: TextStyle(
                                        color: slateGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 40),

                    // 3. Primary Action Button
                    Obx(() => _buildPrimaryButton(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool isReadOnly,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: primaryNavy,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryNavy,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 20,
              color: primaryNavy.withOpacity(0.4),
            ),
            filled: true,
            fillColor: isReadOnly
                ? Colors.grey.shade50
                : const Color(0xffF4F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    bool sent = controller.isOtpSent.value;
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => sent ? verifyOtp(context) : sentOtp(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sent ? 'VERIFY CREDENTIALS' : 'REQUEST ACCESS CODE',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  // Logic remains the same, just keeping the clean method calls
  void verifyOtp(BuildContext context) async {
    if (controller.otpFormKey.currentState!.validate()) {
      showLoader();
      var response = await controller.verifyOtp();
      if (response['success']) {
        hideLoader();
        Get.toNamed('/auth/register');
      } else {
        hideLoader();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(myErrorSnackBar('Warning', response['message']));
      }
    }
  }

  void sentOtp(BuildContext context) async {
    if (controller.otpFormKey.currentState!.validate()) {
      showLoader();
      var response = await controller.sendOtp();
      // Debugging line, can be removed later
      if (response['success']) {
        hideLoader();
        controller.isOtpSent.value = true;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(mySuccessSnackBar('Success', response['message']));
      } else {
        hideLoader();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(myErrorSnackBar('Warning', response['message']));
      }
    }
  }
}
