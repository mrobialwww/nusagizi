import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_all_notifications_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_notification_state.dart';

class CaregiverNotificationCubit extends Cubit<CaregiverNotificationState> {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;

  CaregiverNotificationCubit({required this.getAllNotificationsUseCase})
    : super(CaregiverNotificationInitial());

  Future<void> getAllNotifications() async {
    emit(CaregiverNotificationLoading());
    final result = await getAllNotificationsUseCase();

    result.fold(
      (failure) => emit(CaregiverNotificationError(message: failure.message)),
      (notifications) =>
          emit(CaregiverNotificationLoaded(notifications: notifications)),
    );
  }
}
