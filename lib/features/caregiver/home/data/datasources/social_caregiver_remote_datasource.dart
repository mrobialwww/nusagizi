import 'package:dio/dio.dart';
import 'package:nusagizi/features/caregiver/home/data/models/create_caregiver_child_photo_request_model.dart';

abstract class SocialCaregiverRemoteDataSource {
  Future<String> createCaregiverChildPhoto(
    CreateCaregiverChildPhotoRequestModel request,
  );
}

class SocialCaregiverRemoteDataSourceImpl
    implements SocialCaregiverRemoteDataSource {
  final Dio dio;

  SocialCaregiverRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> createCaregiverChildPhoto(
    CreateCaregiverChildPhotoRequestModel request,
  ) async {
    final response = await dio.post(
      '/children/${request.childId}/photos/caregiver',
      data: request.toJson(),
    );

    if (response.statusCode == 201) {
      return response.data['id'];
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }
}
