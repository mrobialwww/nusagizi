import 'package:equatable/equatable.dart';

class ChildHeaderEntity extends Equatable {
  final String id;
  final String name;
  final String age;
  final String imagePath;

  const ChildHeaderEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, age, imagePath];
}
