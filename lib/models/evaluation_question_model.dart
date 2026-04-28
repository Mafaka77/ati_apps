// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EvaluationQuestionMode {
  final String id;
  final String question_text;
  final String input_type;
  final String category;
  final bool? is_mandatory;
  final bool? is_active;
  EvaluationQuestionMode({
    required this.id,
    required this.question_text,
    required this.input_type,
    required this.category,
    this.is_mandatory,
    this.is_active,
  });

  static List<EvaluationQuestionMode> fromJsonList(List list) {
    return list.map((e) => EvaluationQuestionMode.fromMap(e)).toList();
  }

  factory EvaluationQuestionMode.fromMap(Map<String, dynamic> map) {
    return EvaluationQuestionMode(
      id: map['_id'] as String,
      question_text: map['question_text'] as String,
      input_type: map['input_type'] as String,
      category: map['category'] as String,
      is_mandatory: map['is_mandatory'] != null
          ? map['is_mandatory'] as bool
          : null,
      is_active: map['is_active'] != null ? map['is_active'] as bool : null,
    );
  }
}
