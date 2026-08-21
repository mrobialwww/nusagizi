class UpdateUserProfileRequestModel {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? photoUrl;

  UpdateUserProfileRequestModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fullName != null) map['full_name'] = fullName;
    if (email != null) map['email'] = email;
    if (phoneNumber != null) map['phone_number'] = phoneNumber;
    if (gender != null) map['gender'] = gender;
    if (photoUrl != null) map['photo_url'] = photoUrl;
    return map;
  }
}
