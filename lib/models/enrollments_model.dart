// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:training_apps/models/eligibility_model.dart';
import 'package:training_apps/models/training_program_model.dart';

class EnrollmentsModel {
  final String? id;
  final String? status;
  final String? enrolledAt;
  EnrollmentTrainingModel? training_program;
  EnrollmentsModel({
    this.id,
    this.status,
    this.enrolledAt,
    this.training_program,
  });

  factory EnrollmentsModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentsModel(
      id: map['_id'] as String,
      status: map['status'] as String,
      enrolledAt: map['enrolledAt'] as String,
      training_program: EnrollmentTrainingModel.fromMap(
        map['training_program'] as Map<String, dynamic>,
      ),
    );
  }
  static List<EnrollmentsModel> fromJsonList(List list) {
    return list.map((e) => EnrollmentsModel.fromMap(e)).toList();
  }
}

class EnrollmentTrainingModel {
  final String id;
  final String t_name;
  final String t_start_date;
  final String t_end_date;
  final String t_banner;
  final String t_status;
  final int t_duration;
  final List<EligibilityModel>? t_eligibility;
  final String t_organizer;
  final int t_capacity;
  EnrollmentTrainingModel({
    required this.id,
    required this.t_name,
    required this.t_start_date,
    required this.t_end_date,
    required this.t_banner,
    required this.t_status,
    required this.t_duration,
    required this.t_eligibility,
    required this.t_organizer,
    required this.t_capacity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      't_name': t_name,
      't_start_date': t_start_date,
      't_end_date': t_end_date,
      't_banner': t_banner,
      't_status': t_status,
      't_duration': t_duration,
      't_eligibility': t_eligibility,
      't_organizer': t_organizer,
      't_capacity': t_capacity,
    };
  }

  factory EnrollmentTrainingModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentTrainingModel(
      id: map['_id'] as String,
      t_name: map['t_name'] as String,
      t_start_date: map['t_start_date'] as String,
      t_end_date: map['t_end_date'] as String,
      t_banner: map['t_banner'] as String,
      t_status: map['t_status'] as String,
      t_duration: map['t_duration'] as int,
      t_eligibility: map['t_eligibility'] != null
          ? EligibilityModel.fromJsonList(map['t_eligibility'])
          : null,
      t_organizer: map['t_organizer'] as String,
      t_capacity: map['t_capacity'] as int,
    );
  }
}
