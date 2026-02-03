import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/user_model.dart';

class AdminUserService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<List<AdminUserModel>> fetchAllUsers() async {
    try {
      final response = await _dio.get('/users/all');
      if (response.statusCode == 200) {
        final List usersJson = response.data['users'];
        return usersJson.map((json) => AdminUserModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchStats() async {
    try {
      final response = await _dio.get('/users/all?limit=1');
      if (response.statusCode == 200) {
        return {'totalUsers': response.data['total'] ?? 0};
      }
      return {'totalUsers': 0};
    } catch (e) {
      print('Error fetching stats: $e');
      return {'totalUsers': 0};
    }
  }
}
