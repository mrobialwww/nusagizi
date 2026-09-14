import 'package:equatable/equatable.dart';

class MidnightSyncEntity extends Equatable {
  final String? lastGenerateDate; // format "YYYY-MM-DD"
  const MidnightSyncEntity({this.lastGenerateDate});

  @override
  List<Object?> get props => [lastGenerateDate];
}
