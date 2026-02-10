import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/post_model.dart';

class AdminPostService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<List<AdminPostModel>> fetchAllPosts() async {
    try {
      final response = await _dio.get('/posts/all');
      if (response.statusCode == 200) {
        final List postsJson = response.data['posts'];
        return postsJson.map((json) => AdminPostModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<List<AdminPostModel>> fetchEventSubmissions() async {
    try {
      final response = await _dio.get('/event-submissions/all');
      if (response.statusCode == 200) {
        final List submissionsJson = response.data['data'];
        return submissionsJson
            .map(
              (json) =>
                  AdminPostModel.fromJson(json, type: PostType.submission),
            )
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching submissions: $e');
      return [];
    }
  }

  Future<bool> deletePost(String id) async {
    try {
      final response = await _dio.delete('/posts/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  Future<bool> deleteSubmission(String id) async {
    try {
      final response = await _dio.delete('/event-submissions/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting submission: $e');
      return false;
    }
  }
}
