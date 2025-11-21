import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_user_info_model.freezed.dart';
part 'oauth_user_info_model.g.dart';

@freezed
class OAuthUserInfoModel with _$OAuthUserInfoModel {
  const factory OAuthUserInfoModel({
    required String sub,
    required String name,
    required String cpf,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'company_cnpj') String? companyCnpj,
    @JsonKey(name: 'roles') @Default([]) List<String> roles,
    @JsonKey(name: 'permissions') @Default([]) List<String> permissions,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
  }) = _OAuthUserInfoModel;
  
  factory OAuthUserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$OAuthUserInfoModelFromJson(json);
}
