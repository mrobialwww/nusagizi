class CreateChildPhotoRequestModel {
  final String childId;
  final String url;
  final String caption;
  final String visibility;
  final List<String>? listVisibility;
  final bool isReviewRequired;

  const CreateChildPhotoRequestModel({
    required this.childId,
    required this.url,
    required this.caption,
    required this.visibility,
    this.listVisibility,
    this.isReviewRequired = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'caption': caption,
      'visibility': visibility,
      if (listVisibility != null) 'list_visibility': listVisibility,
      'is_review_required': isReviewRequired,
    };
  }
}
