// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupModel {
  final String id;
  final String group_name;
  GroupModel({required this.id, required this.group_name});

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['_id'] as String,
      group_name: map['group_name'] as String,
    );
  }
  static List<GroupModel> fromJsonList(List<dynamic> mapList) {
    return mapList
        .map((map) => GroupModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  bool isEqual(GroupModel model) {
    return id == model.id;
  }

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => group_name;

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.group_name == group_name;
  }

  @override
  int get hashCode => group_name.hashCode;
}
