// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:training_apps/models/training_program_model.dart';

class EnrollmentDetailModel {
  final String id;
  final String status;
  final String enrolledAt;
  final TrainingProgramModel training_program;
  EnrollmentDetailModel({
    required this.id,
    required this.status,
    required this.enrolledAt,
    required this.training_program,
  });

  EnrollmentDetailModel copyWith({
    String? id,
    String? status,
    String? enrolledAt,
    TrainingProgramModel? training_program,
  }) {
    return EnrollmentDetailModel(
      id: id ?? this.id,
      status: status ?? this.status,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      training_program: training_program ?? this.training_program,
    );
  }

  factory EnrollmentDetailModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentDetailModel(
      id: map['_id'] as String,
      status: map['status'] as String,
      enrolledAt: map['enrolledAt'] as String,
      training_program: TrainingProgramModel.fromMap(
        map['training_program'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'status': status,
      'enrolledAt': enrolledAt,
      'training_program': training_program.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory EnrollmentDetailModel.fromJson(String source) =>
      EnrollmentDetailModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'EnrollmentDetailModel(_id: $id, status: $status, enrolledAt: $enrolledAt, training_program: $training_program)';
  }

  @override
  bool operator ==(covariant EnrollmentDetailModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.status == status &&
        other.enrolledAt == enrolledAt &&
        other.training_program == training_program;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        enrolledAt.hashCode ^
        training_program.hashCode;
  }
}
