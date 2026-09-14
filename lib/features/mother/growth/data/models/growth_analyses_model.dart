import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';

class GrowthDataPointModel extends GrowthDataPoint {
  const GrowthDataPointModel({required super.x, required super.y});

  factory GrowthDataPointModel.fromJson(Map<String, dynamic> json) {
    return GrowthDataPointModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

class GrowthAnalysesModel extends GrowthAnalysesEntity {
  const GrowthAnalysesModel({
    required super.dataPoints,
    super.messageTitle,
    super.messageDescription,
  });

  factory GrowthAnalysesModel.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['data_points'] as List<dynamic>;
    final dataPoints = rawPoints
        .map((p) => GrowthDataPointModel.fromJson(p as Map<String, dynamic>))
        .toList();

    final message = json['message'] as Map<String, dynamic>?;

    return GrowthAnalysesModel(
      dataPoints: dataPoints,
      messageTitle: message?['title'] as String?,
      messageDescription: message?['description'] as String?,
    );
  }
}
