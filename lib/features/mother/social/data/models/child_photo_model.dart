import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';

class ChildPhotoModel extends ChildPhotoEntity {
  const ChildPhotoModel({
    required super.id,
    super.childId,
    required super.photoUrl,
    super.caption,
    required super.isReviewRequired,
    super.createdAt,
  });

  factory ChildPhotoModel.fromJson(Map<String, dynamic> json) {
    return ChildPhotoModel(
      id: json['id'] as String? ?? '',
      childId: json['child_id'] as String?,
      photoUrl: json['photo_url'] as String? ?? '',
      caption: json['caption'] as String?,
      isReviewRequired: json['is_review_required'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'photo_url': photoUrl,
      'caption': caption,
      'is_review_required': isReviewRequired,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
