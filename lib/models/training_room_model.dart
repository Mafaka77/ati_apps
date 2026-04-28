// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrainingRoomModel {
  final String id;
  final String room_name;
  TrainingRoomModel({required this.id, required this.room_name});

  TrainingRoomModel copyWith({String? id, String? room_name}) {
    return TrainingRoomModel(
      id: id ?? this.id,
      room_name: room_name ?? this.room_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'_id': id, 'room_name': room_name};
  }

  factory TrainingRoomModel.fromMap(Map<String, dynamic> map) {
    return TrainingRoomModel(
      id: map['_id'] as String,
      room_name: map['room_name'] as String,
    );
  }
}
