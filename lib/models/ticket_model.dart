// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:training_apps/models/user_model.dart';

class TicketModel {
  final String id;
  final String subject;
  final String? description;
  final String? status;
  final String? priority;
  final String? category;
  final String? createdAt;
  final String? updatedAt;
  final UserModel? user;
  final List<TicketReplyModel>? replies;
  TicketModel({
    required this.id,
    required this.subject,
    this.description,
    this.status,
    this.priority,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.replies,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['_id'] as String,
      subject: map['subject'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      priority: map['priority'] != null ? map['priority'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      user:
          map['user'] != null
              ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
              : null,
      replies:
          map['replies'] != null
              ? List<TicketReplyModel>.from(
                (map['replies'] as List<dynamic>).map(
                  (x) => TicketReplyModel.fromMap(x as Map<String, dynamic>),
                ),
              )
              : [],
    );
  }
  static List<TicketModel> fromJsonList(List list) {
    return list.map((e) => TicketModel.fromMap(e)).toList();
  }
}

class TicketReplyModel {
  final String message;
  final String? senderName;
  final String? senderEmail;
  final DateTime createdAt;

  TicketReplyModel({
    required this.message,
    this.senderName,
    this.senderEmail,
    required this.createdAt,
  });

  factory TicketReplyModel.fromMap(Map<String, dynamic> map) {
    return TicketReplyModel(
      message: map['message'] ?? '',
      senderName: map['sender']?['name'], // if you populated sender
      senderEmail: map['sender']?['email'],
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
