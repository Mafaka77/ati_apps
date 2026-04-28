// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MaterialModel {
  final String id;
  final String? title;
  final String? file_name;
  final String? file_size;
  final String? file_url;
  final String? mime_type;
  MaterialModel({
    required this.id,
    this.title,
    this.file_name,
    this.file_size,
    this.file_url,
    this.mime_type,
  });

  MaterialModel copyWith({
    String? id,
    String? title,
    String? file_name,
    String? file_size,
    String? file_url,
    String? mime_type,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      file_name: file_name ?? this.file_name,
      file_size: file_size ?? this.file_size,
      file_url: file_url ?? this.file_url,
      mime_type: mime_type ?? this.mime_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'file_name': file_name,
      'file_size': file_size,
      'file_url': file_url,
      'mime_type': mime_type,
    };
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['_id'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      file_name: map['file_name'] != null ? map['file_name'] as String : null,
      file_size: map['file_size'] != null ? map['file_size'] as String : null,
      file_url: map['file_url'] != null ? map['file_url'] as String : null,
      mime_type: map['mime_type'] != null ? map['mime_type'] as String : null,
    );
  }
  static List<MaterialModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => MaterialModel.fromMap(e)).toList();
  }

  String toJson() => json.encode(toMap());
}
