// AUTH FEATURE - DOMAIN LAYER
// Entity: objek murni tanpa dependency framework
class UserEntity {
  final String id;
  final String name;
  final String email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}
