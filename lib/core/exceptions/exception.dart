class CommonException implements Exception {
  final String message;
  const CommonException({this.message = 'An unidentified exception occurred'})
      : assert(message != null);

  @override
  String toString() => 'Exception(message: $message)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CommonException && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class NetworkException extends CommonException {
  const NetworkException({
    message = 'An exception occurred when connecting to the internet',
  }) : super(message: message);
}

class CacheException extends CommonException {
  const CacheException({
    message = 'An exception occurred while managing the cache',
  }) : super(message: message);
}
