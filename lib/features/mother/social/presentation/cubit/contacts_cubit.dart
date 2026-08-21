import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_contacts_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/delete_contact_usecase.dart';
import 'contacts_state.dart';
export 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final DeleteContactUseCase deleteContactUseCase;

  ContactsCubit({
    required this.getContactsUseCase,
    required this.deleteContactUseCase,
  }) : super(ContactsInitial());

  Future<void> fetchContacts() async {
    emit(ContactsLoading());
    final result = await getContactsUseCase();
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );
  }

  Future<void> deleteContact(String contactId) async {
    emit(ContactsDeleteLoading(contactId));
    final result = await deleteContactUseCase(contactId);
    result.fold((failure) => emit(ContactsDeleteError(failure.message)), (_) {
      emit(ContactsDeleteSuccess());
      fetchContacts(); // Automatically reload
    });
  }
}
