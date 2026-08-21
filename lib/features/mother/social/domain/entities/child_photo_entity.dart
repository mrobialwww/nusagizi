import 'package:equatable/equatable.dart';

class ChildPhotoEntity extends Equatable {
  final String id;
  final String? childId;
  final String photoUrl;
  final String? caption;
  final bool isReviewRequired;
  final DateTime? createdAt;

  const ChildPhotoEntity({
    required this.id,
    this.childId,
    required this.photoUrl,
    this.caption,
    required this.isReviewRequired,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    childId,
    photoUrl,
    caption,
    isReviewRequired,
    createdAt,
  ];
}
