import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/auth_controller.dart';
import 'package:training_apps/models/department_model.dart';
import 'package:training_apps/models/district_model.dart';
import 'package:training_apps/models/group_model.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  static const Color primaryNavy = Color(0xff191c51);
  static const Color slateBg = Color(0xffF4F7FA);

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
        title: const Text(
          'ENROLLMENT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: primaryNavy,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Progress Header
            _buildHeader(),

            Form(
              key: controller.registerFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("PERSONAL DETAILS"),
                    _buildRequiredField(
                      controller.fullNameText,
                      'Full Name',
                      Icons.person_outline,
                    ),
                    _buildField(
                      controller.emailText,
                      'Email Address',
                      Icons.alternate_email,
                    ),
                    _buildRequiredDateField(
                      controller.dobText,
                      'Date of Birth',
                      Icons.calendar_month_outlined,
                    ),
                    _buildGenderDropdown(),
                    sizedBoxHeight(12),
                    // 1. DISTRICT SELECTION
                    DropdownSearch<DistrictModel>(
                      validator: (value) => value == null ? 'Required' : null,
                      items: (f, cs) async => await controller.getDistrict(f),
                      compareFn: (item1, item2) => item1.isEqual(item2),

                      // Customizing the popup to feel like a premium menu
                      popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        menuProps: MenuProps(
                          borderRadius: BorderRadius.circular(16),
                          elevation: 4,
                        ),
                      ),

                      // Applying your Executive Theme
                      decoratorProps: DropDownDecoratorProps(
                        decoration: _inputStyle('DISTRICT', Icons.map_outlined),
                      ),

                      onChanged: (value) {
                        controller.districtId.value = value!.id;
                      },
                    ),
                    sizedBoxHeight(13),
                    _sectionTitle("SECURITY CREDENTIALS"),
                    _buildPasswordField(
                      controller.passwordText,
                      'Create Password',
                      controller.isPasswordHidden,
                    ),
                    _buildPasswordField(
                      controller.confirmPasswordText,
                      'Confirm Password',
                      controller.isConfirmPasswordHidden,
                    ),
                    Row(
                      children: [
                        Obx(() {
                          return Checkbox(
                            value: controller.isGovtEmployee.value,
                            onChanged: (value) {
                              controller.isGovtEmployee.value = value!;
                              if (controller.isGovtEmployee.isFalse) {
                                // Clear govt employee specific fields when unchecked
                                controller.groupId.value = '';
                                controller.designationText.clear();
                                controller.departmentName.clear();
                                controller.dateOfEntry.clear();
                                controller.dateOfSuperannuation.clear();
                                controller.recruitmentText.value = '';
                                controller.confirmOrNotText.value = '';
                                controller.serviceCadreText.clear();
                              }
                            },
                          );
                        }),
                        Text(
                          'I am a government employee',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ],
                    ),
                    sizedBoxHeight(13),
                    Obx(() {
                      return controller.isGovtEmployee.isTrue
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("PROFESSIONAL AFFILIATION"),
                                sizedBoxHeight(13),
                                DropdownSearch<GroupModel>(
                                  validator: (value) {
                                    if (controller.isGovtEmployee.value &&
                                        value == null) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                  items: (filter, loadProps) async =>
                                      await controller.getGroup(filter),
                                  compareFn: (item1, item2) =>
                                      item1.isEqual(item2),

                                  popupProps: PopupProps.menu(
                                    fit: FlexFit.loose,
                                    showSearchBox: true,
                                    // Styling the search box inside the dropdown
                                    searchFieldProps: TextFieldProps(
                                      decoration: _inputStyle(
                                        'Search Groups...',
                                        Icons.search,
                                      ),
                                    ),
                                    menuProps: MenuProps(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),

                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: _inputStyle(
                                      'GROUP',
                                      Icons.groups_3_outlined,
                                    ),
                                  ),

                                  onChanged: (value) {
                                    controller.groupId.value = value!.id;
                                  },
                                ),
                                sizedBoxHeight(13),
                                _buildField(
                                  controller.designationText,
                                  'Designation',
                                  Icons.badge_outlined,
                                  isRequired: true,
                                ),
                                _buildField(
                                  controller.departmentName,
                                  'Department',
                                  Icons.apartment_outlined,
                                  isRequired: true,
                                ),
                                _buildDateField(
                                  controller.dateOfEntry,
                                  'Date of Entry',
                                  Icons.calendar_today_outlined,
                                  isRequired: true,
                                ),
                                _buildDateField(
                                  controller.dateOfEntryToPresentGrade,
                                  'Date of Entry to Present Grade',
                                  Icons.calendar_today_outlined,
                                  isRequired: true,
                                ),
                                _buildDateField(
                                  controller.dateOfSuperannuation,
                                  'Date of Superannuation',
                                  Icons.calendar_today_outlined,
                                  isRequired: true,
                                ),
                                _buildRecruitmentDropdown(isRequired: true),
                                sizedBoxHeight(13),
                                _buildConfirmDropdown(isRequired: true),
                                sizedBoxHeight(13),
                                _buildField(
                                  controller.serviceCadreText,
                                  'Service/Cadre',
                                  Icons.work_outline,
                                  isRequired: true,
                                ),
                                Obx(() {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: controller.madatoryCompletion.value
                                          ? Colors.blue.withOpacity(0.05)
                                          : Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            controller.madatoryCompletion.value
                                            ? Colors.blue.withOpacity(0.3)
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      title: Text(
                                        'I have completed the Mandatory Foundation Training',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              controller
                                                  .madatoryCompletion
                                                  .value
                                              ? Colors.blue[700]
                                              : Colors.black87,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        'Check this box only if you have already received your certification.',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      value:
                                          controller.madatoryCompletion.value,
                                      activeColor: Colors.blueAccent,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (bool? value) {
                                        controller.madatoryCompletion.value =
                                            value ?? false;
                                      },
                                    ),
                                  );
                                }),
                                sizedBoxHeight(10),
                                Obx(() {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: controller.disclaimer.value
                                          ? Colors.blue.withOpacity(0.05)
                                          : Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: controller.disclaimer.value
                                            ? Colors.blue.withOpacity(0.3)
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      title: Text(
                                        'All information provided is accurate to the best of my knowledge',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: controller.disclaimer.value
                                              ? Colors.blue[700]
                                              : Colors.black87,
                                        ),
                                      ),

                                      value: controller.disclaimer.value,
                                      activeColor: Colors.blueAccent,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (bool? value) {
                                        controller.disclaimer.value =
                                            value ?? false;
                                      },
                                    ),
                                  );
                                }),
                              ],
                            )
                          : SizedBox.shrink();
                    }),

                    const SizedBox(height: 40),
                    _buildSubmitButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Sub-Widgets for the Executive Look ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: slateBg),
      child: Column(
        children: [
          const Text(
            "CREATE ACCOUNT",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: primaryNavy,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Complete the form to register your credentials",
            style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8, left: 4),
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

  // Updated Generic Field Wrapper
  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isRequired = false, // Add this parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: _inputStyle(label, icon),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryNavy,
        ),
        // The validator logic:
        validator: (value) {
          if (controller.isGovtEmployee.value && isRequired) {
            if (value == null || value.isEmpty) {
              return 'This field is required for government employees';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRequiredField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isRequired = false, // Add this parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: _inputStyle(label, icon),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryNavy,
        ),
        // The validator logic:
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  //Date Picker Field
  Widget _buildDateField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        validator: (value) {
          if (controller.isGovtEmployee.value && isRequired) {
            if (value == null || value.isEmpty) {
              return 'This field is required for government employees';
            }
          }
          return null;
        },
        controller: ctrl,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            ctrl.text = "${pickedDate.toLocal()}".split(' ')[0];
          }
        },
        decoration: _inputStyle(label, icon),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryNavy,
        ),
      ),
    );
  }

  Widget _buildRequiredDateField(
    TextEditingController ctrl,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required for government employees';
          }
          return null;
        },
        controller: ctrl,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            ctrl.text = "${pickedDate.toLocal()}".split(' ')[0];
          }
        },
        decoration: _inputStyle(label, icon),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryNavy,
        ),
      ),
    );
  }

  // Password Field with Toggle
  Widget _buildPasswordField(
    TextEditingController ctrl,
    String label,
    RxBool hidden,
  ) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          validator: (value) => (value == null || value.isEmpty)
              ? 'This field is required'
              : null,
          controller: ctrl,
          obscureText: hidden.value,
          decoration: _inputStyle(label, Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                hidden.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () => hidden.value = !hidden.value,
            ),
          ),
        ),
      ),
    );
  }

  // Shared Input Decoration
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.blueGrey.shade300, fontSize: 13),
      prefixIcon: Icon(icon, size: 20, color: primaryNavy.withOpacity(0.4)),
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

  // Submit Button
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () => _handleRegistration(context),
        child: const Text(
          "FINALIZE REGISTRATION",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
      ),
    );
  }

  // Registration Logic (Refactored for Cleanliness)
  void _handleRegistration(BuildContext context) async {
    if (controller.registerFormKey.currentState!.validate()) {
      if (controller.passwordText.text != controller.confirmPasswordText.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(myErrorSnackBar('Warning', 'Passwords do not match'));
      } else if (controller.disclaimer.isFalse) {
        ScaffoldMessenger.of(context).showSnackBar(
          myErrorSnackBar('Warning', 'Please accept the disclaimer'),
        );
      } else {
        var response = await controller.register();
        if (response['success']) {
          hideLoader();
          Get.offAllNamed('/auth');
          ScaffoldMessenger.of(context).showSnackBar(
            mySuccessSnackBar(
              'Success',
              response['message'] ?? 'Registration successful',
            ),
          );
        } else {
          hideLoader();
          ScaffoldMessenger.of(context).showSnackBar(
            myErrorSnackBar(
              'Warning',
              response['message'] ?? 'Registration failed',
            ),
          );
        }
      }
    }
  }

  // --- Dropdown implementations remain logically similar but styled with _inputStyle ---
  Widget _buildGenderDropdown() {
    return DropdownSearch<String>(
      validator: (value) => value == null ? 'Required' : null,
      items: (f, cs) => ["Male", 'Female', 'Others'],
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle("Gender", Icons.wc_outlined),
      ),
      onChanged: (v) => controller.genderText.value = v!,
    );
  }

  Widget _buildRecruitmentDropdown({required bool isRequired}) {
    return DropdownSearch<String>(
      validator: (value) {
        if (controller.isGovtEmployee.value && isRequired) {
          if (value == null || value.isEmpty) {
            return 'This field is required for government employees';
          }
        }
        return null;
      },
      items: (f, cs) => ["Direct", 'Regularisation', 'Absorption'],
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle("Recruitment", Icons.work_outline),
      ),
      onChanged: (v) => controller.recruitmentText.value = v!,
    );
  }

  Widget _buildConfirmDropdown({required bool isRequired}) {
    return DropdownSearch<String>(
      validator: (value) {
        if (isRequired) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
        }
        return null;
      },
      items: (f, cs) => ["Confirmed", 'Not Confirmed'],
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputStyle(
          "Confirmation",
          Icons.confirmation_num_outlined,
        ),
      ),
      onChanged: (v) => controller.confirmOrNotText.value = v!,
    );
  }
}
