// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OAuthTokenModelImpl _$$OAuthTokenModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OAuthTokenModelImpl(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String,
      scope: json['scope'] as String?,
    );

Map<String, dynamic> _$$OAuthTokenModelImplToJson(
        _$OAuthTokenModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'scope': instance.scope,
    };
