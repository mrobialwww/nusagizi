import 'package:nusagizi/features/mother/social/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.contactId,
    required super.relatedMotherProfileId,
    required super.fullName,
    super.photoUrl,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactId: json['contact_id'] as String? ?? '',
      relatedMotherProfileId:
          json['related_mother_profile_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'related_mother_profile_id': relatedMotherProfileId,
      'full_name': fullName,
      'photo_url': photoUrl,
    };
  }
}
