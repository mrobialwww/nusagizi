class ReviewChildPhotoRequestModel {
  final String childId;
  final String childPhotoId;
  final String? caption;
  final String? visibility;
  final List<String>? listVisibility;
  final bool? isReviewRequired;

  const ReviewChildPhotoRequestModel({
    required this.childId,
    required this.childPhotoId,
    this.caption,
    this.visibility,
    this.listVisibility,
    this.isReviewRequired,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (caption != null) data['caption'] = caption;
    if (visibility != null) data['visibility'] = visibility;
    if (listVisibility != null) data['list_visibility'] = listVisibility;
    if (isReviewRequired != null) data['is_review_required'] = isReviewRequired;
    return data;
  }
}
