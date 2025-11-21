// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSettingsModel _$NotificationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'sms_enabled')
  bool get smsEnabled => throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get refueling =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get vehicle =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get system =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get promotion =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get maintenance =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get security =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get payment =>
      throw _privateConstructorUsedError;
  NotificationTypeSettingsModel get reminder =>
      throw _privateConstructorUsedError;
  NotificationTimeSettingsModel get horarios =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'atualizado_em')
  DateTime get atualizadoEm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(NotificationSettingsModel value,
          $Res Function(NotificationSettingsModel) then) =
      _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'sms_enabled') bool smsEnabled,
      NotificationTypeSettingsModel refueling,
      NotificationTypeSettingsModel vehicle,
      NotificationTypeSettingsModel system,
      NotificationTypeSettingsModel promotion,
      NotificationTypeSettingsModel maintenance,
      NotificationTypeSettingsModel security,
      NotificationTypeSettingsModel payment,
      NotificationTypeSettingsModel reminder,
      NotificationTimeSettingsModel horarios,
      @JsonKey(name: 'atualizado_em') DateTime atualizadoEm});

  $NotificationTypeSettingsModelCopyWith<$Res> get refueling;
  $NotificationTypeSettingsModelCopyWith<$Res> get vehicle;
  $NotificationTypeSettingsModelCopyWith<$Res> get system;
  $NotificationTypeSettingsModelCopyWith<$Res> get promotion;
  $NotificationTypeSettingsModelCopyWith<$Res> get maintenance;
  $NotificationTypeSettingsModelCopyWith<$Res> get security;
  $NotificationTypeSettingsModelCopyWith<$Res> get payment;
  $NotificationTypeSettingsModelCopyWith<$Res> get reminder;
  $NotificationTimeSettingsModelCopyWith<$Res> get horarios;
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<$Res,
        $Val extends NotificationSettingsModel>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? smsEnabled = null,
    Object? refueling = null,
    Object? vehicle = null,
    Object? system = null,
    Object? promotion = null,
    Object? maintenance = null,
    Object? security = null,
    Object? payment = null,
    Object? reminder = null,
    Object? horarios = null,
    Object? atualizadoEm = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      refueling: null == refueling
          ? _value.refueling
          : refueling // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      vehicle: null == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      system: null == system
          ? _value.system
          : system // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      promotion: null == promotion
          ? _value.promotion
          : promotion // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      maintenance: null == maintenance
          ? _value.maintenance
          : maintenance // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      reminder: null == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      horarios: null == horarios
          ? _value.horarios
          : horarios // ignore: cast_nullable_to_non_nullable
              as NotificationTimeSettingsModel,
      atualizadoEm: null == atualizadoEm
          ? _value.atualizadoEm
          : atualizadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get refueling {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.refueling,
        (value) {
      return _then(_value.copyWith(refueling: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get vehicle {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.vehicle,
        (value) {
      return _then(_value.copyWith(vehicle: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get system {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.system, (value) {
      return _then(_value.copyWith(system: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get promotion {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.promotion,
        (value) {
      return _then(_value.copyWith(promotion: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get maintenance {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.maintenance,
        (value) {
      return _then(_value.copyWith(maintenance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get security {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.security,
        (value) {
      return _then(_value.copyWith(security: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get payment {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.payment,
        (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTypeSettingsModelCopyWith<$Res> get reminder {
    return $NotificationTypeSettingsModelCopyWith<$Res>(_value.reminder,
        (value) {
      return _then(_value.copyWith(reminder: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTimeSettingsModelCopyWith<$Res> get horarios {
    return $NotificationTimeSettingsModelCopyWith<$Res>(_value.horarios,
        (value) {
      return _then(_value.copyWith(horarios: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
          _$NotificationSettingsModelImpl value,
          $Res Function(_$NotificationSettingsModelImpl) then) =
      __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'sms_enabled') bool smsEnabled,
      NotificationTypeSettingsModel refueling,
      NotificationTypeSettingsModel vehicle,
      NotificationTypeSettingsModel system,
      NotificationTypeSettingsModel promotion,
      NotificationTypeSettingsModel maintenance,
      NotificationTypeSettingsModel security,
      NotificationTypeSettingsModel payment,
      NotificationTypeSettingsModel reminder,
      NotificationTimeSettingsModel horarios,
      @JsonKey(name: 'atualizado_em') DateTime atualizadoEm});

  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get refueling;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get vehicle;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get system;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get promotion;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get maintenance;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get security;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get payment;
  @override
  $NotificationTypeSettingsModelCopyWith<$Res> get reminder;
  @override
  $NotificationTimeSettingsModelCopyWith<$Res> get horarios;
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends _$NotificationSettingsModelCopyWithImpl<$Res,
        _$NotificationSettingsModelImpl>
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
      _$NotificationSettingsModelImpl _value,
      $Res Function(_$NotificationSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? smsEnabled = null,
    Object? refueling = null,
    Object? vehicle = null,
    Object? system = null,
    Object? promotion = null,
    Object? maintenance = null,
    Object? security = null,
    Object? payment = null,
    Object? reminder = null,
    Object? horarios = null,
    Object? atualizadoEm = null,
  }) {
    return _then(_$NotificationSettingsModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      refueling: null == refueling
          ? _value.refueling
          : refueling // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      vehicle: null == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      system: null == system
          ? _value.system
          : system // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      promotion: null == promotion
          ? _value.promotion
          : promotion // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      maintenance: null == maintenance
          ? _value.maintenance
          : maintenance // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      reminder: null == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as NotificationTypeSettingsModel,
      horarios: null == horarios
          ? _value.horarios
          : horarios // ignore: cast_nullable_to_non_nullable
              as NotificationTimeSettingsModel,
      atualizadoEm: null == atualizadoEm
          ? _value.atualizadoEm
          : atualizadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl extends _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'push_enabled') required this.pushEnabled,
      @JsonKey(name: 'email_enabled') required this.emailEnabled,
      @JsonKey(name: 'sms_enabled') required this.smsEnabled,
      required this.refueling,
      required this.vehicle,
      required this.system,
      required this.promotion,
      required this.maintenance,
      required this.security,
      required this.payment,
      required this.reminder,
      required this.horarios,
      @JsonKey(name: 'atualizado_em') required this.atualizadoEm})
      : super._();

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;
  @override
  @JsonKey(name: 'sms_enabled')
  final bool smsEnabled;
  @override
  final NotificationTypeSettingsModel refueling;
  @override
  final NotificationTypeSettingsModel vehicle;
  @override
  final NotificationTypeSettingsModel system;
  @override
  final NotificationTypeSettingsModel promotion;
  @override
  final NotificationTypeSettingsModel maintenance;
  @override
  final NotificationTypeSettingsModel security;
  @override
  final NotificationTypeSettingsModel payment;
  @override
  final NotificationTypeSettingsModel reminder;
  @override
  final NotificationTimeSettingsModel horarios;
  @override
  @JsonKey(name: 'atualizado_em')
  final DateTime atualizadoEm;

  @override
  String toString() {
    return 'NotificationSettingsModel(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, smsEnabled: $smsEnabled, refueling: $refueling, vehicle: $vehicle, system: $system, promotion: $promotion, maintenance: $maintenance, security: $security, payment: $payment, reminder: $reminder, horarios: $horarios, atualizadoEm: $atualizadoEm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.smsEnabled, smsEnabled) ||
                other.smsEnabled == smsEnabled) &&
            (identical(other.refueling, refueling) ||
                other.refueling == refueling) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.system, system) || other.system == system) &&
            (identical(other.promotion, promotion) ||
                other.promotion == promotion) &&
            (identical(other.maintenance, maintenance) ||
                other.maintenance == maintenance) &&
            (identical(other.security, security) ||
                other.security == security) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.horarios, horarios) ||
                other.horarios == horarios) &&
            (identical(other.atualizadoEm, atualizadoEm) ||
                other.atualizadoEm == atualizadoEm));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      pushEnabled,
      emailEnabled,
      smsEnabled,
      refueling,
      vehicle,
      system,
      promotion,
      maintenance,
      security,
      payment,
      reminder,
      horarios,
      atualizadoEm);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => __$$NotificationSettingsModelImplCopyWithImpl<
          _$NotificationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettingsModel extends NotificationSettingsModel {
  const factory _NotificationSettingsModel(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'push_enabled') required final bool pushEnabled,
      @JsonKey(name: 'email_enabled') required final bool emailEnabled,
      @JsonKey(name: 'sms_enabled') required final bool smsEnabled,
      required final NotificationTypeSettingsModel refueling,
      required final NotificationTypeSettingsModel vehicle,
      required final NotificationTypeSettingsModel system,
      required final NotificationTypeSettingsModel promotion,
      required final NotificationTypeSettingsModel maintenance,
      required final NotificationTypeSettingsModel security,
      required final NotificationTypeSettingsModel payment,
      required final NotificationTypeSettingsModel reminder,
      required final NotificationTimeSettingsModel horarios,
      @JsonKey(name: 'atualizado_em')
      required final DateTime atualizadoEm}) = _$NotificationSettingsModelImpl;
  const _NotificationSettingsModel._() : super._();

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled;
  @override
  @JsonKey(name: 'sms_enabled')
  bool get smsEnabled;
  @override
  NotificationTypeSettingsModel get refueling;
  @override
  NotificationTypeSettingsModel get vehicle;
  @override
  NotificationTypeSettingsModel get system;
  @override
  NotificationTypeSettingsModel get promotion;
  @override
  NotificationTypeSettingsModel get maintenance;
  @override
  NotificationTypeSettingsModel get security;
  @override
  NotificationTypeSettingsModel get payment;
  @override
  NotificationTypeSettingsModel get reminder;
  @override
  NotificationTimeSettingsModel get horarios;
  @override
  @JsonKey(name: 'atualizado_em')
  DateTime get atualizadoEm;
  @override
  @JsonKey(ignore: true)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationTypeSettingsModel _$NotificationTypeSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationTypeSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationTypeSettingsModel {
  bool get enabled => throw _privateConstructorUsedError;
  bool get push => throw _privateConstructorUsedError;
  bool get email => throw _privateConstructorUsedError;
  bool get sms => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_prioridade')
  String get minPrioridade => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationTypeSettingsModelCopyWith<NotificationTypeSettingsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTypeSettingsModelCopyWith<$Res> {
  factory $NotificationTypeSettingsModelCopyWith(
          NotificationTypeSettingsModel value,
          $Res Function(NotificationTypeSettingsModel) then) =
      _$NotificationTypeSettingsModelCopyWithImpl<$Res,
          NotificationTypeSettingsModel>;
  @useResult
  $Res call(
      {bool enabled,
      bool push,
      bool email,
      bool sms,
      @JsonKey(name: 'min_prioridade') String minPrioridade});
}

/// @nodoc
class _$NotificationTypeSettingsModelCopyWithImpl<$Res,
        $Val extends NotificationTypeSettingsModel>
    implements $NotificationTypeSettingsModelCopyWith<$Res> {
  _$NotificationTypeSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? push = null,
    Object? email = null,
    Object? sms = null,
    Object? minPrioridade = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      sms: null == sms
          ? _value.sms
          : sms // ignore: cast_nullable_to_non_nullable
              as bool,
      minPrioridade: null == minPrioridade
          ? _value.minPrioridade
          : minPrioridade // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationTypeSettingsModelImplCopyWith<$Res>
    implements $NotificationTypeSettingsModelCopyWith<$Res> {
  factory _$$NotificationTypeSettingsModelImplCopyWith(
          _$NotificationTypeSettingsModelImpl value,
          $Res Function(_$NotificationTypeSettingsModelImpl) then) =
      __$$NotificationTypeSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool push,
      bool email,
      bool sms,
      @JsonKey(name: 'min_prioridade') String minPrioridade});
}

/// @nodoc
class __$$NotificationTypeSettingsModelImplCopyWithImpl<$Res>
    extends _$NotificationTypeSettingsModelCopyWithImpl<$Res,
        _$NotificationTypeSettingsModelImpl>
    implements _$$NotificationTypeSettingsModelImplCopyWith<$Res> {
  __$$NotificationTypeSettingsModelImplCopyWithImpl(
      _$NotificationTypeSettingsModelImpl _value,
      $Res Function(_$NotificationTypeSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? push = null,
    Object? email = null,
    Object? sms = null,
    Object? minPrioridade = null,
  }) {
    return _then(_$NotificationTypeSettingsModelImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      sms: null == sms
          ? _value.sms
          : sms // ignore: cast_nullable_to_non_nullable
              as bool,
      minPrioridade: null == minPrioridade
          ? _value.minPrioridade
          : minPrioridade // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationTypeSettingsModelImpl
    extends _NotificationTypeSettingsModel {
  const _$NotificationTypeSettingsModelImpl(
      {required this.enabled,
      required this.push,
      required this.email,
      required this.sms,
      @JsonKey(name: 'min_prioridade') required this.minPrioridade})
      : super._();

  factory _$NotificationTypeSettingsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationTypeSettingsModelImplFromJson(json);

  @override
  final bool enabled;
  @override
  final bool push;
  @override
  final bool email;
  @override
  final bool sms;
  @override
  @JsonKey(name: 'min_prioridade')
  final String minPrioridade;

  @override
  String toString() {
    return 'NotificationTypeSettingsModel(enabled: $enabled, push: $push, email: $email, sms: $sms, minPrioridade: $minPrioridade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationTypeSettingsModelImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.sms, sms) || other.sms == sms) &&
            (identical(other.minPrioridade, minPrioridade) ||
                other.minPrioridade == minPrioridade));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, enabled, push, email, sms, minPrioridade);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationTypeSettingsModelImplCopyWith<
          _$NotificationTypeSettingsModelImpl>
      get copyWith => __$$NotificationTypeSettingsModelImplCopyWithImpl<
          _$NotificationTypeSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationTypeSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationTypeSettingsModel
    extends NotificationTypeSettingsModel {
  const factory _NotificationTypeSettingsModel(
          {required final bool enabled,
          required final bool push,
          required final bool email,
          required final bool sms,
          @JsonKey(name: 'min_prioridade')
          required final String minPrioridade}) =
      _$NotificationTypeSettingsModelImpl;
  const _NotificationTypeSettingsModel._() : super._();

  factory _NotificationTypeSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationTypeSettingsModelImpl.fromJson;

  @override
  bool get enabled;
  @override
  bool get push;
  @override
  bool get email;
  @override
  bool get sms;
  @override
  @JsonKey(name: 'min_prioridade')
  String get minPrioridade;
  @override
  @JsonKey(ignore: true)
  _$$NotificationTypeSettingsModelImplCopyWith<
          _$NotificationTypeSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationTimeSettingsModel _$NotificationTimeSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationTimeSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationTimeSettingsModel {
  @JsonKey(name: 'respeitar_horario_comercial')
  bool get respeitarHorarioComercial => throw _privateConstructorUsedError;
  @JsonKey(name: 'hora_inicio')
  int get horaInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'minuto_inicio')
  int get minutoInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'hora_fim')
  int get horaFim => throw _privateConstructorUsedError;
  @JsonKey(name: 'minuto_fim')
  int get minutoFim => throw _privateConstructorUsedError;
  @JsonKey(name: 'dias_semana')
  List<int> get diasSemana => throw _privateConstructorUsedError;
  @JsonKey(name: 'pausar_notificacoes')
  bool get pausarNotificacoes => throw _privateConstructorUsedError;
  @JsonKey(name: 'pausar_ate')
  DateTime? get pausarAte => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationTimeSettingsModelCopyWith<NotificationTimeSettingsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTimeSettingsModelCopyWith<$Res> {
  factory $NotificationTimeSettingsModelCopyWith(
          NotificationTimeSettingsModel value,
          $Res Function(NotificationTimeSettingsModel) then) =
      _$NotificationTimeSettingsModelCopyWithImpl<$Res,
          NotificationTimeSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'respeitar_horario_comercial')
      bool respeitarHorarioComercial,
      @JsonKey(name: 'hora_inicio') int horaInicio,
      @JsonKey(name: 'minuto_inicio') int minutoInicio,
      @JsonKey(name: 'hora_fim') int horaFim,
      @JsonKey(name: 'minuto_fim') int minutoFim,
      @JsonKey(name: 'dias_semana') List<int> diasSemana,
      @JsonKey(name: 'pausar_notificacoes') bool pausarNotificacoes,
      @JsonKey(name: 'pausar_ate') DateTime? pausarAte});
}

/// @nodoc
class _$NotificationTimeSettingsModelCopyWithImpl<$Res,
        $Val extends NotificationTimeSettingsModel>
    implements $NotificationTimeSettingsModelCopyWith<$Res> {
  _$NotificationTimeSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respeitarHorarioComercial = null,
    Object? horaInicio = null,
    Object? minutoInicio = null,
    Object? horaFim = null,
    Object? minutoFim = null,
    Object? diasSemana = null,
    Object? pausarNotificacoes = null,
    Object? pausarAte = freezed,
  }) {
    return _then(_value.copyWith(
      respeitarHorarioComercial: null == respeitarHorarioComercial
          ? _value.respeitarHorarioComercial
          : respeitarHorarioComercial // ignore: cast_nullable_to_non_nullable
              as bool,
      horaInicio: null == horaInicio
          ? _value.horaInicio
          : horaInicio // ignore: cast_nullable_to_non_nullable
              as int,
      minutoInicio: null == minutoInicio
          ? _value.minutoInicio
          : minutoInicio // ignore: cast_nullable_to_non_nullable
              as int,
      horaFim: null == horaFim
          ? _value.horaFim
          : horaFim // ignore: cast_nullable_to_non_nullable
              as int,
      minutoFim: null == minutoFim
          ? _value.minutoFim
          : minutoFim // ignore: cast_nullable_to_non_nullable
              as int,
      diasSemana: null == diasSemana
          ? _value.diasSemana
          : diasSemana // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pausarNotificacoes: null == pausarNotificacoes
          ? _value.pausarNotificacoes
          : pausarNotificacoes // ignore: cast_nullable_to_non_nullable
              as bool,
      pausarAte: freezed == pausarAte
          ? _value.pausarAte
          : pausarAte // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationTimeSettingsModelImplCopyWith<$Res>
    implements $NotificationTimeSettingsModelCopyWith<$Res> {
  factory _$$NotificationTimeSettingsModelImplCopyWith(
          _$NotificationTimeSettingsModelImpl value,
          $Res Function(_$NotificationTimeSettingsModelImpl) then) =
      __$$NotificationTimeSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'respeitar_horario_comercial')
      bool respeitarHorarioComercial,
      @JsonKey(name: 'hora_inicio') int horaInicio,
      @JsonKey(name: 'minuto_inicio') int minutoInicio,
      @JsonKey(name: 'hora_fim') int horaFim,
      @JsonKey(name: 'minuto_fim') int minutoFim,
      @JsonKey(name: 'dias_semana') List<int> diasSemana,
      @JsonKey(name: 'pausar_notificacoes') bool pausarNotificacoes,
      @JsonKey(name: 'pausar_ate') DateTime? pausarAte});
}

/// @nodoc
class __$$NotificationTimeSettingsModelImplCopyWithImpl<$Res>
    extends _$NotificationTimeSettingsModelCopyWithImpl<$Res,
        _$NotificationTimeSettingsModelImpl>
    implements _$$NotificationTimeSettingsModelImplCopyWith<$Res> {
  __$$NotificationTimeSettingsModelImplCopyWithImpl(
      _$NotificationTimeSettingsModelImpl _value,
      $Res Function(_$NotificationTimeSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respeitarHorarioComercial = null,
    Object? horaInicio = null,
    Object? minutoInicio = null,
    Object? horaFim = null,
    Object? minutoFim = null,
    Object? diasSemana = null,
    Object? pausarNotificacoes = null,
    Object? pausarAte = freezed,
  }) {
    return _then(_$NotificationTimeSettingsModelImpl(
      respeitarHorarioComercial: null == respeitarHorarioComercial
          ? _value.respeitarHorarioComercial
          : respeitarHorarioComercial // ignore: cast_nullable_to_non_nullable
              as bool,
      horaInicio: null == horaInicio
          ? _value.horaInicio
          : horaInicio // ignore: cast_nullable_to_non_nullable
              as int,
      minutoInicio: null == minutoInicio
          ? _value.minutoInicio
          : minutoInicio // ignore: cast_nullable_to_non_nullable
              as int,
      horaFim: null == horaFim
          ? _value.horaFim
          : horaFim // ignore: cast_nullable_to_non_nullable
              as int,
      minutoFim: null == minutoFim
          ? _value.minutoFim
          : minutoFim // ignore: cast_nullable_to_non_nullable
              as int,
      diasSemana: null == diasSemana
          ? _value._diasSemana
          : diasSemana // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pausarNotificacoes: null == pausarNotificacoes
          ? _value.pausarNotificacoes
          : pausarNotificacoes // ignore: cast_nullable_to_non_nullable
              as bool,
      pausarAte: freezed == pausarAte
          ? _value.pausarAte
          : pausarAte // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationTimeSettingsModelImpl
    extends _NotificationTimeSettingsModel {
  const _$NotificationTimeSettingsModelImpl(
      {@JsonKey(name: 'respeitar_horario_comercial')
      required this.respeitarHorarioComercial,
      @JsonKey(name: 'hora_inicio') required this.horaInicio,
      @JsonKey(name: 'minuto_inicio') required this.minutoInicio,
      @JsonKey(name: 'hora_fim') required this.horaFim,
      @JsonKey(name: 'minuto_fim') required this.minutoFim,
      @JsonKey(name: 'dias_semana') required final List<int> diasSemana,
      @JsonKey(name: 'pausar_notificacoes') required this.pausarNotificacoes,
      @JsonKey(name: 'pausar_ate') this.pausarAte})
      : _diasSemana = diasSemana,
        super._();

  factory _$NotificationTimeSettingsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationTimeSettingsModelImplFromJson(json);

  @override
  @JsonKey(name: 'respeitar_horario_comercial')
  final bool respeitarHorarioComercial;
  @override
  @JsonKey(name: 'hora_inicio')
  final int horaInicio;
  @override
  @JsonKey(name: 'minuto_inicio')
  final int minutoInicio;
  @override
  @JsonKey(name: 'hora_fim')
  final int horaFim;
  @override
  @JsonKey(name: 'minuto_fim')
  final int minutoFim;
  final List<int> _diasSemana;
  @override
  @JsonKey(name: 'dias_semana')
  List<int> get diasSemana {
    if (_diasSemana is EqualUnmodifiableListView) return _diasSemana;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diasSemana);
  }

  @override
  @JsonKey(name: 'pausar_notificacoes')
  final bool pausarNotificacoes;
  @override
  @JsonKey(name: 'pausar_ate')
  final DateTime? pausarAte;

  @override
  String toString() {
    return 'NotificationTimeSettingsModel(respeitarHorarioComercial: $respeitarHorarioComercial, horaInicio: $horaInicio, minutoInicio: $minutoInicio, horaFim: $horaFim, minutoFim: $minutoFim, diasSemana: $diasSemana, pausarNotificacoes: $pausarNotificacoes, pausarAte: $pausarAte)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationTimeSettingsModelImpl &&
            (identical(other.respeitarHorarioComercial,
                    respeitarHorarioComercial) ||
                other.respeitarHorarioComercial == respeitarHorarioComercial) &&
            (identical(other.horaInicio, horaInicio) ||
                other.horaInicio == horaInicio) &&
            (identical(other.minutoInicio, minutoInicio) ||
                other.minutoInicio == minutoInicio) &&
            (identical(other.horaFim, horaFim) || other.horaFim == horaFim) &&
            (identical(other.minutoFim, minutoFim) ||
                other.minutoFim == minutoFim) &&
            const DeepCollectionEquality()
                .equals(other._diasSemana, _diasSemana) &&
            (identical(other.pausarNotificacoes, pausarNotificacoes) ||
                other.pausarNotificacoes == pausarNotificacoes) &&
            (identical(other.pausarAte, pausarAte) ||
                other.pausarAte == pausarAte));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      respeitarHorarioComercial,
      horaInicio,
      minutoInicio,
      horaFim,
      minutoFim,
      const DeepCollectionEquality().hash(_diasSemana),
      pausarNotificacoes,
      pausarAte);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationTimeSettingsModelImplCopyWith<
          _$NotificationTimeSettingsModelImpl>
      get copyWith => __$$NotificationTimeSettingsModelImplCopyWithImpl<
          _$NotificationTimeSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationTimeSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationTimeSettingsModel
    extends NotificationTimeSettingsModel {
  const factory _NotificationTimeSettingsModel(
          {@JsonKey(name: 'respeitar_horario_comercial')
          required final bool respeitarHorarioComercial,
          @JsonKey(name: 'hora_inicio') required final int horaInicio,
          @JsonKey(name: 'minuto_inicio') required final int minutoInicio,
          @JsonKey(name: 'hora_fim') required final int horaFim,
          @JsonKey(name: 'minuto_fim') required final int minutoFim,
          @JsonKey(name: 'dias_semana') required final List<int> diasSemana,
          @JsonKey(name: 'pausar_notificacoes')
          required final bool pausarNotificacoes,
          @JsonKey(name: 'pausar_ate') final DateTime? pausarAte}) =
      _$NotificationTimeSettingsModelImpl;
  const _NotificationTimeSettingsModel._() : super._();

  factory _NotificationTimeSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationTimeSettingsModelImpl.fromJson;

  @override
  @JsonKey(name: 'respeitar_horario_comercial')
  bool get respeitarHorarioComercial;
  @override
  @JsonKey(name: 'hora_inicio')
  int get horaInicio;
  @override
  @JsonKey(name: 'minuto_inicio')
  int get minutoInicio;
  @override
  @JsonKey(name: 'hora_fim')
  int get horaFim;
  @override
  @JsonKey(name: 'minuto_fim')
  int get minutoFim;
  @override
  @JsonKey(name: 'dias_semana')
  List<int> get diasSemana;
  @override
  @JsonKey(name: 'pausar_notificacoes')
  bool get pausarNotificacoes;
  @override
  @JsonKey(name: 'pausar_ate')
  DateTime? get pausarAte;
  @override
  @JsonKey(ignore: true)
  _$$NotificationTimeSettingsModelImplCopyWith<
          _$NotificationTimeSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
