import 'dart:convert';

class AdminEventModel {
  final String id;
  final String title;
  final String description;
  final String? bannerImage;
  final DateTime startDate;
  final DateTime endDate;
  final String? uploadRules;
  final bool isLive;
  final int videoCount;
  final int participantCount;

  AdminEventModel({
    required this.id,
    required this.title,
    required this.description,
    this.bannerImage,
    required this.startDate,
    required this.endDate,
    this.uploadRules,
    this.isLive = false,
    this.videoCount = 0,
    this.participantCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'bannerImage': bannerImage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'uploadRules': uploadRules,
      'isLive': isLive,
      'videoCount': videoCount,
      'participantCount': participantCount,
    };
  }

  factory AdminEventModel.fromMap(Map<String, dynamic> map) {
    return AdminEventModel(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      bannerImage: map['bannerImage'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'])
          : DateTime.now(),
      uploadRules: map['uploadRules'],
      isLive: map['isLive'] ?? false,
      videoCount: map['videoCount'] ?? 0,
      participantCount: map['participantCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminEventModel.fromJson(String source) =>
      AdminEventModel.fromMap(json.decode(source));
}
