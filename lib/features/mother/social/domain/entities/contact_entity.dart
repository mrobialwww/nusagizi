import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String contactId;
  final String relatedMotherProfileId;
  final String fullName;
  final String? photoUrl;

  const ContactEntity({
    required this.contactId,
    required this.relatedMotherProfileId,
    required this.fullName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
    contactId,
    relatedMotherProfileId,
    fullName,
    photoUrl,
  ];
}
