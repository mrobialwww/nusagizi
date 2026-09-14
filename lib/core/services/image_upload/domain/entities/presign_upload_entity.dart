import 'package:equatable/equatable.dart';

class PresignUploadEntity extends Equatable {
  final String uploadUrl;
  final String objectKey;

  const PresignUploadEntity({required this.uploadUrl, required this.objectKey});

  @override
  List<Object?> get props => [uploadUrl, objectKey];
}
