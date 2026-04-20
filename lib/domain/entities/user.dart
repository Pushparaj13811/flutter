class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String role;
  final bool isVerified;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role = 'user',
    this.isVerified = false,
    this.isActive = true,
  });

  bool get isAdmin => role == 'admin';
}
