import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/midnight_sync_entity.dart';

class MidnightSyncCubit extends HydratedCubit<MidnightSyncEntity> {
  MidnightSyncCubit() : super(const MidnightSyncEntity());

  String get _today => DateTime.now().toIso8601String().substring(0, 10);
  bool get needsGenerate => state.lastGenerateDate != _today;

  // Mark that generate has been done today
  void markGeneratedToday() {
    emit(MidnightSyncEntity(lastGenerateDate: _today));
  }

  @override
  MidnightSyncEntity? fromJson(Map<String, dynamic> json) =>
      MidnightSyncEntity(lastGenerateDate: json['lastGenerateDate'] as String?);

  @override
  Map<String, dynamic>? toJson(MidnightSyncEntity state) => {
    'lastGenerateDate': state.lastGenerateDate,
  };
}
