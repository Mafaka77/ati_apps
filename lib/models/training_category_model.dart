// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrainingCategoryModel {
  final String id;
  final String name;
  TrainingCategoryModel({required this.id, required this.name});

  TrainingCategoryModel copyWith({String? id, String? name}) {
    return TrainingCategoryModel(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'_id': id, 'name': name};
  }

  factory TrainingCategoryModel.fromMap(Map<String, dynamic> map) {
    return TrainingCategoryModel(
      id: map['_id'] as String,
      name: map['name'] as String,
    );
  }
}
