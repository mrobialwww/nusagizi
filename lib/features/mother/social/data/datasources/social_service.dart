import 'package:dio/dio.dart';
import 'package:nusagizi/features/mother/social/data/models/create_child_photo_request_model.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/social/data/models/child_photo_model.dart';
import 'package:nusagizi/features/mother/social/data/models/review_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/data/models/contact_model.dart';

abstract class SocialService {
  Future<List<ContactModel>> getContacts();
  Future<void> deleteContact(String contactId);
  Future<List<ChildPhotoModel>> getOwnChildPhotos([String? childId]);
  Future<List<ChildPhotoModel>> getContactChildPhotos(String contactId);
  Future<List<ChildPhotoModel>> getAllChildPhotos();
  Future<ChildPhotoModel> getPhotoDetail(String childPhotoId);
  Future<String> createChildPhoto(CreateChildPhotoRequestModel request);
  Future<void> reviewChildPhoto(
    String childId,
    String childPhotoId,
    ReviewChildPhotoRequestModel request,
  );
}

class SocialServiceImpl implements SocialService {
  final Dio _dio;

  SocialServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await _dio.get('/mother-profiles/contacts');
      final data = response.data;
      final list = data is List ? data : data['data'];
      return (list as List).map((json) => ContactModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      await _dio.delete('/contacts/$contactId');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChildPhotoModel>> getOwnChildPhotos([String? childId]) async {
    try {
      final response = await _dio.get(
        '/mother-profiles/child-photos',
        queryParameters: childId != null ? {'child_id': childId} : null,
      );
      final data = response.data;
      final list = data is List ? data : (data['data'] ?? []);
      return (list as List)
          .map((json) => ChildPhotoModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChildPhotoModel>> getContactChildPhotos(String contactId) async {
    try {
      final response = await _dio.get('/contacts/$contactId/child-photos');
      final data = response.data;
      final list = data is List ? data : (data['data'] ?? []);
      return (list as List)
          .map((json) => ChildPhotoModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChildPhotoModel>> getAllChildPhotos() async {
    try {
      final response = await _dio.get('/mother-profiles/child-photos/all');
      final data = response.data;
      final list = data is List ? data : (data['data'] ?? []);
      return (list as List)
          .map((json) => ChildPhotoModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChildPhotoModel> getPhotoDetail(String childPhotoId) async {
    try {
      final response = await _dio.get('/child-photos/$childPhotoId');
      final data = response.data;
      final mapData = data is Map && data.containsKey('data')
          ? data['data']
          : data;
      return ChildPhotoModel.fromJson(mapData);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> createChildPhoto(CreateChildPhotoRequestModel request) async {
    try {
      final endpoint = '/children/${request.childId}/photos/mother';
      final payload = request.toJson();

      final response = await _dio.post(endpoint, data: payload);

      if (response.statusCode == 201) {
        if (response.data is Map) {
          return response.data['id'] as String? ?? '';
        }
        return '';
      } else {
        throw ServerException(
          message: 'Failed to add child photo: \${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorMessage;
      if (data is Map) {
        if (data['error'] is String) {
          errorMessage = data['error'];
        } else if (data['error'] is Map) {
          errorMessage = data['error']['message'];
        }
        errorMessage ??= data['message'];
      }
      throw ServerException(
        message: errorMessage ?? e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> reviewChildPhoto(
    String childId,
    String childPhotoId,
    ReviewChildPhotoRequestModel request,
  ) async {
    try {
      final endpoint = '/children/$childId/photos/$childPhotoId';
      final payload = request.toJson();

      final response = await _dio.patch(endpoint, data: payload);

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to edit child photo: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorMessage;
      if (data is Map) {
        if (data['error'] is String) {
          errorMessage = data['error'];
        } else if (data['error'] is Map) {
          errorMessage = data['error']['message'];
        }
        errorMessage ??= data['message'];
      }
      throw ServerException(
        message: errorMessage ?? e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
