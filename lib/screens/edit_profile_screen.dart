import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training_apps/controllers/profile_controller.dart';
import 'package:training_apps/models/department_model.dart';
import 'package:training_apps/models/district_model.dart';
import 'package:training_apps/models/group_model.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/routes/routes.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  static const Color primaryNavy = Color(0xff191c51);
  static const Color slateBg = Color(0xffF4F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryNavy,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: primaryNavy,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. The Refined Avatar Section
            _buildAvatarHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("ACCOUNT INFORMATION"),
                  _buildField(
                    controller.fullNameText,
                    'Full Name',
                    Icons.person_outline,
                  ),
                  _buildField(
                    controller.emailText,
                    'Email Address',
                    Icons.alternate_email,
                    isReadOnly: true,
                  ),
                  _buildField(
                    controller.mobileText,
                    'Registered Mobile',
                    Icons.phone_android_rounded,
                    isReadOnly: true,
                  ),
                  _buildGenderDropdown(),
                  const SizedBox(height: 24),
                  _sectionTitle("ORGANIZATIONAL DETAILS"),
                  _buildField(
                    controller.departmentText,
                    'Department',
                    Icons.business_outlined,
                    isReadOnly: false,
                  ),

                  _buildDistrictDropdown(),
                  const SizedBox(height: 12),
                  _buildGroupDropdown(),
                  const SizedBox(height: 12),
                  _buildField(
                    controller.designationText,
                    'Current Designation',
                    Icons.badge_outlined,
                  ),

                  const SizedBox(height: 40),
                  _buildUpdateButton(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarHeader() {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryNavy.withOpacity(0.1), width: 2),
            ),
            child: Obx(() {
              // Logic for Image selection
              ImageProvider image;
              if (controller.profile_image_url.isNotEmpty &&
                  controller.profileName.value == '') {
                image = NetworkImage(
                  '${Routes.IMAGE_URL}/${controller.profile_image_url.value}',
                );
              } else if (controller.profileName.value != '') {
                image = FileImage(File(controller.profile_image!.path));
              } else {
                return CircleAvatar(
                  radius: 55,
                  backgroundColor: slateBg,
                  child: Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: primaryNavy.withOpacity(0.2),
                  ),
                );
              }

              return CircleAvatar(
                radius: 55,
                backgroundColor: slateBg,
                backgroundImage: image,
              );
            }),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: openCamera,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: primaryNavy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_enhance_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: primaryNavy,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        readOnly: isReadOnly,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isReadOnly ? Colors.blueGrey.shade400 : primaryNavy,
        ),
        decoration: _inputStyle(
          label,
          icon,
        ).copyWith(fillColor: isReadOnly ? Colors.grey.shade50 : slateBg),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.blueGrey.shade300,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, size: 18, color: primaryNavy.withOpacity(0.4)),
      filled: true,
      fillColor: slateBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      isDense: true,
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          showLoader();
          var response = await controller.updateProfile();
          if (response['success']) {
            hideLoader();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(mySuccessSnackBar('Updated', response['message']));
          } else {
            hideLoader();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(myErrorSnackBar('Error', response['message']));
          }
        },
        child: const Text(
          'SAVE CHANGES',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      ),
    );
  }

  // Styled Dropdowns
  Widget _buildGenderDropdown() {
    return DropdownSearch<String>(
      items: (f, cs) => ["Male", "Female"],
      selectedItem: controller.genderText.value,
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle("GENDER", Icons.wc_outlined),
      ),
      onChanged: (v) => controller.genderText.value = v!,
    );
  }

  Widget _buildDistrictDropdown() {
    return DropdownSearch<DistrictModel>(
      items: (f, cs) async => await controller.getDistrict(f),
      selectedItem: controller.selectedDistrict.value,
      compareFn: (i1, i2) => i1.isEqual(i2),
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle("DISTRICT", Icons.map_outlined),
      ),
      onChanged: (v) => controller.districtId.value = v!.id,
    );
  }

  Widget _buildGroupDropdown() {
    return DropdownSearch<GroupModel>(
      items: (f, cs) async => await controller.getGroup(f),
      selectedItem: controller.selectedGroup.value,
      compareFn: (i1, i2) => i1.isEqual(i2),
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle("GROUP", Icons.groups_3_outlined),
      ),
      onChanged: (v) => controller.groupId.value = v!.id,
    );
  }

  void openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      controller.profile_image = image;
      controller.profileName.value = image.name;
      // controller.isAttachment.value = true;
    }
  }
}
