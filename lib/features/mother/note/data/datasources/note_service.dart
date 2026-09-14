import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_model.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_detail_model.dart';

abstract class NoteService {
  Future<List<MedicalNoteModel>> getMedicalNotes({
    required String status,
    int? month,
    String? childName,
  });

  Future<MedicalNoteDetailModel> getMedicalNoteDetail(String id);
  Future<void> addMedicalNote(Map<String, dynamic> payload);
  Future<void> editMedicalNote(String id, Map<String, dynamic> payload);
}

class NoteServiceImpl implements NoteService {
  final Dio dio;

  NoteServiceImpl({required this.dio});

  @override
  Future<List<MedicalNoteModel>> getMedicalNotes({
    required String status,
    int? month,
    String? childName,
  }) async {
    try {
      final queryParams = <String, dynamic>{'status': status};
      if (month != null) {
        queryParams['month'] = month;
      }
      if (childName != null &&
          childName.isNotEmpty &&
          childName != 'Semua Anak') {
        queryParams['child_name'] = childName;
      }

      final response = await dio.get(
        '/medical-notes',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MedicalNoteModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load medical notes');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MedicalNoteDetailModel> getMedicalNoteDetail(String id) async {
    try {
      final response = await dio.get('/medical-notes/$id');
      if (response.statusCode == 200) {
        return MedicalNoteDetailModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Unknown error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> addMedicalNote(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post('/medical-notes', data: payload);
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ServerException(message: 'Gagal menambahkan catatan medis');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message =
              e.response?.data['message'] ??
              e.response?.data['error'] ??
              message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> editMedicalNote(String id, Map<String, dynamic> payload) async {
    try {
      final response = await dio.patch('/medical-notes/$id', data: payload);
      if (response.statusCode != 200) {
        throw ServerException(message: 'Gagal mengubah catatan medis');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message =
              e.response?.data['message'] ??
              e.response?.data['error'] ??
              message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
