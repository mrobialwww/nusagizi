import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';

class ChildPreviewModel extends ChildPreviewEntity {
  const ChildPreviewModel({
    required super.id,
    required super.fullName,
    required super.birthDate,
    required super.motherName,
    super.photoUrl,
  });

  factory ChildPreviewModel.fromJson(Map<String, dynamic> json) {
    return ChildPreviewModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      birthDate: json['birth_date'] as String,
      motherName: json['mother_name'] as String,
      photoUrl: json['photo_url'] as String?,
    );
  }
}
