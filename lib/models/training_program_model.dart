// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:training_apps/models/eligibility_model.dart';
import 'package:training_apps/models/training_category_model.dart';
import 'package:training_apps/models/training_course_model.dart';
import 'package:training_apps/models/training_room_model.dart';

class TrainingProgramModel {
  final String id;
  final String t_name;
  final String t_description;
  final String? t_banner;
  final String t_start_date;
  final String t_end_date;
  final int? t_duration;
  final List<EligibilityModel>? t_eligibility;
  final String t_organizer;
  final int t_capacity;
  final String t_status;
  final int averageRating;
  final int ratingsCount;
  final String createdAt;
  final TrainingCategoryModel? t_category;
  final TrainingRoomModel? t_room;
  // final List<TrainingCourseModel>? trainingCourse;
  TrainingProgramModel({
    // this.trainingCourse,
    required this.id,
    required this.t_name,
    required this.t_description,
    this.t_banner,
    required this.t_start_date,
    required this.t_end_date,
    this.t_duration,
    this.t_eligibility,
    required this.t_organizer,
    required this.t_capacity,
    required this.t_status,
    required this.averageRating,
    required this.ratingsCount,
    required this.createdAt,
    this.t_category,
    this.t_room,
  });

  factory TrainingProgramModel.fromMap(Map<String, dynamic> map) {
    return TrainingProgramModel(
      id: map['_id'] ?? map['id'] ?? '',

      t_name: map['t_name'] ?? '',
      t_description: map['t_description'] ?? '',

      t_banner: map['t_banner'] as String?,

      t_start_date: map['t_start_date'] ?? '',
      t_end_date: map['t_end_date'] ?? '',

      t_duration: map['t_duration'] ?? 0,

      t_eligibility: map['t_eligibility'] != null
          ? EligibilityModel.fromJsonList(map['t_eligibility'])
          : null,
      t_organizer: map['t_organizer'] ?? '',

      t_capacity: map['t_capacity'] ?? 0,

      t_status: map['t_status'] ?? 'inactive',

      averageRating: map['averageRating'] ?? 0,
      ratingsCount: map['ratingsCount'] ?? 0,

      createdAt: map['createdAt'] ?? '',

      t_category: map['t_category'] != null
          ? TrainingCategoryModel.fromMap(map['t_category'])
          : null,

      t_room: map['t_room'] != null
          ? TrainingRoomModel.fromMap(map['t_room'])
          : null,
    );
  }

  static List<TrainingProgramModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list
        .map((item) => TrainingProgramModel.fromMap(item))
        .toList(growable: false);
  }

  TrainingProgramModel copyWith({
    String? id,
    String? t_name,
    String? t_description,
    String? t_banner,
    String? t_start_date,
    String? t_end_date,
    int? t_duration,
    List<EligibilityModel>? t_eligibility,
    String? t_organizer,
    int? t_capacity,
    String? t_status,
    int? averageRating,
    int? ratingsCount,
    String? createdAt,
    TrainingCategoryModel? t_category,
    TrainingRoomModel? t_room,
  }) {
    return TrainingProgramModel(
      id: id ?? this.id,
      t_name: t_name ?? this.t_name,
      t_description: t_description ?? this.t_description,
      t_banner: t_banner ?? this.t_banner,
      t_start_date: t_start_date ?? this.t_start_date,
      t_end_date: t_end_date ?? this.t_end_date,
      t_duration: t_duration ?? this.t_duration,
      t_eligibility: t_eligibility ?? this.t_eligibility,
      t_organizer: t_organizer ?? this.t_organizer,
      t_capacity: t_capacity ?? this.t_capacity,
      t_status: t_status ?? this.t_status,
      averageRating: averageRating ?? this.averageRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      createdAt: createdAt ?? this.createdAt,
      t_category: t_category ?? this.t_category,
      t_room: t_room ?? this.t_room,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      't_name': t_name,
      't_description': t_description,
      't_banner': t_banner,
      't_start_date': t_start_date,
      't_end_date': t_end_date,
      't_duration': t_duration,
      't_eligibility': t_eligibility
          ?.map((EligibilityModel e) => e.toJson())
          .toList(),
      't_organizer': t_organizer,
      't_capacity': t_capacity,
      't_status': t_status,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'createdAt': createdAt,
      't_category': t_category?.toMap(),
      't_room': t_room?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory TrainingProgramModel.fromJson(String source) =>
      TrainingProgramModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TrainingProgramModel(id: $id, t_name: $t_name, t_description: $t_description, t_banner: $t_banner, t_start_date: $t_start_date, t_end_date: $t_end_date, t_duration: $t_duration, t_eligibility: $t_eligibility, t_organizer: $t_organizer, t_capacity: $t_capacity, t_status: $t_status, averageRating: $averageRating, ratingsCount: $ratingsCount, createdAt: $createdAt, t_category: $t_category, t_room: $t_room)';
  }
}
