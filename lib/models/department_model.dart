// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DepartmentModel {
  final String id;
  final String name;
  DepartmentModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['_id'] as String,
      name: map['name'] as String,
    );
  }

  static List<DepartmentModel> fromMapList(List<dynamic> mapList) {
    return mapList
        .map((map) => DepartmentModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  bool isEqual(DepartmentModel model) {
    return id == model.id;
  }

  String toJson() => json.encode(toMap());

  factory DepartmentModel.fromJson(String source) =>
      DepartmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => ' $name';

  @override
  bool operator ==(covariant DepartmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
