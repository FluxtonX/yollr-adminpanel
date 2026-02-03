class AdminPostModel {
  final String id;
  final String uid;
  final String username;
  final String? profileImage;
  final String imageUrl;
  final String caption;
  final String campus;
  final DateTime createdAt;

  AdminPostModel({
    required this.id,
    required this.uid,
    required this.username,
    this.profileImage,
    required this.imageUrl,
    required this.caption,
    required this.campus,
    required this.createdAt,
  });

  factory AdminPostModel.fromJson(Map<String, dynamic> json) {
    return AdminPostModel(
      id: json['_id'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? 'Anonymous',
      profileImage: json['profileImage'],
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      campus: json['campus'] ?? 'Unknown',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
