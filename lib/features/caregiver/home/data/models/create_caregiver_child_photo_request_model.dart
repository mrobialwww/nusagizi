class CreateCaregiverChildPhotoRequestModel {
  final String childId;
  final String url;
  final bool isReviewRequired;

  CreateCaregiverChildPhotoRequestModel({
    required this.childId,
    required this.url,
    this.isReviewRequired = true,
  });

  Map<String, dynamic> toJson() {
    return {'url': url, 'is_review_required': isReviewRequired};
  }
}
