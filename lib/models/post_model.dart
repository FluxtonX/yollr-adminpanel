enum PostType { post, submission }

class AdminPostModel {
  final String id;
  final String uid;
  final String username;
  final String? profileImage;
  final String imageUrl;
  final String? videoUrl;
  final String caption;
  final String campus;
  final DateTime createdAt;
  final PostType type;

  AdminPostModel({
    required this.id,
    required this.uid,
    required this.username,
    this.profileImage,
    required this.imageUrl,
    this.videoUrl,
    required this.caption,
    required this.campus,
    required this.createdAt,
    this.type = PostType.post,
  });

  factory AdminPostModel.fromJson(
    Map<String, dynamic> json, {
    PostType type = PostType.post,
  }) {
    return AdminPostModel(
      id: json['_id'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? 'Anonymous',
      profileImage: json['profileImage'],
      imageUrl: type == PostType.post ? (json['imageUrl'] ?? '') : '',
      videoUrl: type == PostType.submission ? (json['videoUrl'] ?? '') : null,
      caption: json['caption'] ?? '',
      campus: json['campus'] ?? 'Unknown',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      type: type,
    );
  }
}
