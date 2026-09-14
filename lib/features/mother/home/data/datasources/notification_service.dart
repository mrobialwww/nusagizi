import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/home/data/models/notification_model.dart';

abstract class NotificationService {
  Future<List<NotificationModel>> getAllNotifications();
}

class NotificationServiceImpl implements NotificationService {
  final Dio dio;

  NotificationServiceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final response = await dio.get('/notifications');

      final List<dynamic> data = response.data;

      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 404) {
        // Handle 404 gracefully dengan mengembalikan list kosong (Tidak ada notifikasi)
        return [];
      }
      throw ServerException(message: e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
