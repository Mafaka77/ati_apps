// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BannerModel {
  final String id;
  final String image_url;
  final String title;
  final bool is_active;
  BannerModel({
    required this.id,
    required this.image_url,
    required this.title,
    required this.is_active,
  });

  BannerModel copyWith({
    String? id,
    String? image_url,
    String? title,
    bool? is_active,
  }) {
    return BannerModel(
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      title: title ?? this.title,
      is_active: is_active ?? this.is_active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'image_url': image_url,
      'title': title,
      'is_active': is_active,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['_id'] as String,
      image_url: map['image_url'] as String,
      title: map['title'] as String,
      is_active: map['is_active'] as bool,
    );
  }
  static List<BannerModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => BannerModel.fromMap(item)).toList();
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
