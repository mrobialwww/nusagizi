import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';

abstract class DevelopmentHistoryState {
  const DevelopmentHistoryState();
}

class DevelopmentHistoryInitial extends DevelopmentHistoryState {
  const DevelopmentHistoryInitial();
}

class DevelopmentHistoryLoading extends DevelopmentHistoryState {
  const DevelopmentHistoryLoading();
}

class DevelopmentHistoryLoaded extends DevelopmentHistoryState {
  const DevelopmentHistoryLoaded(this.historyData);

  final List<ChildDevelopmentHistoryEntity> historyData;
}

class DevelopmentHistoryError extends DevelopmentHistoryState {
  const DevelopmentHistoryError(this.message);

  final String message;
}
