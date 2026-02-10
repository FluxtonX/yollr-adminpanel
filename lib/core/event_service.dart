import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'constants.dart';
import '../models/event_model.dart';

class AdminEventService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<bool> createEvent(AdminEventModel event) async {
    try {
      final response = await _dio.post('/events', data: event.toMap());
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating event: $e');
      return false;
    }
  }

  Future<List<AdminEventModel>> fetchAllEvents() async {
    try {
      final response = await _dio.get('/events/all');
      if (response.statusCode == 200) {
        final List eventsJson = response.data['data'];
        return eventsJson.map((json) => AdminEventModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<String?> uploadBanner(Uint8List bytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'banner': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await _dio.post('/events/upload', data: formData);
      if (response.statusCode == 200) {
        return response.data['bannerUrl'];
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        print('Error uploading banner (Dio): ${e.message}');
        print('Details: ${e.response?.data}');
      } else {
        print('Error uploading banner: $e');
      }
      return null;
    }
  }

  Future<bool> selectWinner(String eventId) async {
    try {
      final response = await _dio.post(
        '/event-submissions/event/$eventId/select-winner',
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error selecting winner: $e');
      return false;
    }
  }
}
