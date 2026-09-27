abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

// Digunakan ketika user membatalkan proses (misalnya back dari browser OAuth).
// Tidak menampilkan error — diabaikan di cubit.
class CancelledFailure extends Failure {
  CancelledFailure() : super(message: '');
}
