class CheckinTokenModel {
  final String token;
  final DateTime expiresAt;

  CheckinTokenModel({
    required this.token,
    required this.expiresAt,
  });

  factory CheckinTokenModel.fromJson(Map<String, dynamic> json) {
    return CheckinTokenModel(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
