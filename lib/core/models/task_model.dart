import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String ownerEmail;
  final List<String> sharedWith;
  final DateTime createdAt;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerEmail,
    required this.sharedWith,
    required this.createdAt,
    required this.isDone,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ownerEmail': ownerEmail,
      'sharedWith': sharedWith,
      'createdAt': createdAt,
      'isDone': isDone,
    };
  }

  TaskModel copyWith({bool? isDone}) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      ownerEmail: ownerEmail,
      sharedWith: sharedWith,
      createdAt: createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}
