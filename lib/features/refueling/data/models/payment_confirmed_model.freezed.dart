// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_confirmed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentConfirmedModel _$PaymentConfirmedModelFromJson(
    Map<String, dynamic> json) {
  return _PaymentConfirmedModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentConfirmedModel {
  @JsonKey(name: 'refuelingCode')
  String get refuelingCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get totalValue => throw _privateConstructorUsedError;
  double get quantityLiters => throw _privateConstructorUsedError;
  double get pricePerLiter => throw _privateConstructorUsedError;
  double get pumpPrice => throw _privateConstructorUsedError;
  double get savings => throw _privateConstructorUsedError;
  @JsonKey(name: 'savingsPerLiter')
  double? get savingsPerLiter => throw _privateConstructorUsedError;
  String get stationName => throw _privateConstructorUsedError;
  String get vehiclePlate => throw _privateConstructorUsedError;
  String get fuelType => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentConfirmedModelCopyWith<PaymentConfirmedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentConfirmedModelCopyWith<$Res> {
  factory $PaymentConfirmedModelCopyWith(PaymentConfirmedModel value,
          $Res Function(PaymentConfirmedModel) then) =
      _$PaymentConfirmedModelCopyWithImpl<$Res, PaymentConfirmedModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'refuelingCode') String refuelingCode,
      String status,
      double totalValue,
      double quantityLiters,
      double pricePerLiter,
      double pumpPrice,
      double savings,
      @JsonKey(name: 'savingsPerLiter') double? savingsPerLiter,
      String stationName,
      String vehiclePlate,
      String fuelType,
      String timestamp});
}

/// @nodoc
class _$PaymentConfirmedModelCopyWithImpl<$Res,
        $Val extends PaymentConfirmedModel>
    implements $PaymentConfirmedModelCopyWith<$Res> {
  _$PaymentConfirmedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refuelingCode = null,
    Object? status = null,
    Object? totalValue = null,
    Object? quantityLiters = null,
    Object? pricePerLiter = null,
    Object? pumpPrice = null,
    Object? savings = null,
    Object? savingsPerLiter = freezed,
    Object? stationName = null,
    Object? vehiclePlate = null,
    Object? fuelType = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      refuelingCode: null == refuelingCode
          ? _value.refuelingCode
          : refuelingCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      pumpPrice: null == pumpPrice
          ? _value.pumpPrice
          : pumpPrice // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPerLiter: freezed == savingsPerLiter
          ? _value.savingsPerLiter
          : savingsPerLiter // ignore: cast_nullable_to_non_nullable
              as double?,
      stationName: null == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentConfirmedModelImplCopyWith<$Res>
    implements $PaymentConfirmedModelCopyWith<$Res> {
  factory _$$PaymentConfirmedModelImplCopyWith(
          _$PaymentConfirmedModelImpl value,
          $Res Function(_$PaymentConfirmedModelImpl) then) =
      __$$PaymentConfirmedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'refuelingCode') String refuelingCode,
      String status,
      double totalValue,
      double quantityLiters,
      double pricePerLiter,
      double pumpPrice,
      double savings,
      @JsonKey(name: 'savingsPerLiter') double? savingsPerLiter,
      String stationName,
      String vehiclePlate,
      String fuelType,
      String timestamp});
}

/// @nodoc
class __$$PaymentConfirmedModelImplCopyWithImpl<$Res>
    extends _$PaymentConfirmedModelCopyWithImpl<$Res,
        _$PaymentConfirmedModelImpl>
    implements _$$PaymentConfirmedModelImplCopyWith<$Res> {
  __$$PaymentConfirmedModelImplCopyWithImpl(_$PaymentConfirmedModelImpl _value,
      $Res Function(_$PaymentConfirmedModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refuelingCode = null,
    Object? status = null,
    Object? totalValue = null,
    Object? quantityLiters = null,
    Object? pricePerLiter = null,
    Object? pumpPrice = null,
    Object? savings = null,
    Object? savingsPerLiter = freezed,
    Object? stationName = null,
    Object? vehiclePlate = null,
    Object? fuelType = null,
    Object? timestamp = null,
  }) {
    return _then(_$PaymentConfirmedModelImpl(
      refuelingCode: null == refuelingCode
          ? _value.refuelingCode
          : refuelingCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      pumpPrice: null == pumpPrice
          ? _value.pumpPrice
          : pumpPrice // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPerLiter: freezed == savingsPerLiter
          ? _value.savingsPerLiter
          : savingsPerLiter // ignore: cast_nullable_to_non_nullable
              as double?,
      stationName: null == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentConfirmedModelImpl implements _PaymentConfirmedModel {
  const _$PaymentConfirmedModelImpl(
      {@JsonKey(name: 'refuelingCode') required this.refuelingCode,
      required this.status,
      required this.totalValue,
      required this.quantityLiters,
      required this.pricePerLiter,
      required this.pumpPrice,
      required this.savings,
      @JsonKey(name: 'savingsPerLiter') this.savingsPerLiter,
      required this.stationName,
      required this.vehiclePlate,
      required this.fuelType,
      required this.timestamp});

  factory _$PaymentConfirmedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentConfirmedModelImplFromJson(json);

  @override
  @JsonKey(name: 'refuelingCode')
  final String refuelingCode;
  @override
  final String status;
  @override
  final double totalValue;
  @override
  final double quantityLiters;
  @override
  final double pricePerLiter;
  @override
  final double pumpPrice;
  @override
  final double savings;
  @override
  @JsonKey(name: 'savingsPerLiter')
  final double? savingsPerLiter;
  @override
  final String stationName;
  @override
  final String vehiclePlate;
  @override
  final String fuelType;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PaymentConfirmedModel(refuelingCode: $refuelingCode, status: $status, totalValue: $totalValue, quantityLiters: $quantityLiters, pricePerLiter: $pricePerLiter, pumpPrice: $pumpPrice, savings: $savings, savingsPerLiter: $savingsPerLiter, stationName: $stationName, vehiclePlate: $vehiclePlate, fuelType: $fuelType, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentConfirmedModelImpl &&
            (identical(other.refuelingCode, refuelingCode) ||
                other.refuelingCode == refuelingCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.quantityLiters, quantityLiters) ||
                other.quantityLiters == quantityLiters) &&
            (identical(other.pricePerLiter, pricePerLiter) ||
                other.pricePerLiter == pricePerLiter) &&
            (identical(other.pumpPrice, pumpPrice) ||
                other.pumpPrice == pumpPrice) &&
            (identical(other.savings, savings) || other.savings == savings) &&
            (identical(other.savingsPerLiter, savingsPerLiter) ||
                other.savingsPerLiter == savingsPerLiter) &&
            (identical(other.stationName, stationName) ||
                other.stationName == stationName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      refuelingCode,
      status,
      totalValue,
      quantityLiters,
      pricePerLiter,
      pumpPrice,
      savings,
      savingsPerLiter,
      stationName,
      vehiclePlate,
      fuelType,
      timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentConfirmedModelImplCopyWith<_$PaymentConfirmedModelImpl>
      get copyWith => __$$PaymentConfirmedModelImplCopyWithImpl<
          _$PaymentConfirmedModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentConfirmedModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentConfirmedModel implements PaymentConfirmedModel {
  const factory _PaymentConfirmedModel(
      {@JsonKey(name: 'refuelingCode') required final String refuelingCode,
      required final String status,
      required final double totalValue,
      required final double quantityLiters,
      required final double pricePerLiter,
      required final double pumpPrice,
      required final double savings,
      @JsonKey(name: 'savingsPerLiter') final double? savingsPerLiter,
      required final String stationName,
      required final String vehiclePlate,
      required final String fuelType,
      required final String timestamp}) = _$PaymentConfirmedModelImpl;

  factory _PaymentConfirmedModel.fromJson(Map<String, dynamic> json) =
      _$PaymentConfirmedModelImpl.fromJson;

  @override
  @JsonKey(name: 'refuelingCode')
  String get refuelingCode;
  @override
  String get status;
  @override
  double get totalValue;
  @override
  double get quantityLiters;
  @override
  double get pricePerLiter;
  @override
  double get pumpPrice;
  @override
  double get savings;
  @override
  @JsonKey(name: 'savingsPerLiter')
  double? get savingsPerLiter;
  @override
  String get stationName;
  @override
  String get vehiclePlate;
  @override
  String get fuelType;
  @override
  String get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$PaymentConfirmedModelImplCopyWith<_$PaymentConfirmedModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
