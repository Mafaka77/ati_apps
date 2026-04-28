// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrainingCourseModel {
  final String id;
  final String tc_topic;
  final DateTime tc_date;
  final String tc_start_time;
  final String tc_end_time;
  final int tc_session;
  final String qrVersion;
  final TrainingStatusModel t_program;
  TrainingCourseModel({
    required this.id,
    required this.tc_topic,
    required this.tc_date,
    required this.tc_start_time,
    required this.tc_end_time,
    required this.tc_session,
    required this.qrVersion,
    required this.t_program,
  });
  static List<TrainingCourseModel> fromJsonList(List list) {
    return list.map((e) => TrainingCourseModel.fromMap(e)).toList();
  }

  factory TrainingCourseModel.fromMap(Map<String, dynamic> map) {
    return TrainingCourseModel(
      id: map['_id'] as String,
      tc_topic: map['tc_topic'] as String,
      tc_date: DateTime.parse(map['tc_date'].toString().trim()),
      tc_start_time: map['tc_start_time'] as String,
      tc_end_time: map['tc_end_time'] as String,
      tc_session: map['tc_session'] as int,
      qrVersion: map['qrVersion'] as String,
      t_program: TrainingStatusModel.fromMap(
        map['t_program'] as Map<String, dynamic>,
      ),
    );
  }
}

class TrainingStatusModel {
  final String id;
  final String status;
  TrainingStatusModel({required this.id, required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'_id': id, 'status': status};
  }

  factory TrainingStatusModel.fromMap(Map<String, dynamic> map) {
    return TrainingStatusModel(
      id: map['_id'] as String,
      status: map['t_status'] as String,
    );
  }
}
