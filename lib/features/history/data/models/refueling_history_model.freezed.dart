// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refueling_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefuelingHistoryModel _$RefuelingHistoryModelFromJson(
    Map<String, dynamic> json) {
  return _RefuelingHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$RefuelingHistoryModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_code')
  String get refuelingCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_datetime')
  DateTime get refuelingDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_name')
  String? get stationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_cnpj')
  String? get stationCnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate')
  String get vehiclePlate => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type')
  String get fuelType => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_liters')
  double get quantityLiters => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_autonomous')
  bool get isAutonomous => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'transporter_name')
  String? get transporterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_nfe')
  bool get hasNfe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefuelingHistoryModelCopyWith<RefuelingHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefuelingHistoryModelCopyWith<$Res> {
  factory $RefuelingHistoryModelCopyWith(RefuelingHistoryModel value,
          $Res Function(RefuelingHistoryModel) then) =
      _$RefuelingHistoryModelCopyWithImpl<$Res, RefuelingHistoryModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'refueling_code') String refuelingCode,
      @JsonKey(name: 'refueling_datetime') DateTime refuelingDatetime,
      @JsonKey(name: 'station_name') String? stationName,
      @JsonKey(name: 'station_cnpj') String? stationCnpj,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String vehiclePlate,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'quantity_liters') double quantityLiters,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_autonomous') bool isAutonomous,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'transporter_name') String? transporterName,
      @JsonKey(name: 'unit_price') double? unitPrice,
      @JsonKey(name: 'has_nfe') bool hasNfe});
}

/// @nodoc
class _$RefuelingHistoryModelCopyWithImpl<$Res,
        $Val extends RefuelingHistoryModel>
    implements $RefuelingHistoryModelCopyWith<$Res> {
  _$RefuelingHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refuelingCode = null,
    Object? refuelingDatetime = null,
    Object? stationName = freezed,
    Object? stationCnpj = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = null,
    Object? fuelType = null,
    Object? quantityLiters = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? isAutonomous = null,
    Object? paymentMethod = freezed,
    Object? transporterName = freezed,
    Object? unitPrice = freezed,
    Object? hasNfe = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      refuelingCode: null == refuelingCode
          ? _value.refuelingCode
          : refuelingCode // ignore: cast_nullable_to_non_nullable
              as String,
      refuelingDatetime: null == refuelingDatetime
          ? _value.refuelingDatetime
          : refuelingDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stationName: freezed == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String?,
      stationCnpj: freezed == stationCnpj
          ? _value.stationCnpj
          : stationCnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAutonomous: null == isAutonomous
          ? _value.isAutonomous
          : isAutonomous // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      transporterName: freezed == transporterName
          ? _value.transporterName
          : transporterName // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      hasNfe: null == hasNfe
          ? _value.hasNfe
          : hasNfe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefuelingHistoryModelImplCopyWith<$Res>
    implements $RefuelingHistoryModelCopyWith<$Res> {
  factory _$$RefuelingHistoryModelImplCopyWith(
          _$RefuelingHistoryModelImpl value,
          $Res Function(_$RefuelingHistoryModelImpl) then) =
      __$$RefuelingHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'refueling_code') String refuelingCode,
      @JsonKey(name: 'refueling_datetime') DateTime refuelingDatetime,
      @JsonKey(name: 'station_name') String? stationName,
      @JsonKey(name: 'station_cnpj') String? stationCnpj,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String vehiclePlate,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'quantity_liters') double quantityLiters,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_autonomous') bool isAutonomous,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'transporter_name') String? transporterName,
      @JsonKey(name: 'unit_price') double? unitPrice,
      @JsonKey(name: 'has_nfe') bool hasNfe});
}

/// @nodoc
class __$$RefuelingHistoryModelImplCopyWithImpl<$Res>
    extends _$RefuelingHistoryModelCopyWithImpl<$Res,
        _$RefuelingHistoryModelImpl>
    implements _$$RefuelingHistoryModelImplCopyWith<$Res> {
  __$$RefuelingHistoryModelImplCopyWithImpl(_$RefuelingHistoryModelImpl _value,
      $Res Function(_$RefuelingHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refuelingCode = null,
    Object? refuelingDatetime = null,
    Object? stationName = freezed,
    Object? stationCnpj = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = null,
    Object? fuelType = null,
    Object? quantityLiters = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? isAutonomous = null,
    Object? paymentMethod = freezed,
    Object? transporterName = freezed,
    Object? unitPrice = freezed,
    Object? hasNfe = null,
  }) {
    return _then(_$RefuelingHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      refuelingCode: null == refuelingCode
          ? _value.refuelingCode
          : refuelingCode // ignore: cast_nullable_to_non_nullable
              as String,
      refuelingDatetime: null == refuelingDatetime
          ? _value.refuelingDatetime
          : refuelingDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stationName: freezed == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String?,
      stationCnpj: freezed == stationCnpj
          ? _value.stationCnpj
          : stationCnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: null == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      quantityLiters: null == quantityLiters
          ? _value.quantityLiters
          : quantityLiters // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAutonomous: null == isAutonomous
          ? _value.isAutonomous
          : isAutonomous // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      transporterName: freezed == transporterName
          ? _value.transporterName
          : transporterName // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      hasNfe: null == hasNfe
          ? _value.hasNfe
          : hasNfe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefuelingHistoryModelImpl extends _RefuelingHistoryModel {
  const _$RefuelingHistoryModelImpl(
      {required this.id,
      @JsonKey(name: 'refueling_code') required this.refuelingCode,
      @JsonKey(name: 'refueling_datetime') required this.refuelingDatetime,
      @JsonKey(name: 'station_name') this.stationName,
      @JsonKey(name: 'station_cnpj') this.stationCnpj,
      @JsonKey(name: 'driver_name') this.driverName,
      @JsonKey(name: 'vehicle_plate') required this.vehiclePlate,
      @JsonKey(name: 'fuel_type') required this.fuelType,
      @JsonKey(name: 'quantity_liters') required this.quantityLiters,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      required this.status,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'is_autonomous') this.isAutonomous = false,
      @JsonKey(name: 'payment_method') this.paymentMethod,
      @JsonKey(name: 'transporter_name') this.transporterName,
      @JsonKey(name: 'unit_price') this.unitPrice,
      @JsonKey(name: 'has_nfe') this.hasNfe = false})
      : super._();

  factory _$RefuelingHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefuelingHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'refueling_code')
  final String refuelingCode;
  @override
  @JsonKey(name: 'refueling_datetime')
  final DateTime refuelingDatetime;
  @override
  @JsonKey(name: 'station_name')
  final String? stationName;
  @override
  @JsonKey(name: 'station_cnpj')
  final String? stationCnpj;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  final String vehiclePlate;
  @override
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @override
  @JsonKey(name: 'quantity_liters')
  final double quantityLiters;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'is_autonomous')
  final bool isAutonomous;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'transporter_name')
  final String? transporterName;
  @override
  @JsonKey(name: 'unit_price')
  final double? unitPrice;
  @override
  @JsonKey(name: 'has_nfe')
  final bool hasNfe;

  @override
  String toString() {
    return 'RefuelingHistoryModel(id: $id, refuelingCode: $refuelingCode, refuelingDatetime: $refuelingDatetime, stationName: $stationName, stationCnpj: $stationCnpj, driverName: $driverName, vehiclePlate: $vehiclePlate, fuelType: $fuelType, quantityLiters: $quantityLiters, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, isAutonomous: $isAutonomous, paymentMethod: $paymentMethod, transporterName: $transporterName, unitPrice: $unitPrice, hasNfe: $hasNfe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefuelingHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.refuelingCode, refuelingCode) ||
                other.refuelingCode == refuelingCode) &&
            (identical(other.refuelingDatetime, refuelingDatetime) ||
                other.refuelingDatetime == refuelingDatetime) &&
            (identical(other.stationName, stationName) ||
                other.stationName == stationName) &&
            (identical(other.stationCnpj, stationCnpj) ||
                other.stationCnpj == stationCnpj) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.quantityLiters, quantityLiters) ||
                other.quantityLiters == quantityLiters) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isAutonomous, isAutonomous) ||
                other.isAutonomous == isAutonomous) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.transporterName, transporterName) ||
                other.transporterName == transporterName) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.hasNfe, hasNfe) || other.hasNfe == hasNfe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      refuelingCode,
      refuelingDatetime,
      stationName,
      stationCnpj,
      driverName,
      vehiclePlate,
      fuelType,
      quantityLiters,
      totalAmount,
      status,
      createdAt,
      isAutonomous,
      paymentMethod,
      transporterName,
      unitPrice,
      hasNfe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefuelingHistoryModelImplCopyWith<_$RefuelingHistoryModelImpl>
      get copyWith => __$$RefuelingHistoryModelImplCopyWithImpl<
          _$RefuelingHistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefuelingHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _RefuelingHistoryModel extends RefuelingHistoryModel {
  const factory _RefuelingHistoryModel(
      {required final String id,
      @JsonKey(name: 'refueling_code') required final String refuelingCode,
      @JsonKey(name: 'refueling_datetime')
      required final DateTime refuelingDatetime,
      @JsonKey(name: 'station_name') final String? stationName,
      @JsonKey(name: 'station_cnpj') final String? stationCnpj,
      @JsonKey(name: 'driver_name') final String? driverName,
      @JsonKey(name: 'vehicle_plate') required final String vehiclePlate,
      @JsonKey(name: 'fuel_type') required final String fuelType,
      @JsonKey(name: 'quantity_liters') required final double quantityLiters,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      required final String status,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'is_autonomous') final bool isAutonomous,
      @JsonKey(name: 'payment_method') final String? paymentMethod,
      @JsonKey(name: 'transporter_name') final String? transporterName,
      @JsonKey(name: 'unit_price') final double? unitPrice,
      @JsonKey(name: 'has_nfe')
      final bool hasNfe}) = _$RefuelingHistoryModelImpl;
  const _RefuelingHistoryModel._() : super._();

  factory _RefuelingHistoryModel.fromJson(Map<String, dynamic> json) =
      _$RefuelingHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'refueling_code')
  String get refuelingCode;
  @override
  @JsonKey(name: 'refueling_datetime')
  DateTime get refuelingDatetime;
  @override
  @JsonKey(name: 'station_name')
  String? get stationName;
  @override
  @JsonKey(name: 'station_cnpj')
  String? get stationCnpj;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  String get vehiclePlate;
  @override
  @JsonKey(name: 'fuel_type')
  String get fuelType;
  @override
  @JsonKey(name: 'quantity_liters')
  double get quantityLiters;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'is_autonomous')
  bool get isAutonomous;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'transporter_name')
  String? get transporterName;
  @override
  @JsonKey(name: 'unit_price')
  double? get unitPrice;
  @override
  @JsonKey(name: 'has_nfe')
  bool get hasNfe;
  @override
  @JsonKey(ignore: true)
  _$$RefuelingHistoryModelImplCopyWith<_$RefuelingHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HistoryResponseModel _$HistoryResponseModelFromJson(Map<String, dynamic> json) {
  return _HistoryResponseModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryResponseModel {
  List<RefuelingHistoryModel> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HistoryResponseModelCopyWith<HistoryResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryResponseModelCopyWith<$Res> {
  factory $HistoryResponseModelCopyWith(HistoryResponseModel value,
          $Res Function(HistoryResponseModel) then) =
      _$HistoryResponseModelCopyWithImpl<$Res, HistoryResponseModel>;
  @useResult
  $Res call({List<RefuelingHistoryModel> data, int total, int page, int limit});
}

/// @nodoc
class _$HistoryResponseModelCopyWithImpl<$Res,
        $Val extends HistoryResponseModel>
    implements $HistoryResponseModelCopyWith<$Res> {
  _$HistoryResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<RefuelingHistoryModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryResponseModelImplCopyWith<$Res>
    implements $HistoryResponseModelCopyWith<$Res> {
  factory _$$HistoryResponseModelImplCopyWith(_$HistoryResponseModelImpl value,
          $Res Function(_$HistoryResponseModelImpl) then) =
      __$$HistoryResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RefuelingHistoryModel> data, int total, int page, int limit});
}

/// @nodoc
class __$$HistoryResponseModelImplCopyWithImpl<$Res>
    extends _$HistoryResponseModelCopyWithImpl<$Res, _$HistoryResponseModelImpl>
    implements _$$HistoryResponseModelImplCopyWith<$Res> {
  __$$HistoryResponseModelImplCopyWithImpl(_$HistoryResponseModelImpl _value,
      $Res Function(_$HistoryResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_$HistoryResponseModelImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<RefuelingHistoryModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryResponseModelImpl extends _HistoryResponseModel {
  const _$HistoryResponseModelImpl(
      {required final List<RefuelingHistoryModel> data,
      required this.total,
      required this.page,
      required this.limit})
      : _data = data,
        super._();

  factory _$HistoryResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryResponseModelImplFromJson(json);

  final List<RefuelingHistoryModel> _data;
  @override
  List<RefuelingHistoryModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;

  @override
  String toString() {
    return 'HistoryResponseModel(data: $data, total: $total, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryResponseModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), total, page, limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryResponseModelImplCopyWith<_$HistoryResponseModelImpl>
      get copyWith =>
          __$$HistoryResponseModelImplCopyWithImpl<_$HistoryResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryResponseModelImplToJson(
      this,
    );
  }
}

abstract class _HistoryResponseModel extends HistoryResponseModel {
  const factory _HistoryResponseModel(
      {required final List<RefuelingHistoryModel> data,
      required final int total,
      required final int page,
      required final int limit}) = _$HistoryResponseModelImpl;
  const _HistoryResponseModel._() : super._();

  factory _HistoryResponseModel.fromJson(Map<String, dynamic> json) =
      _$HistoryResponseModelImpl.fromJson;

  @override
  List<RefuelingHistoryModel> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  @JsonKey(ignore: true)
  _$$HistoryResponseModelImplCopyWith<_$HistoryResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
