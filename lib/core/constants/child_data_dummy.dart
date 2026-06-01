import 'package:nusagizi/core/domain/entities/child_data.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';

final List<ChildData> dummyDataList = [
  ChildData(
    profile: ChildProfile(
      name: 'Muhammad Razky',
      birthDate: DateTime(2024, 2, 3),
    ),
    latest: GrowthRecord(
      date: DateTime(2026, 5, 5),
      weight: 12.4,
      height: 89.0,
      headCircumference: 47.0,
    ),
    history: [
      GrowthRecord(
        date: DateTime(2024, 2, 3),
        weight: 3.2,
        height: 50.0,
        headCircumference: 34.0,
      ),
      GrowthRecord(
        date: DateTime(2024, 5, 3),
        weight: 6.1,
        height: 61.0,
        headCircumference: 40.0,
      ),
      GrowthRecord(
        date: DateTime(2024, 8, 3),
        weight: 7.8,
        height: 67.0,
        headCircumference: 43.0,
      ),
      GrowthRecord(
        date: DateTime(2024, 11, 3),
        weight: 9.2,
        height: 72.0,
        headCircumference: 44.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 2, 3),
        weight: 10.1,
        height: 75.0,
        headCircumference: 45.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 5, 3),
        weight: 10.8,
        height: 79.0,
        headCircumference: 46.0,
      ),
      GrowthRecord(
        date: DateTime(2025, 8, 3),
        weight: 11.3,
        height: 82.0,
        headCircumference: 46.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 11, 3),
        weight: 11.8,
        height: 86.0,
        headCircumference: 46.8,
      ),
      GrowthRecord(
        date: DateTime(2026, 2, 3),
        weight: 12.1,
        height: 87.5,
        headCircumference: 47.0,
      ),
      GrowthRecord(
        date: DateTime(2026, 5, 5),
        weight: 12.4,
        height: 89.0,
        headCircumference: 47.0,
      ),
    ],
  ),
  ChildData(
    profile: ChildProfile(name: 'Yuli', birthDate: DateTime(2024, 2, 3)),
    latest: GrowthRecord(
      date: DateTime(2026, 5, 5),
      weight: 11.2,
      height: 85.0,
      headCircumference: 45.0,
    ),
    history: [
      GrowthRecord(
        date: DateTime(2024, 2, 3),
        weight: 3.0,
        height: 49.0,
        headCircumference: 33.5,
      ),
      GrowthRecord(
        date: DateTime(2024, 5, 3),
        weight: 5.8,
        height: 60.0,
        headCircumference: 39.0,
      ),
      GrowthRecord(
        date: DateTime(2024, 8, 3),
        weight: 7.5,
        height: 65.0,
        headCircumference: 42.0,
      ),
      GrowthRecord(
        date: DateTime(2024, 11, 3),
        weight: 8.8,
        height: 70.0,
        headCircumference: 43.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 2, 3),
        weight: 9.7,
        height: 74.0,
        headCircumference: 44.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 5, 3),
        weight: 10.4,
        height: 77.0,
        headCircumference: 45.0,
      ),
      GrowthRecord(
        date: DateTime(2025, 8, 3),
        weight: 10.8,
        height: 80.0,
        headCircumference: 45.5,
      ),
      GrowthRecord(
        date: DateTime(2025, 11, 3),
        weight: 11.1,
        height: 83.0,
        headCircumference: 45.8,
      ),
      GrowthRecord(
        date: DateTime(2026, 2, 3),
        weight: 11.0,
        height: 84.5,
        headCircumference: 45.0,
      ),
      GrowthRecord(
        date: DateTime(2026, 5, 5),
        weight: 11.2,
        height: 85.0,
        headCircumference: 45.0,
      ),
    ],
  ),
];
