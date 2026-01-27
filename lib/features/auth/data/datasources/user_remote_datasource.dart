import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../../../home/data/models/company_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(Map<String, dynamic> data);
  Future<UserPreferencesModel> getUserPreferences();
  Future<UserPreferencesModel> updateUserPreferences(UserPreferencesModel preferences);
  Future<CompanyModel> getCompanyInfo();
  Future<List<UserModel>> getCompanyUsers();
  Future<UserModel> getUserById(String userId);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _client;
  
  UserRemoteDataSourceImpl(this._client);
  
  @override
  Future<UserModel> getUserProfile() async {
    final response = await _client.get(ApiConstants.userProfile);
    return UserModel.fromJson(response.data['data']);
  }
  
  @override
  Future<UserModel> updateUserProfile(Map<String, dynamic> data) async {
    final response = await _client.put(
      ApiConstants.updateProfile,
      data: data,
    );
    return UserModel.fromJson(response.data['data']);
  }
  
  @override
  Future<UserPreferencesModel> getUserPreferences() async {
    final response = await _client.get(ApiConstants.userPreferences);
    return UserPreferencesModel.fromJson(response.data['data']);
  }
  
  @override
  Future<UserPreferencesModel> updateUserPreferences(UserPreferencesModel preferences) async {
    final response = await _client.put(
      ApiConstants.userPreferences,
      data: preferences.toJson(),
    );
    return UserPreferencesModel.fromJson(response.data['data']);
  }
  
  @override
  Future<CompanyModel> getCompanyInfo() async {
    final response = await _client.get(ApiConstants.companyInfo);
    return CompanyModel.fromJson(response.data['data']);
  }
  
  @override
  Future<List<UserModel>> getCompanyUsers() async {
    final response = await _client.get(ApiConstants.companyUsers);
    final List<dynamic> usersJson = response.data['data'];
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }
  
  @override
  Future<UserModel> getUserById(String userId) async {
    final response = await _client.get('${ApiConstants.companyUsers}/$userId');
    return UserModel.fromJson(response.data['data']);
  }
}
