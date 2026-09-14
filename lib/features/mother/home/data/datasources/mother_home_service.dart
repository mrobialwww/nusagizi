import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/home/data/models/child_summary_model.dart';

abstract class MotherHomeService {
  Future<List<ChildSummaryModel>> getChildrenSummary();
}

class MotherHomeServiceImpl implements MotherHomeService {
  final Dio dio;

  MotherHomeServiceImpl({required this.dio});

  @override
  Future<List<ChildSummaryModel>> getChildrenSummary() async {
    try {
      final response = await dio.get('/dashboard/children');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => ChildSummaryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal memuat data ringkasan anak');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
