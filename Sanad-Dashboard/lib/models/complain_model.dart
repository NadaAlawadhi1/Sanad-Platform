import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  final String title;
  final String description;
  final String name;
  final DateTime createdAt;
  final String image;
  final String type;

  Complaint({
    required this.title,
    required this.description,
    required this.name,
    required this.createdAt,
    required this.image,
    required this.type,
  });

  // Update fromJson to handle null values gracefully
  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      title: json['title'] ?? 'No title', // Default to 'No title' if null
      description: json['description'] ?? 'No description', // Default description if null
      name: json['name'] ?? 'Anonymous', // Default name if null
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handle null createdAt
      image: json['image'] ?? '', // Default to an empty string if null
      type: json['type'] ?? 'General', // Default type if null
    );
  }
}
