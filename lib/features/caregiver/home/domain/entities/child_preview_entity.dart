import 'package:equatable/equatable.dart';
import 'package:nusagizi/core/utils/date_formatter.dart';

class ChildPreviewEntity extends Equatable {
  final String id;
  final String fullName;
  final String birthDate;
  final String motherName;
  final String? photoUrl;

  const ChildPreviewEntity({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.motherName,
    this.photoUrl,
  });

  /// Calculates age dynamically from [birthDate].
  /// Supported formats: "dd-MM-yyyy" and "yyyy-MM-dd".
  String get ageText {
    try {
      final bdate = AppDateFormatter.parseDate(birthDate);
      return AppDateFormatter.calculateAge(bdate);
    } catch (_) {
      return birthDate;
    }
  }

  @override
  List<Object?> get props => [id, fullName, birthDate, motherName, photoUrl];
}
