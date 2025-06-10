class Doctor {
  final String id;
  final String name;
  final String email;
  final String about;
  final int yearOfExperience;
  final double rating;
  final String specialist;
  final String price;
  final bool isOnline;
  final String lastActive;
  final String role;
  final String image;
  final String pushToken;
  final List<Review> reviews;

  Doctor({
    required this.id,
    required this.name,
    required this.rating,
    required this.email,
    required this.about,
    required this.yearOfExperience,
    required this.specialist,
    required this.price,
    this.isOnline = false,
    required this.lastActive,
    this.role = 'doctor',
    this.image = '',
    this.pushToken = '',
    this.reviews = const [],
  });

  // Convert Doctor instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'about': about,
      'rating': rating,
      'year_of_experience': yearOfExperience,
      'specialist': specialist,
      'price': price,
      'is_online': isOnline,
      'last_active': lastActive,
      'role': role,
      'image': image,
      'push_token': pushToken,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  // Create a Doctor instance from Firestore map data
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      rating: map['rating'] ?? '',
      about: map['about'] ?? '',
      yearOfExperience: map['year_of_experience'] ?? 0,
      specialist: map['specialist'] ?? '',
      price: map['price'] ?? '',
      isOnline: map['is_online'] ?? false,
      lastActive: map['last_active'] ?? '',
      role: map['role'] ?? 'doctor',
      image: map['image'] ?? '',
      pushToken: map['push_token'] ?? '',
      reviews: (map['reviews'] as List<dynamic>?)
          ?.map((review) => Review.fromMap(review as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Review {
  final String name;
  final String comment;
  final String createdAt;

  Review({
    required this.name,
    required this.comment,
    required this.createdAt,
  });

  // Convert Review instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': comment,
      'created_at': createdAt,
    };
  }

  // Create a Review instance from Firestore map data
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
