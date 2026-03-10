// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) {
  return _LoginDto.fromJson(json);
}

/// @nodoc
mixin _$LoginDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginDtoCopyWith<LoginDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginDtoCopyWith<$Res> {
  factory $LoginDtoCopyWith(LoginDto value, $Res Function(LoginDto) then) =
      _$LoginDtoCopyWithImpl<$Res, LoginDto>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginDtoCopyWithImpl<$Res, $Val extends LoginDto>
    implements $LoginDtoCopyWith<$Res> {
  _$LoginDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginDtoImplCopyWith<$Res>
    implements $LoginDtoCopyWith<$Res> {
  factory _$$LoginDtoImplCopyWith(
    _$LoginDtoImpl value,
    $Res Function(_$LoginDtoImpl) then,
  ) = __$$LoginDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginDtoImplCopyWithImpl<$Res>
    extends _$LoginDtoCopyWithImpl<$Res, _$LoginDtoImpl>
    implements _$$LoginDtoImplCopyWith<$Res> {
  __$$LoginDtoImplCopyWithImpl(
    _$LoginDtoImpl _value,
    $Res Function(_$LoginDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginDtoImpl implements _LoginDto {
  const _$LoginDtoImpl({required this.email, required this.password});

  factory _$LoginDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginDto(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      __$$LoginDtoImplCopyWithImpl<_$LoginDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginDtoImplToJson(this);
  }
}

abstract class _LoginDto implements LoginDto {
  const factory _LoginDto({
    required final String email,
    required final String password,
  }) = _$LoginDtoImpl;

  factory _LoginDto.fromJson(Map<String, dynamic> json) =
      _$LoginDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SignupDto _$SignupDtoFromJson(Map<String, dynamic> json) {
  return _SignupDto.fromJson(json);
}

/// @nodoc
mixin _$SignupDto {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this SignupDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignupDtoCopyWith<SignupDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupDtoCopyWith<$Res> {
  factory $SignupDtoCopyWith(SignupDto value, $Res Function(SignupDto) then) =
      _$SignupDtoCopyWithImpl<$Res, SignupDto>;
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class _$SignupDtoCopyWithImpl<$Res, $Val extends SignupDto>
    implements $SignupDtoCopyWith<$Res> {
  _$SignupDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignupDtoImplCopyWith<$Res>
    implements $SignupDtoCopyWith<$Res> {
  factory _$$SignupDtoImplCopyWith(
    _$SignupDtoImpl value,
    $Res Function(_$SignupDtoImpl) then,
  ) = __$$SignupDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class __$$SignupDtoImplCopyWithImpl<$Res>
    extends _$SignupDtoCopyWithImpl<$Res, _$SignupDtoImpl>
    implements _$$SignupDtoImplCopyWith<$Res> {
  __$$SignupDtoImplCopyWithImpl(
    _$SignupDtoImpl _value,
    $Res Function(_$SignupDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _$SignupDtoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SignupDtoImpl implements _SignupDto {
  const _$SignupDtoImpl({
    required this.name,
    required this.email,
    required this.password,
  });

  factory _$SignupDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignupDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'SignupDto(name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  /// Create a copy of SignupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupDtoImplCopyWith<_$SignupDtoImpl> get copyWith =>
      __$$SignupDtoImplCopyWithImpl<_$SignupDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignupDtoImplToJson(this);
  }
}

abstract class _SignupDto implements SignupDto {
  const factory _SignupDto({
    required final String name,
    required final String email,
    required final String password,
  }) = _$SignupDtoImpl;

  factory _SignupDto.fromJson(Map<String, dynamic> json) =
      _$SignupDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get password;

  /// Create a copy of SignupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignupDtoImplCopyWith<_$SignupDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthTokensModel _$AuthTokensModelFromJson(Map<String, dynamic> json) {
  return _AuthTokensModel.fromJson(json);
}

/// @nodoc
mixin _$AuthTokensModel {
  String get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;

  /// Serializes this AuthTokensModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthTokensModelCopyWith<AuthTokensModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthTokensModelCopyWith<$Res> {
  factory $AuthTokensModelCopyWith(
    AuthTokensModel value,
    $Res Function(AuthTokensModel) then,
  ) = _$AuthTokensModelCopyWithImpl<$Res, AuthTokensModel>;
  @useResult
  $Res call({String accessToken, String? refreshToken, UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthTokensModelCopyWithImpl<$Res, $Val extends AuthTokensModel>
    implements $AuthTokensModelCopyWith<$Res> {
  _$AuthTokensModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? user = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthTokensModelImplCopyWith<$Res>
    implements $AuthTokensModelCopyWith<$Res> {
  factory _$$AuthTokensModelImplCopyWith(
    _$AuthTokensModelImpl value,
    $Res Function(_$AuthTokensModelImpl) then,
  ) = __$$AuthTokensModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken, String? refreshToken, UserModel user});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthTokensModelImplCopyWithImpl<$Res>
    extends _$AuthTokensModelCopyWithImpl<$Res, _$AuthTokensModelImpl>
    implements _$$AuthTokensModelImplCopyWith<$Res> {
  __$$AuthTokensModelImplCopyWithImpl(
    _$AuthTokensModelImpl _value,
    $Res Function(_$AuthTokensModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? user = null,
  }) {
    return _then(
      _$AuthTokensModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthTokensModelImpl implements _AuthTokensModel {
  const _$AuthTokensModelImpl({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory _$AuthTokensModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthTokensModelImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String? refreshToken;
  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthTokensModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthTokensModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken, user);

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthTokensModelImplCopyWith<_$AuthTokensModelImpl> get copyWith =>
      __$$AuthTokensModelImplCopyWithImpl<_$AuthTokensModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthTokensModelImplToJson(this);
  }
}

abstract class _AuthTokensModel implements AuthTokensModel {
  const factory _AuthTokensModel({
    required final String accessToken,
    final String? refreshToken,
    required final UserModel user,
  }) = _$AuthTokensModelImpl;

  factory _AuthTokensModel.fromJson(Map<String, dynamic> json) =
      _$AuthTokensModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  String? get refreshToken;
  @override
  UserModel get user;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthTokensModelImplCopyWith<_$AuthTokensModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChangePasswordDto _$ChangePasswordDtoFromJson(Map<String, dynamic> json) {
  return _ChangePasswordDto.fromJson(json);
}

/// @nodoc
mixin _$ChangePasswordDto {
  String get currentPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this ChangePasswordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangePasswordDtoCopyWith<ChangePasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordDtoCopyWith<$Res> {
  factory $ChangePasswordDtoCopyWith(
    ChangePasswordDto value,
    $Res Function(ChangePasswordDto) then,
  ) = _$ChangePasswordDtoCopyWithImpl<$Res, ChangePasswordDto>;
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class _$ChangePasswordDtoCopyWithImpl<$Res, $Val extends ChangePasswordDto>
    implements $ChangePasswordDtoCopyWith<$Res> {
  _$ChangePasswordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentPassword = null, Object? newPassword = null}) {
    return _then(
      _value.copyWith(
            currentPassword: null == currentPassword
                ? _value.currentPassword
                : currentPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            newPassword: null == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChangePasswordDtoImplCopyWith<$Res>
    implements $ChangePasswordDtoCopyWith<$Res> {
  factory _$$ChangePasswordDtoImplCopyWith(
    _$ChangePasswordDtoImpl value,
    $Res Function(_$ChangePasswordDtoImpl) then,
  ) = __$$ChangePasswordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class __$$ChangePasswordDtoImplCopyWithImpl<$Res>
    extends _$ChangePasswordDtoCopyWithImpl<$Res, _$ChangePasswordDtoImpl>
    implements _$$ChangePasswordDtoImplCopyWith<$Res> {
  __$$ChangePasswordDtoImplCopyWithImpl(
    _$ChangePasswordDtoImpl _value,
    $Res Function(_$ChangePasswordDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChangePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentPassword = null, Object? newPassword = null}) {
    return _then(
      _$ChangePasswordDtoImpl(
        currentPassword: null == currentPassword
            ? _value.currentPassword
            : currentPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangePasswordDtoImpl implements _ChangePasswordDto {
  const _$ChangePasswordDtoImpl({
    required this.currentPassword,
    required this.newPassword,
  });

  factory _$ChangePasswordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangePasswordDtoImplFromJson(json);

  @override
  final String currentPassword;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'ChangePasswordDto(currentPassword: $currentPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordDtoImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPassword, newPassword);

  /// Create a copy of ChangePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordDtoImplCopyWith<_$ChangePasswordDtoImpl> get copyWith =>
      __$$ChangePasswordDtoImplCopyWithImpl<_$ChangePasswordDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangePasswordDtoImplToJson(this);
  }
}

abstract class _ChangePasswordDto implements ChangePasswordDto {
  const factory _ChangePasswordDto({
    required final String currentPassword,
    required final String newPassword,
  }) = _$ChangePasswordDtoImpl;

  factory _ChangePasswordDto.fromJson(Map<String, dynamic> json) =
      _$ChangePasswordDtoImpl.fromJson;

  @override
  String get currentPassword;
  @override
  String get newPassword;

  /// Create a copy of ChangePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePasswordDtoImplCopyWith<_$ChangePasswordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
