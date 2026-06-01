import '../../domain/entities/child_data.dart';
import 'child_profile_model.dart';
import 'growth_record_model.dart';

class ChildDataModel extends ChildData {
  const ChildDataModel({
    required super.profile,
    required super.latest,
    required super.history,
  });

  factory ChildDataModel.fromJson(Map<String, dynamic> json) {
    return ChildDataModel(
      profile: ChildProfileModel.fromJson(json['profile']),
      latest: GrowthRecordModel.fromJson(json['latest']),
      history: (json['history'] as List)
          .map((item) => GrowthRecordModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': (profile as ChildProfileModel).toJson(),
      'latest': (latest as GrowthRecordModel).toJson(),
      'history': history.map((item) => (item as GrowthRecordModel).toJson()).toList(),
    };
  }
}
