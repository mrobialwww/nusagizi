import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';

// AUTH FEATURE - PRESENTATION LAYER
// Cubit State
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthRegistered extends AuthState {
  const AuthRegistered();
}

/// State sinyal bahwa signup Auth0 + pengiriman OTP sudah berhasil.
/// UI harus navigasi ke layar OTP saat menerima state ini.
///
/// [email] dan [password] disimpan sementara di memori untuk dipakai
/// pada langkah verifikasi OTP dan login definitif. Tidak pernah
/// ditulis ke disk, log, atau ditampilkan di layar.
class AuthOtpPending extends AuthState {
  final String email;

  /// Password hanya di memori — jangan di-log atau tampilkan di UI.
  final String password;

  const AuthOtpPending({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
