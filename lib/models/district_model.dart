// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DistrictModel {
  final String name;
  final String id;
  DistrictModel({required this.name, required this.id});

  DistrictModel copyWith({String? name, String? id}) {
    return DistrictModel(name: name ?? this.name, id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'id': id};
  }

  factory DistrictModel.fromMap(Map<String, dynamic> map) {
    return DistrictModel(name: map['name'] as String, id: map['_id'] as String);
  }
  static List<DistrictModel> fromMapList(List<dynamic> mapList) {
    return mapList
        .map((map) => DistrictModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  bool isEqual(DistrictModel model) {
    return id == model.id;
  }

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromJson(String source) =>
      DistrictModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => ' $name';

  @override
  bool operator ==(covariant DistrictModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
