// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'question': question,
      'answer': answer,
      'category': category,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['_id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      category: map['category'] as String,
    );
  }
  static List<FaqModel> fromJsonList(List list) {
    return list.map((e) => FaqModel.fromMap(e)).toList();
  }
}
