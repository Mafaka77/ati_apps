// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String? full_name;
  final String? email;
  final String? mobile;
  UserModel({required this.id, this.full_name, this.email, this.mobile});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'full_name': full_name,
      'email': email,
      'mobile': mobile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      full_name: map['full_name'] != null ? map['full_name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
    );
  }
}
