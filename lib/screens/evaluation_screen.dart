import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/evaluation_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/widgets/number_ratings_widget.dart';

class EvaluationScreen extends GetView<EvaluationController> {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.home_background, // e.g., a light grey/off-white
      appBar: AppBar(
        backgroundColor: MyColors.home_background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Evaluation Feedback",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: appBarBackButton(context),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF073E6C)),
          );
        }

        if (controller.evaluationQuestions.isEmpty) {
          return const Center(child: Text("No evaluation questions found."));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header / Intro Text
                const Text(
                  "We value your feedback",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please rate the following aspects of the training to help us improve future sessions.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Questions Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.evaluationQuestions.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(color: Colors.grey.shade200, thickness: 1),
                    ),
                    itemBuilder: (context, index) {
                      final question = controller.evaluationQuestions[index];
                      return _buildQuestionItem(question, index);
                    },
                  ),
                ),
                sizedBoxHeight(30),

                // Submit Button
                _buildSubmitButton(context),
                sizedBoxHeight(40), // Bottom padding
              ],
            ),
          ),
        );
      }),
    );
  }

  // Extracted to keep the build method clean
  Widget _buildQuestionItem(dynamic question, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text with Number
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${index + 1}. ",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF073E6C), // App theme blue for numbers
              ),
            ),
            Expanded(
              child: Text(
                question.question_text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        sizedBoxHeight(10),
        // Rating Bar
        _buildInputArea(question),
      ],
    );
  }

  // Helper method to decide which input to show
  Widget _buildInputArea(dynamic question) {
    // Assuming your backend sends 'text' or 'rating' for input_type.
    // Adjust 'text' to match whatever string your API actually sends.
    if (question.input_type == 'text' || question.input_type == 'textarea') {
      // Return a sleek Text Field
      return TextFormField(
        maxLines: 3, // Makes it a larger box for comments
        initialValue:
            controller.answers[question.id] ?? '', // Load existing text if any
        onChanged: (text) {
          controller.updateAnswer(question.id, text);
        },
        decoration: InputDecoration(
          hintText: "Answer here...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          filled: true,
          fillColor: Colors.grey.shade50, // Slight off-white background
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF073E6C), width: 1.5),
          ),
        ),
      );
    } else if (question.input_type == 'boolean') {
      return Obx(
        () => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "No / Yes",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          value: controller.answers[question.id] ?? false,
          onChanged: (val) {
            controller.updateAnswer(question.id, val);
          },
          activeColor: const Color(0xFF073E6C),
        ),
      );
    } else {
      // Return the Number Rating Bar
      return Obx(
        () => NumberRatingBar(
          // Use the new dynamic 'answers' map.
          // If it's null, default to 0.
          selectedRating: controller.answers[question.id] ?? 0,
          onRatingSelected: (rating) {
            controller.updateAnswer(question.id, rating);
          },
        ),
      );
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 56, // Slightly taller for a premium feel
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: const Color(0xFF073E6C),
      onPressed: () async {
        showLoader();
        var response = await controller.saveEvaluation();
        if (response['status']) {
          hideLoader();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(mySuccessSnackBar('Success', response['message']));
          Get.back();
        } else {
          hideLoader();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(myWarningSnackBar('Warning', response['message']));
        }
      },
      child: const Text(
        "Submit Feedback",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
