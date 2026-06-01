// AUTH FEATURE - DOMAIN LAYER
// Entity: objek murni tanpa dependency framework
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String role;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });
}
