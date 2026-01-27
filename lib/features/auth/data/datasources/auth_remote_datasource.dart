import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/oauth_token_model.dart';
import '../models/oauth_user_info_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> loginWithOAuth(String cpf, String password);
  Future<OAuthTokenModel> refreshOAuthToken(String refreshToken);
  Future<OAuthUserInfoModel> getUserInfo(String accessToken);
  Future<void> revokeToken(String token);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;
  
  AuthRemoteDataSourceImpl(this._client);
  
  @override
  Future<LoginResponseModel> loginWithOAuth(String cpf, String password) async {
    final response = await _client.post(
      ApiConstants.oauthToken,
      data: {
        'grant_type': 'password',
        'username': cpf,
        'password': password,
        'client_id': 'zeca_mobile',
        'client_secret': 'zeca_mobile_secret',
      },
    );
    
    return LoginResponseModel.fromJson(response.data);
  }
  
  @override
  Future<OAuthTokenModel> refreshOAuthToken(String refreshToken) async {
    final response = await _client.post(
      ApiConstants.oauthToken,
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': 'zeca_mobile',
        'client_secret': 'zeca_mobile_secret',
      },
    );
    
    return OAuthTokenModel.fromJson(response.data);
  }
  
  @override
  Future<OAuthUserInfoModel> getUserInfo(String accessToken) async {
    final response = await _client.get(
      ApiConstants.oauthUserInfo,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    
    return OAuthUserInfoModel.fromJson(response.data);
  }
  
  @override
  Future<void> revokeToken(String token) async {
    await _client.post(
      ApiConstants.oauthRevoke,
      data: {
        'token': token,
        'client_id': 'zeca_mobile',
        'client_secret': 'zeca_mobile_secret',
      },
    );
  }
}
