import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_autonomous_model.freezed.dart';
part 'register_autonomous_model.g.dart';

@freezed
class RegisterAutonomousRequest with _$RegisterAutonomousRequest {
  const factory RegisterAutonomousRequest({
    required String name,
    required String cpf,
    required String phone,
    @JsonKey(name: 'birth_date') String? birthDate,
    String? email,
    required String password,
    @JsonKey(name: 'terms_accepted') required bool termsAccepted,
    @JsonKey(name: 'terms_version') String? termsVersion,
  }) = _RegisterAutonomousRequest;

  factory RegisterAutonomousRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterAutonomousRequestFromJson(json);
}

@freezed
class RegisterAutonomousResponse with _$RegisterAutonomousResponse {
  const factory RegisterAutonomousResponse({
    required String id,
    required String name,
    required String cpf,
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _RegisterAutonomousResponse;

  factory RegisterAutonomousResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterAutonomousResponseFromJson(json);
}

@freezed
class TermsVersionModel with _$TermsVersionModel {
  const factory TermsVersionModel({
    required String id,
    required String version,
    required String title,
    required String content,
    required String type,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _TermsVersionModel;

  factory TermsVersionModel.fromJson(Map<String, dynamic> json) =>
      _$TermsVersionModelFromJson(json);
}

@freezed
class CheckCpfResponse with _$CheckCpfResponse {
  const factory CheckCpfResponse({
    required bool exists,
  }) = _CheckCpfResponse;

  factory CheckCpfResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckCpfResponseFromJson(json);
}
