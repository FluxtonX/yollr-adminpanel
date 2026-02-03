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
}
