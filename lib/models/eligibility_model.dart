class EligibilityModel {
  final int id;
  final String groupName;

  const EligibilityModel({required this.id, required this.groupName});

  factory EligibilityModel.fromJson(Map<String, dynamic> json) {
    return EligibilityModel(
      id: json['id'] as int? ?? 0,
      groupName: json['group_name'] as String? ?? '',
    );
  }
  static List<EligibilityModel> fromJsonList(List list) {
    return list.map((e) => EligibilityModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'group_name': groupName};
  }

  @override
  String toString() => 'EligibilityModel(groupName: $groupName)';
}
