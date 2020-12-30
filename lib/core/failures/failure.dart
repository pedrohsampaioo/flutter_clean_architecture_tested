import '../exceptions/exception.dart';

abstract class Failure {
  const Failure();

  CommonException get exception;

  @override
  String toString() => 'CommonFailure(exception: $exception)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CommonFailure && o.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;
}

class CommonFailure extends Failure {
  final CommonException exception;

  const CommonFailure({
    this.exception = const CommonException(),
  }) : assert(exception != null);
}

class NetworkFailure extends CommonFailure {
  const NetworkFailure({
    CommonException exception,
  }) : super(exception: exception);
}

class CacheFailure extends CommonFailure {
  const CacheFailure({
    CommonException exception,
  }) : super(exception: exception);
}
