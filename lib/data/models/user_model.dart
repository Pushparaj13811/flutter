class UserModel {
  final String? mongoId;
  final String? id;
  final String email;
  final String name;
  final String? avatar;
  final String role;
  final bool isVerified;
  final bool isActive;
  final String? lastLogin;

  const UserModel({
    this.mongoId,
    this.id,
    this.email = '',
    this.name = '',
    this.avatar,
    this.role = 'user',
    this.isVerified = false,
    this.isActive = true,
    this.lastLogin,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      mongoId: map['_id'] as String?,
      id: map['id'] as String?,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String?,
      role: map['role'] as String? ?? 'user',
      isVerified: map['isVerified'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      lastLogin: map['lastLogin'] as String?,
    );
  }

  /// Legacy compatibility alias
  factory UserModel.fromJson(Map<String, dynamic> json) = UserModel.fromMap;

  Map<String, dynamic> toMap() => {
        '_id': mongoId,
        'id': id,
        'email': email,
        'name': name,
        'avatar': avatar,
        'role': role,
        'isVerified': isVerified,
        'isActive': isActive,
        'lastLogin': lastLogin,
      };

  UserModel copyWith({
    String? mongoId,
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? role,
    bool? isVerified,
    bool? isActive,
    String? lastLogin,
  }) {
    return UserModel(
      mongoId: mongoId ?? this.mongoId,
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
