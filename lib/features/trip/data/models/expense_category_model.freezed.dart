// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseCategoryModel _$ExpenseCategoryModelFromJson(Map<String, dynamic> json) {
  return _ExpenseCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCategoryModelCopyWith<ExpenseCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryModelCopyWith<$Res> {
  factory $ExpenseCategoryModelCopyWith(ExpenseCategoryModel value,
          $Res Function(ExpenseCategoryModel) then) =
      _$ExpenseCategoryModelCopyWithImpl<$Res, ExpenseCategoryModel>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String? icon,
      String? color,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ExpenseCategoryModelCopyWithImpl<$Res,
        $Val extends ExpenseCategoryModel>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  _$ExpenseCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryModelImplCopyWith<$Res>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  factory _$$ExpenseCategoryModelImplCopyWith(_$ExpenseCategoryModelImpl value,
          $Res Function(_$ExpenseCategoryModelImpl) then) =
      __$$ExpenseCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String? icon,
      String? color,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ExpenseCategoryModelImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryModelCopyWithImpl<$Res, _$ExpenseCategoryModelImpl>
    implements _$$ExpenseCategoryModelImplCopyWith<$Res> {
  __$$ExpenseCategoryModelImplCopyWithImpl(_$ExpenseCategoryModelImpl _value,
      $Res Function(_$ExpenseCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ExpenseCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryModelImpl extends _ExpenseCategoryModel {
  const _$ExpenseCategoryModelImpl(
      {required this.id,
      required this.code,
      required this.name,
      this.icon,
      this.color,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$ExpenseCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ExpenseCategoryModel(id: $id, code: $code, name: $name, icon: $icon, color: $color, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, code, name, icon, color, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryModelImplCopyWith<_$ExpenseCategoryModelImpl>
      get copyWith =>
          __$$ExpenseCategoryModelImplCopyWithImpl<_$ExpenseCategoryModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseCategoryModel extends ExpenseCategoryModel {
  const factory _ExpenseCategoryModel(
          {required final String id,
          required final String code,
          required final String name,
          final String? icon,
          final String? color,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$ExpenseCategoryModelImpl;
  const _ExpenseCategoryModel._() : super._();

  factory _ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseCategoryModelImplCopyWith<_$ExpenseCategoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
