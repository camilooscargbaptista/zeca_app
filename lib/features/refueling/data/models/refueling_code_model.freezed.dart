// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refueling_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefuelingCodeModel _$RefuelingCodeModelFromJson(Map<String, dynamic> json) {
  return _RefuelingCodeModel.fromJson(json);
}

/// @nodoc
mixin _$RefuelingCodeModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String get qrCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate')
  String get vehiclePlate => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_cpf')
  String get userCpf => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_cnpj')
  String get stationCnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type')
  String get fuelType => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_per_liter')
  double get pricePerLiter => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_quantity')
  double get maxQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_value')
  double get maxValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_km')
  int get currentKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_arla')
  bool get requiresArla => throw _privateConstructorUsedError;
  @JsonKey(name: 'arla_price')
  double? get arlaPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_until')
  DateTime get validUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'documents')
  List<DocumentModel> get documents => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_data')
  RefuelingDataModel? get refuelingData => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefuelingCodeModelCopyWith<RefuelingCodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefuelingCodeModelCopyWith<$Res> {
  factory $RefuelingCodeModelCopyWith(
          RefuelingCodeModel value, $Res Function(RefuelingCodeModel) then) =
      _$RefuelingCodeModelCopyWithImpl<$Res, RefuelingCodeModel>;
  @useResult
  $Res call(
      {String id,
      String code,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'vehicle_plate') String vehiclePlate,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_cpf') String userCpf,
      @JsonKey(name: 'station_id') String stationId,
      @JsonKey(name: 'station_cnpj') String stationCnpj,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'price_per_liter') double pricePerLiter,
      @JsonKey(name: 'max_quantity') double maxQuantity,
      @JsonKey(name: 'max_value') double maxValue,
      @JsonKey(name: 'current_km') int currentKm,
      @JsonKey(name: 'requires_arla') bool requiresArla,
      @JsonKey(name: 'arla_price') double? arlaPrice,
      @JsonKey(name: 'valid_until') DateTime validUntil,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'documents') List<DocumentModel> documents,
      @JsonKey(name: 'refueling_data') RefuelingDataModel? refuelingData,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});

  $RefuelingDataModelCopyWith<$Res>? get refuelingData;
}

/// @nodoc
class _$RefuelingCodeModelCopyWithImpl<$Res, $Val extends RefuelingCodeModel>
    implements $RefuelingCodeModelCopyWith<$Res> {
  _$RefuelingCodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? qrCode = null,
    Object? vehicleId = null,
    Object? vehiclePlate = null,
    Object? userId = null,
    Object? userCpf = null,
    Object? stationId = null,
    Object? stationCnpj = null,
    Object? fuelType = null,
    Object? pricePerLiter = null,
    Object? maxQuantity = null,
    Object? maxValue = null,
    Object? currentKm = null,
    Object? requiresArla = null,
    Object? arlaPrice = freezed,
    Object? validUntil = null,
    Object? generatedAt = null,
    Object? status = null,
    Object? documents = null,
    Object? refuelingData = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userCpf: null == userCpf
          ? _value.userCpf
          : userCpf // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      stationCnpj: null == stationCnpj
          ? _value.stationCnpj
          : stationCnpj // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      currentKm: null == currentKm
          ? _value.currentKm
          : currentKm // ignore: cast_nullable_to_non_nullable
              as int,
      requiresArla: null == requiresArla
          ? _value.requiresArla
          : requiresArla // ignore: cast_nullable_to_non_nullable
              as bool,
      arlaPrice: freezed == arlaPrice
          ? _value.arlaPrice
          : arlaPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
      refuelingData: freezed == refuelingData
          ? _value.refuelingData
          : refuelingData // ignore: cast_nullable_to_non_nullable
              as RefuelingDataModel?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RefuelingDataModelCopyWith<$Res>? get refuelingData {
    if (_value.refuelingData == null) {
      return null;
    }

    return $RefuelingDataModelCopyWith<$Res>(_value.refuelingData!, (value) {
      return _then(_value.copyWith(refuelingData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RefuelingCodeModelImplCopyWith<$Res>
    implements $RefuelingCodeModelCopyWith<$Res> {
  factory _$$RefuelingCodeModelImplCopyWith(_$RefuelingCodeModelImpl value,
          $Res Function(_$RefuelingCodeModelImpl) then) =
      __$$RefuelingCodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      @JsonKey(name: 'qr_code') String qrCode,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'vehicle_plate') String vehiclePlate,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_cpf') String userCpf,
      @JsonKey(name: 'station_id') String stationId,
      @JsonKey(name: 'station_cnpj') String stationCnpj,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'price_per_liter') double pricePerLiter,
      @JsonKey(name: 'max_quantity') double maxQuantity,
      @JsonKey(name: 'max_value') double maxValue,
      @JsonKey(name: 'current_km') int currentKm,
      @JsonKey(name: 'requires_arla') bool requiresArla,
      @JsonKey(name: 'arla_price') double? arlaPrice,
      @JsonKey(name: 'valid_until') DateTime validUntil,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'documents') List<DocumentModel> documents,
      @JsonKey(name: 'refueling_data') RefuelingDataModel? refuelingData,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});

  @override
  $RefuelingDataModelCopyWith<$Res>? get refuelingData;
}

/// @nodoc
class __$$RefuelingCodeModelImplCopyWithImpl<$Res>
    extends _$RefuelingCodeModelCopyWithImpl<$Res, _$RefuelingCodeModelImpl>
    implements _$$RefuelingCodeModelImplCopyWith<$Res> {
  __$$RefuelingCodeModelImplCopyWithImpl(_$RefuelingCodeModelImpl _value,
      $Res Function(_$RefuelingCodeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? qrCode = null,
    Object? vehicleId = null,
    Object? vehiclePlate = null,
    Object? userId = null,
    Object? userCpf = null,
    Object? stationId = null,
    Object? stationCnpj = null,
    Object? fuelType = null,
    Object? pricePerLiter = null,
    Object? maxQuantity = null,
    Object? maxValue = null,
    Object? currentKm = null,
    Object? requiresArla = null,
    Object? arlaPrice = freezed,
    Object? validUntil = null,
    Object? generatedAt = null,
    Object? status = null,
    Object? documents = null,
    Object? refuelingData = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$RefuelingCodeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userCpf: null == userCpf
          ? _value.userCpf
          : userCpf // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      stationCnpj: null == stationCnpj
          ? _value.stationCnpj
          : stationCnpj // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      currentKm: null == currentKm
          ? _value.currentKm
          : currentKm // ignore: cast_nullable_to_non_nullable
              as int,
      requiresArla: null == requiresArla
          ? _value.requiresArla
          : requiresArla // ignore: cast_nullable_to_non_nullable
              as bool,
      arlaPrice: freezed == arlaPrice
          ? _value.arlaPrice
          : arlaPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
      refuelingData: freezed == refuelingData
          ? _value.refuelingData
          : refuelingData // ignore: cast_nullable_to_non_nullable
              as RefuelingDataModel?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefuelingCodeModelImpl extends _RefuelingCodeModel {
  const _$RefuelingCodeModelImpl(
      {required this.id,
      required this.code,
      @JsonKey(name: 'qr_code') required this.qrCode,
      @JsonKey(name: 'vehicle_id') required this.vehicleId,
      @JsonKey(name: 'vehicle_plate') required this.vehiclePlate,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_cpf') required this.userCpf,
      @JsonKey(name: 'station_id') required this.stationId,
      @JsonKey(name: 'station_cnpj') required this.stationCnpj,
      @JsonKey(name: 'fuel_type') required this.fuelType,
      @JsonKey(name: 'price_per_liter') required this.pricePerLiter,
      @JsonKey(name: 'max_quantity') required this.maxQuantity,
      @JsonKey(name: 'max_value') required this.maxValue,
      @JsonKey(name: 'current_km') required this.currentKm,
      @JsonKey(name: 'requires_arla') this.requiresArla = false,
      @JsonKey(name: 'arla_price') this.arlaPrice,
      @JsonKey(name: 'valid_until') required this.validUntil,
      @JsonKey(name: 'generated_at') required this.generatedAt,
      @JsonKey(name: 'status') this.status = 'pending',
      @JsonKey(name: 'documents')
      final List<DocumentModel> documents = const [],
      @JsonKey(name: 'refueling_data') this.refuelingData,
      @JsonKey(name: 'cancellation_reason') this.cancellationReason,
      @JsonKey(name: 'cancelled_at') this.cancelledAt,
      @JsonKey(name: 'completed_at') this.completedAt})
      : _documents = documents,
        super._();

  factory _$RefuelingCodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefuelingCodeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @override
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @override
  @JsonKey(name: 'vehicle_plate')
  final String vehiclePlate;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_cpf')
  final String userCpf;
  @override
  @JsonKey(name: 'station_id')
  final String stationId;
  @override
  @JsonKey(name: 'station_cnpj')
  final String stationCnpj;
  @override
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @override
  @JsonKey(name: 'price_per_liter')
  final double pricePerLiter;
  @override
  @JsonKey(name: 'max_quantity')
  final double maxQuantity;
  @override
  @JsonKey(name: 'max_value')
  final double maxValue;
  @override
  @JsonKey(name: 'current_km')
  final int currentKm;
  @override
  @JsonKey(name: 'requires_arla')
  final bool requiresArla;
  @override
  @JsonKey(name: 'arla_price')
  final double? arlaPrice;
  @override
  @JsonKey(name: 'valid_until')
  final DateTime validUntil;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;
  @override
  @JsonKey(name: 'status')
  final String status;
  final List<DocumentModel> _documents;
  @override
  @JsonKey(name: 'documents')
  List<DocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  @JsonKey(name: 'refueling_data')
  final RefuelingDataModel? refuelingData;
  @override
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'RefuelingCodeModel(id: $id, code: $code, qrCode: $qrCode, vehicleId: $vehicleId, vehiclePlate: $vehiclePlate, userId: $userId, userCpf: $userCpf, stationId: $stationId, stationCnpj: $stationCnpj, fuelType: $fuelType, pricePerLiter: $pricePerLiter, maxQuantity: $maxQuantity, maxValue: $maxValue, currentKm: $currentKm, requiresArla: $requiresArla, arlaPrice: $arlaPrice, validUntil: $validUntil, generatedAt: $generatedAt, status: $status, documents: $documents, refuelingData: $refuelingData, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefuelingCodeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userCpf, userCpf) || other.userCpf == userCpf) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.stationCnpj, stationCnpj) ||
                other.stationCnpj == stationCnpj) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.pricePerLiter, pricePerLiter) ||
                other.pricePerLiter == pricePerLiter) &&
            (identical(other.maxQuantity, maxQuantity) ||
                other.maxQuantity == maxQuantity) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.currentKm, currentKm) ||
                other.currentKm == currentKm) &&
            (identical(other.requiresArla, requiresArla) ||
                other.requiresArla == requiresArla) &&
            (identical(other.arlaPrice, arlaPrice) ||
                other.arlaPrice == arlaPrice) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            (identical(other.refuelingData, refuelingData) ||
                other.refuelingData == refuelingData) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        code,
        qrCode,
        vehicleId,
        vehiclePlate,
        userId,
        userCpf,
        stationId,
        stationCnpj,
        fuelType,
        pricePerLiter,
        maxQuantity,
        maxValue,
        currentKm,
        requiresArla,
        arlaPrice,
        validUntil,
        generatedAt,
        status,
        const DeepCollectionEquality().hash(_documents),
        refuelingData,
        cancellationReason,
        cancelledAt,
        completedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefuelingCodeModelImplCopyWith<_$RefuelingCodeModelImpl> get copyWith =>
      __$$RefuelingCodeModelImplCopyWithImpl<_$RefuelingCodeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefuelingCodeModelImplToJson(
      this,
    );
  }
}

abstract class _RefuelingCodeModel extends RefuelingCodeModel {
  const factory _RefuelingCodeModel(
      {required final String id,
      required final String code,
      @JsonKey(name: 'qr_code') required final String qrCode,
      @JsonKey(name: 'vehicle_id') required final String vehicleId,
      @JsonKey(name: 'vehicle_plate') required final String vehiclePlate,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'user_cpf') required final String userCpf,
      @JsonKey(name: 'station_id') required final String stationId,
      @JsonKey(name: 'station_cnpj') required final String stationCnpj,
      @JsonKey(name: 'fuel_type') required final String fuelType,
      @JsonKey(name: 'price_per_liter') required final double pricePerLiter,
      @JsonKey(name: 'max_quantity') required final double maxQuantity,
      @JsonKey(name: 'max_value') required final double maxValue,
      @JsonKey(name: 'current_km') required final int currentKm,
      @JsonKey(name: 'requires_arla') final bool requiresArla,
      @JsonKey(name: 'arla_price') final double? arlaPrice,
      @JsonKey(name: 'valid_until') required final DateTime validUntil,
      @JsonKey(name: 'generated_at') required final DateTime generatedAt,
      @JsonKey(name: 'status') final String status,
      @JsonKey(name: 'documents') final List<DocumentModel> documents,
      @JsonKey(name: 'refueling_data') final RefuelingDataModel? refuelingData,
      @JsonKey(name: 'cancellation_reason') final String? cancellationReason,
      @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
      @JsonKey(name: 'completed_at')
      final DateTime? completedAt}) = _$RefuelingCodeModelImpl;
  const _RefuelingCodeModel._() : super._();

  factory _RefuelingCodeModel.fromJson(Map<String, dynamic> json) =
      _$RefuelingCodeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  @JsonKey(name: 'qr_code')
  String get qrCode;
  @override
  @JsonKey(name: 'vehicle_id')
  String get vehicleId;
  @override
  @JsonKey(name: 'vehicle_plate')
  String get vehiclePlate;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_cpf')
  String get userCpf;
  @override
  @JsonKey(name: 'station_id')
  String get stationId;
  @override
  @JsonKey(name: 'station_cnpj')
  String get stationCnpj;
  @override
  @JsonKey(name: 'fuel_type')
  String get fuelType;
  @override
  @JsonKey(name: 'price_per_liter')
  double get pricePerLiter;
  @override
  @JsonKey(name: 'max_quantity')
  double get maxQuantity;
  @override
  @JsonKey(name: 'max_value')
  double get maxValue;
  @override
  @JsonKey(name: 'current_km')
  int get currentKm;
  @override
  @JsonKey(name: 'requires_arla')
  bool get requiresArla;
  @override
  @JsonKey(name: 'arla_price')
  double? get arlaPrice;
  @override
  @JsonKey(name: 'valid_until')
  DateTime get validUntil;
  @override
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'documents')
  List<DocumentModel> get documents;
  @override
  @JsonKey(name: 'refueling_data')
  RefuelingDataModel? get refuelingData;
  @override
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$RefuelingCodeModelImplCopyWith<_$RefuelingCodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) {
  return _DocumentModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  String get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_at')
  DateTime get uploadedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_by')
  String get uploadedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentModelCopyWith<DocumentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentModelCopyWith<$Res> {
  factory $DocumentModelCopyWith(
          DocumentModel value, $Res Function(DocumentModel) then) =
      _$DocumentModelCopyWithImpl<$Res, DocumentModel>;
  @useResult
  $Res call(
      {String id,
      String url,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String mimeType,
      @JsonKey(name: 'document_type') String documentType,
      @JsonKey(name: 'uploaded_at') DateTime uploadedAt,
      @JsonKey(name: 'uploaded_by') String uploadedBy});
}

/// @nodoc
class _$DocumentModelCopyWithImpl<$Res, $Val extends DocumentModel>
    implements $DocumentModelCopyWith<$Res> {
  _$DocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? documentType = null,
    Object? uploadedAt = null,
    Object? uploadedBy = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentModelImplCopyWith<$Res>
    implements $DocumentModelCopyWith<$Res> {
  factory _$$DocumentModelImplCopyWith(
          _$DocumentModelImpl value, $Res Function(_$DocumentModelImpl) then) =
      __$$DocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String mimeType,
      @JsonKey(name: 'document_type') String documentType,
      @JsonKey(name: 'uploaded_at') DateTime uploadedAt,
      @JsonKey(name: 'uploaded_by') String uploadedBy});
}

/// @nodoc
class __$$DocumentModelImplCopyWithImpl<$Res>
    extends _$DocumentModelCopyWithImpl<$Res, _$DocumentModelImpl>
    implements _$$DocumentModelImplCopyWith<$Res> {
  __$$DocumentModelImplCopyWithImpl(
      _$DocumentModelImpl _value, $Res Function(_$DocumentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? documentType = null,
    Object? uploadedAt = null,
    Object? uploadedBy = null,
  }) {
    return _then(_$DocumentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentModelImpl extends _DocumentModel {
  const _$DocumentModelImpl(
      {required this.id,
      required this.url,
      @JsonKey(name: 'file_name') required this.fileName,
      @JsonKey(name: 'file_size') required this.fileSize,
      @JsonKey(name: 'mime_type') required this.mimeType,
      @JsonKey(name: 'document_type') required this.documentType,
      @JsonKey(name: 'uploaded_at') required this.uploadedAt,
      @JsonKey(name: 'uploaded_by') required this.uploadedBy})
      : super._();

  factory _$DocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  @JsonKey(name: 'file_name')
  final String fileName;
  @override
  @JsonKey(name: 'file_size')
  final int fileSize;
  @override
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @override
  @JsonKey(name: 'document_type')
  final String documentType;
  @override
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;
  @override
  @JsonKey(name: 'uploaded_by')
  final String uploadedBy;

  @override
  String toString() {
    return 'DocumentModel(id: $id, url: $url, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, documentType: $documentType, uploadedAt: $uploadedAt, uploadedBy: $uploadedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, fileName, fileSize,
      mimeType, documentType, uploadedAt, uploadedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentModelImplCopyWith<_$DocumentModelImpl> get copyWith =>
      __$$DocumentModelImplCopyWithImpl<_$DocumentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentModelImplToJson(
      this,
    );
  }
}

abstract class _DocumentModel extends DocumentModel {
  const factory _DocumentModel(
          {required final String id,
          required final String url,
          @JsonKey(name: 'file_name') required final String fileName,
          @JsonKey(name: 'file_size') required final int fileSize,
          @JsonKey(name: 'mime_type') required final String mimeType,
          @JsonKey(name: 'document_type') required final String documentType,
          @JsonKey(name: 'uploaded_at') required final DateTime uploadedAt,
          @JsonKey(name: 'uploaded_by') required final String uploadedBy}) =
      _$DocumentModelImpl;
  const _DocumentModel._() : super._();

  factory _DocumentModel.fromJson(Map<String, dynamic> json) =
      _$DocumentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  @JsonKey(name: 'file_name')
  String get fileName;
  @override
  @JsonKey(name: 'file_size')
  int get fileSize;
  @override
  @JsonKey(name: 'mime_type')
  String get mimeType;
  @override
  @JsonKey(name: 'document_type')
  String get documentType;
  @override
  @JsonKey(name: 'uploaded_at')
  DateTime get uploadedAt;
  @override
  @JsonKey(name: 'uploaded_by')
  String get uploadedBy;
  @override
  @JsonKey(ignore: true)
  _$$DocumentModelImplCopyWith<_$DocumentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefuelingDataModel _$RefuelingDataModelFromJson(Map<String, dynamic> json) {
  return _RefuelingDataModel.fromJson(json);
}

/// @nodoc
mixin _$RefuelingDataModel {
  @JsonKey(name: 'quantity_liters')
  double get quantityLiters => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_value')
  double get totalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_km')
  int get finalKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'arla_quantity')
  double? get arlaQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'arla_value')
  double? get arlaValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'odometer_photo')
  String? get odometerPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'pump_photo')
  String? get pumpPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_photo')
  String? get receiptPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueled_at')
  DateTime get refueledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueled_by')
  String get refueledBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefuelingDataModelCopyWith<RefuelingDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefuelingDataModelCopyWith<$Res> {
  factory $RefuelingDataModelCopyWith(
          RefuelingDataModel value, $Res Function(RefuelingDataModel) then) =
      _$RefuelingDataModelCopyWithImpl<$Res, RefuelingDataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'quantity_liters') double quantityLiters,
      @JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'final_km') int finalKm,
      @JsonKey(name: 'arla_quantity') double? arlaQuantity,
      @JsonKey(name: 'arla_value') double? arlaValue,
      @JsonKey(name: 'odometer_photo') String? odometerPhoto,
      @JsonKey(name: 'pump_photo') String? pumpPhoto,
      @JsonKey(name: 'receipt_photo') String? receiptPhoto,
      @JsonKey(name: 'refueled_at') DateTime refueledAt,
      @JsonKey(name: 'refueled_by') String refueledBy,
      @JsonKey(name: 'notes') String? notes});
}

/// @nodoc
class _$RefuelingDataModelCopyWithImpl<$Res, $Val extends RefuelingDataModel>
    implements $RefuelingDataModelCopyWith<$Res> {
  _$RefuelingDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantityLiters = null,
    Object? totalValue = null,
    Object? finalKm = null,
    Object? arlaQuantity = freezed,
    Object? arlaValue = freezed,
    Object? odometerPhoto = freezed,
    Object? pumpPhoto = freezed,
    Object? receiptPhoto = freezed,
    Object? refueledAt = null,
    Object? refueledBy = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      finalKm: null == finalKm
          ? _value.finalKm
          : finalKm // ignore: cast_nullable_to_non_nullable
              as int,
      arlaQuantity: freezed == arlaQuantity
          ? _value.arlaQuantity
          : arlaQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      arlaValue: freezed == arlaValue
          ? _value.arlaValue
          : arlaValue // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerPhoto: freezed == odometerPhoto
          ? _value.odometerPhoto
          : odometerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      pumpPhoto: freezed == pumpPhoto
          ? _value.pumpPhoto
          : pumpPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptPhoto: freezed == receiptPhoto
          ? _value.receiptPhoto
          : receiptPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      refueledAt: null == refueledAt
          ? _value.refueledAt
          : refueledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refueledBy: null == refueledBy
          ? _value.refueledBy
          : refueledBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefuelingDataModelImplCopyWith<$Res>
    implements $RefuelingDataModelCopyWith<$Res> {
  factory _$$RefuelingDataModelImplCopyWith(_$RefuelingDataModelImpl value,
          $Res Function(_$RefuelingDataModelImpl) then) =
      __$$RefuelingDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'quantity_liters') double quantityLiters,
      @JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'final_km') int finalKm,
      @JsonKey(name: 'arla_quantity') double? arlaQuantity,
      @JsonKey(name: 'arla_value') double? arlaValue,
      @JsonKey(name: 'odometer_photo') String? odometerPhoto,
      @JsonKey(name: 'pump_photo') String? pumpPhoto,
      @JsonKey(name: 'receipt_photo') String? receiptPhoto,
      @JsonKey(name: 'refueled_at') DateTime refueledAt,
      @JsonKey(name: 'refueled_by') String refueledBy,
      @JsonKey(name: 'notes') String? notes});
}

/// @nodoc
class __$$RefuelingDataModelImplCopyWithImpl<$Res>
    extends _$RefuelingDataModelCopyWithImpl<$Res, _$RefuelingDataModelImpl>
    implements _$$RefuelingDataModelImplCopyWith<$Res> {
  __$$RefuelingDataModelImplCopyWithImpl(_$RefuelingDataModelImpl _value,
      $Res Function(_$RefuelingDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantityLiters = null,
    Object? totalValue = null,
    Object? finalKm = null,
    Object? arlaQuantity = freezed,
    Object? arlaValue = freezed,
    Object? odometerPhoto = freezed,
    Object? pumpPhoto = freezed,
    Object? receiptPhoto = freezed,
    Object? refueledAt = null,
    Object? refueledBy = null,
    Object? notes = freezed,
  }) {
    return _then(_$RefuelingDataModelImpl(
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      finalKm: null == finalKm
          ? _value.finalKm
          : finalKm // ignore: cast_nullable_to_non_nullable
              as int,
      arlaQuantity: freezed == arlaQuantity
          ? _value.arlaQuantity
          : arlaQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      arlaValue: freezed == arlaValue
          ? _value.arlaValue
          : arlaValue // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerPhoto: freezed == odometerPhoto
          ? _value.odometerPhoto
          : odometerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      pumpPhoto: freezed == pumpPhoto
          ? _value.pumpPhoto
          : pumpPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptPhoto: freezed == receiptPhoto
          ? _value.receiptPhoto
          : receiptPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      refueledAt: null == refueledAt
          ? _value.refueledAt
          : refueledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refueledBy: null == refueledBy
          ? _value.refueledBy
          : refueledBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefuelingDataModelImpl implements _RefuelingDataModel {
  const _$RefuelingDataModelImpl(
      {@JsonKey(name: 'quantity_liters') required this.quantityLiters,
      @JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'final_km') required this.finalKm,
      @JsonKey(name: 'arla_quantity') this.arlaQuantity,
      @JsonKey(name: 'arla_value') this.arlaValue,
      @JsonKey(name: 'odometer_photo') this.odometerPhoto,
      @JsonKey(name: 'pump_photo') this.pumpPhoto,
      @JsonKey(name: 'receipt_photo') this.receiptPhoto,
      @JsonKey(name: 'refueled_at') required this.refueledAt,
      @JsonKey(name: 'refueled_by') required this.refueledBy,
      @JsonKey(name: 'notes') this.notes});

  factory _$RefuelingDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefuelingDataModelImplFromJson(json);

  @override
  @JsonKey(name: 'quantity_liters')
  final double quantityLiters;
  @override
  @JsonKey(name: 'total_value')
  final double totalValue;
  @override
  @JsonKey(name: 'final_km')
  final int finalKm;
  @override
  @JsonKey(name: 'arla_quantity')
  final double? arlaQuantity;
  @override
  @JsonKey(name: 'arla_value')
  final double? arlaValue;
  @override
  @JsonKey(name: 'odometer_photo')
  final String? odometerPhoto;
  @override
  @JsonKey(name: 'pump_photo')
  final String? pumpPhoto;
  @override
  @JsonKey(name: 'receipt_photo')
  final String? receiptPhoto;
  @override
  @JsonKey(name: 'refueled_at')
  final DateTime refueledAt;
  @override
  @JsonKey(name: 'refueled_by')
  final String refueledBy;
  @override
  @JsonKey(name: 'notes')
  final String? notes;

  @override
  String toString() {
    return 'RefuelingDataModel(quantityLiters: $quantityLiters, totalValue: $totalValue, finalKm: $finalKm, arlaQuantity: $arlaQuantity, arlaValue: $arlaValue, odometerPhoto: $odometerPhoto, pumpPhoto: $pumpPhoto, receiptPhoto: $receiptPhoto, refueledAt: $refueledAt, refueledBy: $refueledBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefuelingDataModelImpl &&
            (identical(other.quantityLiters, quantityLiters) ||
                other.quantityLiters == quantityLiters) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.finalKm, finalKm) || other.finalKm == finalKm) &&
            (identical(other.arlaQuantity, arlaQuantity) ||
                other.arlaQuantity == arlaQuantity) &&
            (identical(other.arlaValue, arlaValue) ||
                other.arlaValue == arlaValue) &&
            (identical(other.odometerPhoto, odometerPhoto) ||
                other.odometerPhoto == odometerPhoto) &&
            (identical(other.pumpPhoto, pumpPhoto) ||
                other.pumpPhoto == pumpPhoto) &&
            (identical(other.receiptPhoto, receiptPhoto) ||
                other.receiptPhoto == receiptPhoto) &&
            (identical(other.refueledAt, refueledAt) ||
                other.refueledAt == refueledAt) &&
            (identical(other.refueledBy, refueledBy) ||
                other.refueledBy == refueledBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      quantityLiters,
      totalValue,
      finalKm,
      arlaQuantity,
      arlaValue,
      odometerPhoto,
      pumpPhoto,
      receiptPhoto,
      refueledAt,
      refueledBy,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefuelingDataModelImplCopyWith<_$RefuelingDataModelImpl> get copyWith =>
      __$$RefuelingDataModelImplCopyWithImpl<_$RefuelingDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefuelingDataModelImplToJson(
      this,
    );
  }
}

abstract class _RefuelingDataModel implements RefuelingDataModel {
  const factory _RefuelingDataModel(
      {@JsonKey(name: 'quantity_liters') required final double quantityLiters,
      @JsonKey(name: 'total_value') required final double totalValue,
      @JsonKey(name: 'final_km') required final int finalKm,
      @JsonKey(name: 'arla_quantity') final double? arlaQuantity,
      @JsonKey(name: 'arla_value') final double? arlaValue,
      @JsonKey(name: 'odometer_photo') final String? odometerPhoto,
      @JsonKey(name: 'pump_photo') final String? pumpPhoto,
      @JsonKey(name: 'receipt_photo') final String? receiptPhoto,
      @JsonKey(name: 'refueled_at') required final DateTime refueledAt,
      @JsonKey(name: 'refueled_by') required final String refueledBy,
      @JsonKey(name: 'notes') final String? notes}) = _$RefuelingDataModelImpl;

  factory _RefuelingDataModel.fromJson(Map<String, dynamic> json) =
      _$RefuelingDataModelImpl.fromJson;

  @override
  @JsonKey(name: 'quantity_liters')
  double get quantityLiters;
  @override
  @JsonKey(name: 'total_value')
  double get totalValue;
  @override
  @JsonKey(name: 'final_km')
  int get finalKm;
  @override
  @JsonKey(name: 'arla_quantity')
  double? get arlaQuantity;
  @override
  @JsonKey(name: 'arla_value')
  double? get arlaValue;
  @override
  @JsonKey(name: 'odometer_photo')
  String? get odometerPhoto;
  @override
  @JsonKey(name: 'pump_photo')
  String? get pumpPhoto;
  @override
  @JsonKey(name: 'receipt_photo')
  String? get receiptPhoto;
  @override
  @JsonKey(name: 'refueled_at')
  DateTime get refueledAt;
  @override
  @JsonKey(name: 'refueled_by')
  String get refueledBy;
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$RefuelingDataModelImplCopyWith<_$RefuelingDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefuelingRequestModel _$RefuelingRequestModelFromJson(
    Map<String, dynamic> json) {
  return _RefuelingRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RefuelingRequestModel {
  @JsonKey(name: 'vehicle_id')
  String get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type')
  String get fuelType => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_km')
  int get currentKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_quantity')
  double get maxQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_value')
  double get maxValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_arla')
  bool get requiresArla => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefuelingRequestModelCopyWith<RefuelingRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefuelingRequestModelCopyWith<$Res> {
  factory $RefuelingRequestModelCopyWith(RefuelingRequestModel value,
          $Res Function(RefuelingRequestModel) then) =
      _$RefuelingRequestModelCopyWithImpl<$Res, RefuelingRequestModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'station_id') String stationId,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'current_km') int currentKm,
      @JsonKey(name: 'max_quantity') double maxQuantity,
      @JsonKey(name: 'max_value') double maxValue,
      @JsonKey(name: 'requires_arla') bool requiresArla,
      @JsonKey(name: 'notes') String? notes});
}

/// @nodoc
class _$RefuelingRequestModelCopyWithImpl<$Res,
        $Val extends RefuelingRequestModel>
    implements $RefuelingRequestModelCopyWith<$Res> {
  _$RefuelingRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? stationId = null,
    Object? fuelType = null,
    Object? currentKm = null,
    Object? maxQuantity = null,
    Object? maxValue = null,
    Object? requiresArla = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      currentKm: null == currentKm
          ? _value.currentKm
          : currentKm // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      requiresArla: null == requiresArla
          ? _value.requiresArla
          : requiresArla // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefuelingRequestModelImplCopyWith<$Res>
    implements $RefuelingRequestModelCopyWith<$Res> {
  factory _$$RefuelingRequestModelImplCopyWith(
          _$RefuelingRequestModelImpl value,
          $Res Function(_$RefuelingRequestModelImpl) then) =
      __$$RefuelingRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'station_id') String stationId,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'current_km') int currentKm,
      @JsonKey(name: 'max_quantity') double maxQuantity,
      @JsonKey(name: 'max_value') double maxValue,
      @JsonKey(name: 'requires_arla') bool requiresArla,
      @JsonKey(name: 'notes') String? notes});
}

/// @nodoc
class __$$RefuelingRequestModelImplCopyWithImpl<$Res>
    extends _$RefuelingRequestModelCopyWithImpl<$Res,
        _$RefuelingRequestModelImpl>
    implements _$$RefuelingRequestModelImplCopyWith<$Res> {
  __$$RefuelingRequestModelImplCopyWithImpl(_$RefuelingRequestModelImpl _value,
      $Res Function(_$RefuelingRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? stationId = null,
    Object? fuelType = null,
    Object? currentKm = null,
    Object? maxQuantity = null,
    Object? maxValue = null,
    Object? requiresArla = null,
    Object? notes = freezed,
  }) {
    return _then(_$RefuelingRequestModelImpl(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      currentKm: null == currentKm
          ? _value.currentKm
          : currentKm // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      requiresArla: null == requiresArla
          ? _value.requiresArla
          : requiresArla // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefuelingRequestModelImpl implements _RefuelingRequestModel {
  const _$RefuelingRequestModelImpl(
      {@JsonKey(name: 'vehicle_id') required this.vehicleId,
      @JsonKey(name: 'station_id') required this.stationId,
      @JsonKey(name: 'fuel_type') required this.fuelType,
      @JsonKey(name: 'current_km') required this.currentKm,
      @JsonKey(name: 'max_quantity') required this.maxQuantity,
      @JsonKey(name: 'max_value') required this.maxValue,
      @JsonKey(name: 'requires_arla') this.requiresArla = false,
      @JsonKey(name: 'notes') this.notes});

  factory _$RefuelingRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefuelingRequestModelImplFromJson(json);

  @override
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @override
  @JsonKey(name: 'station_id')
  final String stationId;
  @override
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @override
  @JsonKey(name: 'current_km')
  final int currentKm;
  @override
  @JsonKey(name: 'max_quantity')
  final double maxQuantity;
  @override
  @JsonKey(name: 'max_value')
  final double maxValue;
  @override
  @JsonKey(name: 'requires_arla')
  final bool requiresArla;
  @override
  @JsonKey(name: 'notes')
  final String? notes;

  @override
  String toString() {
    return 'RefuelingRequestModel(vehicleId: $vehicleId, stationId: $stationId, fuelType: $fuelType, currentKm: $currentKm, maxQuantity: $maxQuantity, maxValue: $maxValue, requiresArla: $requiresArla, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefuelingRequestModelImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.currentKm, currentKm) ||
                other.currentKm == currentKm) &&
            (identical(other.maxQuantity, maxQuantity) ||
                other.maxQuantity == maxQuantity) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.requiresArla, requiresArla) ||
                other.requiresArla == requiresArla) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, vehicleId, stationId, fuelType,
      currentKm, maxQuantity, maxValue, requiresArla, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefuelingRequestModelImplCopyWith<_$RefuelingRequestModelImpl>
      get copyWith => __$$RefuelingRequestModelImplCopyWithImpl<
          _$RefuelingRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefuelingRequestModelImplToJson(
      this,
    );
  }
}

abstract class _RefuelingRequestModel implements RefuelingRequestModel {
  const factory _RefuelingRequestModel(
          {@JsonKey(name: 'vehicle_id') required final String vehicleId,
          @JsonKey(name: 'station_id') required final String stationId,
          @JsonKey(name: 'fuel_type') required final String fuelType,
          @JsonKey(name: 'current_km') required final int currentKm,
          @JsonKey(name: 'max_quantity') required final double maxQuantity,
          @JsonKey(name: 'max_value') required final double maxValue,
          @JsonKey(name: 'requires_arla') final bool requiresArla,
          @JsonKey(name: 'notes') final String? notes}) =
      _$RefuelingRequestModelImpl;

  factory _RefuelingRequestModel.fromJson(Map<String, dynamic> json) =
      _$RefuelingRequestModelImpl.fromJson;

  @override
  @JsonKey(name: 'vehicle_id')
  String get vehicleId;
  @override
  @JsonKey(name: 'station_id')
  String get stationId;
  @override
  @JsonKey(name: 'fuel_type')
  String get fuelType;
  @override
  @JsonKey(name: 'current_km')
  int get currentKm;
  @override
  @JsonKey(name: 'max_quantity')
  double get maxQuantity;
  @override
  @JsonKey(name: 'max_value')
  double get maxValue;
  @override
  @JsonKey(name: 'requires_arla')
  bool get requiresArla;
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$RefuelingRequestModelImplCopyWith<_$RefuelingRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
