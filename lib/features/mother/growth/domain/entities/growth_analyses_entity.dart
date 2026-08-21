import 'package:equatable/equatable.dart';

class GrowthDataPoint extends Equatable {
  final double x;
  final double y;

  const GrowthDataPoint({required this.x, required this.y});

  @override
  List<Object?> get props => [x, y];
}

class GrowthAnalysesEntity extends Equatable {
  final List<GrowthDataPoint> dataPoints;
  final String? messageTitle;
  final String? messageDescription;

  const GrowthAnalysesEntity({
    required this.dataPoints,
    this.messageTitle,
    this.messageDescription,
  });

  @override
  List<Object?> get props => [dataPoints, messageTitle, messageDescription];
}
