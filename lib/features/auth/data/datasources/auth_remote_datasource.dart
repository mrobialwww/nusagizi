import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

// AUTH FEATURE - DATA LAYER
// Remote DataSource: bertanggung jawab fetch data dari API
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // inject Dio/http client di sini
  // final Dio dio;
  // AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    // TODO: Implement API call
    // contoh: final response = await dio.post('/auth/login', data: {...});
    // if (response.statusCode == 200) return UserModel.fromJson(response.data);
    throw const ServerException(message: 'Not implemented yet');
  }

  @override
  Future<void> logout() async {
    // TODO: Implement API call
    throw const ServerException(message: 'Not implemented yet');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // TODO: Implement API call
    throw const ServerException(message: 'Not implemented yet');
  }
}
