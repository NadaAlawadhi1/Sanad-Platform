// class TherapistUser_NEW {
//   late String image;
//   late String firstName;
//   late String lastName;
//   late String description; // Changed from 'disc' for clarity
//   late String specialist; // Changed from 'specilist' for clarity
//   late String createdAt;
//   late bool isOnline;
//   late String id;
//   late String lastActive;
//   late String email;
//   late String pushToken;
//   late String role;
//   late double rating;

//   // Constructor with named parameters
//   TherapistUser_NEW({
//     required this.image,
//     required this.firstName,
//     required this.lastName,
//     required this.description,
//     required this.specialist,
//     required this.createdAt,
//     required this.isOnline,
//     required this.id,
//     required this.lastActive,
//     required this.email,
//     required this.pushToken,
//     required this.role,
//     required this.rating,
//   });

//   // Factory constructor to create an instance from a JSON map
//   factory TherapistUser_NEW.fromJson(Map<String, dynamic> json) {
//     return TherapistUser_NEW(
//       image: json['image'] ?? '',
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       description: json['description'] ?? '',
//       createdAt: json['created_at'] ?? '',
//       isOnline: json['is_online'] ?? false, // Assuming isOnline is a boolean
//       id: json['id'] ?? '',
//       lastActive: json['last_active'] ?? '',
//       email: json['email'] ?? '',
//       pushToken: json['push_token'] ?? '',
//       role: json['role'] ?? '',
//       specialist: json['specialist'] ?? '',
//       rating: json['rating']?.toDouble() ?? 0.0, // Ensure rating is a double
//     );
//   }

//   // Method to convert the instance to a JSON map
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['image'] = image;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['description'] = description;
//     data['created_at'] = createdAt;
//     data['is_online'] = isOnline;
//     data['id'] = id;
//     data['last_active'] = lastActive;
//     data['email'] = email;
//     data['push_token'] = pushToken;
//     data['role'] = role;
//     data['specialist'] = specialist;
//     data['rating'] = rating;
//     return data;
//   }
// }
