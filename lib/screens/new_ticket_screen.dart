import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/ticket_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class NewTicketScreen extends GetView<TicketController> {
  const NewTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 Background
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
        title: const Text(
          "Submit New Ticket",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formState,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. INTRO SECTION
                const Text(
                  "Need Assistance?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Help us understand what's happening.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // 2. FORM FIELDS CONTAINER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Subject Input
                      _buildLabel("Ticket Subject"),
                      TextFormField(
                        controller: controller.subjectText,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                          hint: 'Brief summary of the issue',
                          icon: Icons.title_rounded,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Category Dropdown
                      _buildLabel("Category"),
                      DropdownSearch<String>(
                        items: (f, cs) => ["Technical", "Training", "General"],
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                        onChanged: (value) =>
                            controller.categoryText.value = value!,
                        popupProps: PopupProps.menu(
                          fit: FlexFit.loose,
                          menuProps: MenuProps(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: _inputDecoration(
                            hint: 'Select category',
                            icon: Icons.category_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description Input
                      _buildLabel("Description"),
                      TextFormField(
                        controller: controller.descriptionText,
                        maxLines: 6,
                        maxLength: 1000,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                          hint: 'Describe your problem in detail...',
                          icon: Icons.description_outlined,
                        ).copyWith(alignLabelWithHint: true),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 3. SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B), // Dark Slate
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "SUBMIT TICKET",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  // --- Action Logic ---

  void _handleSubmit(BuildContext context) {
    if (controller.formState.currentState!.validate()) {
      controller.submitTicket(
        () => showLoader(),
        (String message) {
          hideLoader();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(mySuccessSnackBar('Success', message));
          controller.getTickets();
          Get.back();
        },
        (String message) {
          hideLoader();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(myErrorSnackBar('Warning', message));
        },
      );
    }
  }
}
