import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

class ChildHeaderModel extends ChildHeaderEntity {
  const ChildHeaderModel({
    required super.id,
    required super.name,
    required super.age,
    required super.imagePath,
  });

  factory ChildHeaderModel.fromJson(Map<String, dynamic> json) {
    return ChildHeaderModel(
      id: json['id'] ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      age: json['age'] ?? '',
      imagePath:
          json['photo_url'] as String? ?? json['imagePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age, 'imagePath': imagePath};
  }
}
