import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_all_notifications_usecase.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;

  NotificationCubit({required this.getAllNotificationsUseCase})
    : super(NotificationInitial());

  Future<void> getAllNotifications() async {
    emit(NotificationLoading());
    final result = await getAllNotificationsUseCase();

    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }
}
