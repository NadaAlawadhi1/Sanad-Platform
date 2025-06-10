class ChatUser_NEW {
  ChatUser_NEW({
    required this.image,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.role,
    required this.specialist,
  });
  late String image;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String role;
  late String specialist;


  ChatUser_NEW.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    role = json['role'] ?? '';
    specialist = json['specialist'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['role'] = role;
    data['specialist'] = specialist;

    return data;
  }
  // Add the copyWith method
  ChatUser_NEW copyWith({
    String? id,
    String? name,
    String? email,
    String? image,
    String? createdAt,
    bool? isOnline,
    String? lastActive,
    String? pushToken,
    String? role,
    String? specialist,

  }) {
    return ChatUser_NEW(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
      role: role ?? this.role,
      specialist: specialist ?? this.specialist,

    );
  }
  ChatUser_NEW.fromMap(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    role = json['role'] ?? '';
    specialist = json['specialist'] ?? '';
  }

}
