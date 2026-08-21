import 'package:equatable/equatable.dart';

class ChildProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String age;
  final String gender;
  final String? photoUrl;

  const ChildProfileEntity({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, fullName, age, gender, photoUrl];
}
