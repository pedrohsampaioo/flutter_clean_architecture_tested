import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class DataConnectionCheckerMock extends Mock implements DataConnectionChecker {}

main() {
  DataConnectionCheckerMock dataConnectionCheckerMock;
  NetworkInfoImpl networkInfo;

  setUp(() {
    dataConnectionCheckerMock = DataConnectionCheckerMock();
    networkInfo = NetworkInfoImpl(
      dataConnectionChecker: dataConnectionCheckerMock,
    );
  });

  group('network info impl', () {
    test('checking if dataConnectionChecker.hasConnection has been called', () {
      final hasConnectionFuture = Future.value(false);
      when(dataConnectionCheckerMock.hasConnection)
          .thenAnswer((_) => hasConnectionFuture);
      final result = networkInfo.isConnected;
      verify(dataConnectionCheckerMock.hasConnection).called(1);
      expect(result, hasConnectionFuture);
    });
  });
}
