import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_token_model.freezed.dart';
part 'oauth_token_model.g.dart';

@freezed
class OAuthTokenModel with _$OAuthTokenModel {
  const factory OAuthTokenModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'scope') String? scope,
  }) = _OAuthTokenModel;
  
  factory OAuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$OAuthTokenModelFromJson(json);
}
