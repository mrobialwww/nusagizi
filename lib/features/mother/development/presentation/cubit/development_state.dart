import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';

/// State untuk [DevelopmentCubit].
abstract class DevelopmentState {
  const DevelopmentState();
}

class DevelopmentInitial extends DevelopmentState {
  const DevelopmentInitial();
}

class DevelopmentLoading extends DevelopmentState {
  const DevelopmentLoading();
}

class DevelopmentLoaded extends DevelopmentState {
  const DevelopmentLoaded(this.summary);

  final ChildDevelopmentSummaryEntity? summary;
}

class DevelopmentError extends DevelopmentState {
  const DevelopmentError(this.message);

  final String message;
}
