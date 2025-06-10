class TherapistApplication {
  final String full_name;
  final String email;
  final String phoneNumber;
  final String gender;
  final String city;
  final String registrationStatus;
  final int yearsOfExperience;
  final String? uploadedFilePath;

  TherapistApplication({
    required this.full_name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.city,
    required this.registrationStatus,
    required this.yearsOfExperience,
    this.uploadedFilePath,
  });

  // Converts the model to a map for backend submission (e.g., API)
  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'city': city,
      'registration_status': registrationStatus,
      'experience': yearsOfExperience,
      'cv_path': uploadedFilePath,
    };
  }

  // Factory constructor to create a model from JSON
  factory TherapistApplication.fromJson(Map<String, dynamic> json) {
    return TherapistApplication(
      full_name: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      city: json['city'],
      registrationStatus: json['registration_status'],
      yearsOfExperience: json['experience'],
      uploadedFilePath: json['cv_path'],
    );
  }
}
