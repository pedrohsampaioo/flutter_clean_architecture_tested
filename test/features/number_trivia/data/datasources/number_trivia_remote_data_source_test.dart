import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/exceptions/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class HttpClientMock extends Mock implements http.Client {}

main() {
  NumberTriviaRemoteDataSourceImpl datasource;
  HttpClientMock httpClient;

  int numberTest;
  String numberTriviaString;

  setUp(() {
    httpClient = HttpClientMock();
    datasource = NumberTriviaRemoteDataSourceImpl(httpClient: httpClient);
    numberTest = 1;
    numberTriviaString = fixture('number_trivia_integer.json');
  });

  setUpSuccessfulApiCall() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(numberTriviaString, 200));
  }

  setUpFailureApiCall() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    test(
        'check that the correct url is being called and '
        'that the query parameters are being passed to receive json', () async {
      setUpSuccessfulApiCall();
      await datasource.getConcreteNumberTrivia(numberTest);
      verify(httpClient.get(
        'http://numbersapi.com/$numberTest',
        headers: <String, String>{'Content-Type': 'application/json'},
      )).called(1);
    });

    test(
        'must return a corresponding number trivia '
        'of the requested number for API', () async {
      setUpSuccessfulApiCall();

      final result = await datasource.getConcreteNumberTrivia(numberTest);

      final expected =
          NumberTriviaModel.fromJson(jsonDecode(numberTriviaString));

      expect(result, expected);
    });

    test('A network exception should be thrown when a server failure occurs',
        () {
      setUpFailureApiCall();

      final call = () => datasource.getConcreteNumberTrivia(numberTest);

      expect(() => call(), throwsA(isA<NetworkException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test(
        'check that the correct url is being called and '
        'that the query parameters are being passed to receive json', () async {
      setUpSuccessfulApiCall();
      await datasource.getRandomNumberTrivia();
      verify(httpClient.get(
        'http://numbersapi.com/random',
        headers: <String, String>{'Content-Type': 'application/json'},
      )).called(1);
    });

    test(
        'must return a corresponding number trivia '
        'of the requested number for API', () async {
      setUpSuccessfulApiCall();

      final result = await datasource.getRandomNumberTrivia();

      final expected =
          NumberTriviaModel.fromJson(jsonDecode(numberTriviaString));

      expect(result, expected);
    });

    test('A network exception should be thrown when a server failure occurs',
        () {
      setUpFailureApiCall();

      final call = () => datasource.getRandomNumberTrivia();

      expect(() => call(), throwsA(isA<NetworkException>()));
    });
  });
}
