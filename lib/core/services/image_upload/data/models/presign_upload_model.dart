import '../../domain/entities/presign_upload_entity.dart';

class PresignUploadModel extends PresignUploadEntity {
  const PresignUploadModel({
    required super.uploadUrl,
    required super.objectKey,
  });

  factory PresignUploadModel.fromJson(Map<String, dynamic> json) =>
      PresignUploadModel(
        uploadUrl: json['upload_url'] as String,
        objectKey: json['object_key'] as String,
      );
}
