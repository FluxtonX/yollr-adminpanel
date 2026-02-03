class AdminUserModel {
  final String uid;
  final String username;
  final String email;
  final String campus;
  final bool isOnline;
  final String? profileImage;
  final DateTime createdAt;

  AdminUserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.campus,
    required this.isOnline,
    this.profileImage,
    required this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      campus: json['campus'] ?? 'Unknown',
      isOnline: json['isOnline'] ?? false,
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
