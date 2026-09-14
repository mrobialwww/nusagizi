import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/social/domain/entities/contact_entity.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;
  const ContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactsDeleteInitial extends ContactsState {}

class ContactsDeleteLoading extends ContactsState {
  final String contactId;
  const ContactsDeleteLoading(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

class ContactsDeleteSuccess extends ContactsState {}

class ContactsDeleteError extends ContactsState {
  final String message;
  const ContactsDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}
