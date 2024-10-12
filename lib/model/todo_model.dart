import 'package:cloud_firestore/cloud_firestore.dart';

class TODO {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timestamp;

  TODO(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.timestamp});
}
