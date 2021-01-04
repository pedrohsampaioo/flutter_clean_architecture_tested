import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  const NetworkInfo();
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  const NetworkInfoImpl({
    @required this.dataConnectionChecker,
  }) : assert(dataConnectionChecker != null);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
