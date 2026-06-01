import 'child_profile.dart';
import 'growth_record.dart';

class ChildData {
  final ChildProfile profile;
  final GrowthRecord latest;
  final List<GrowthRecord> history;

  const ChildData({
    required this.profile,
    required this.latest,
    required this.history,
  });
}
