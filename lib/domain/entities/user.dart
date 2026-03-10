class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';
}
