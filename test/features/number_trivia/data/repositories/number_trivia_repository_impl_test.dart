import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/exceptions/exception.dart';
import 'package:number_trivia/core/failures/failure.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaLocalDataSourceMock extends Mock
    implements NumberTriviaLocalDataSource {}

class NumberTriviaRemoteDataSourceMock extends Mock
    implements NumberTriviaRemoteDataSource {}

class NetworkInfoMock extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepository repository;
  NumberTriviaLocalDataSourceMock numberTriviaLocalDataSource;
  NumberTriviaRemoteDataSourceMock numberTriviaRemoteDataSource;
  NetworkInfoMock networkInfo;

  setUp(() {
    numberTriviaLocalDataSource = NumberTriviaLocalDataSourceMock();
    numberTriviaRemoteDataSource = NumberTriviaRemoteDataSourceMock();
    networkInfo = NetworkInfoMock();
    repository = NumberTriviaRepositoryImpl(
      numberTriviaLocalDataSource: numberTriviaLocalDataSource,
      numberTriviaRemoteDataSource: numberTriviaRemoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('NumberTriviaRepository implementation', () {
    final number = 1;
    final text = 'Test text';
    final numberTriviaModel = NumberTriviaModel(number: number, text: text);
    final NumberTriviaEntity numberTriviaEntity = numberTriviaModel;
    group('getConcreteNumberTrivia', () {
      test('verify that the internet connection check is being called', () {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        repository.getConcreteNumberTrivia(number);
        verify(networkInfo.isConnected).called(1);
      });

      group('when the device is online', () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('must return a remote trivia number', () async {
          when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(number))
              .thenAnswer((_) async => numberTriviaModel);
          final result = await repository.getConcreteNumberTrivia(number);
          final expected = right(numberTriviaEntity);
          verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(number))
              .called(1);
          verify(numberTriviaLocalDataSource.saveLocally(numberTriviaModel))
              .called(1);
          expect(result, expected);
        });

        test('must return a network failure when a network exception occurs',
            () async {
          when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(number))
              .thenThrow(NetworkException());
          final result = await repository.getConcreteNumberTrivia(number);
          final expected = left<Failure, NumberTriviaEntity>(
              NetworkFailure(exception: NetworkException()));
          verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(number))
              .called(1);
          verifyZeroInteractions(numberTriviaLocalDataSource);
          expect(result, equals(expected));
        });
      });

      group('when the device is offline', () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('must return a local trivia number', () async {
          when(numberTriviaLocalDataSource.getLastSaved())
              .thenAnswer((_) async => numberTriviaModel);
          final result = await repository.getConcreteNumberTrivia(number);
          final expected = right(numberTriviaEntity);
          verifyZeroInteractions(numberTriviaRemoteDataSource);
          verify(numberTriviaLocalDataSource.getLastSaved()).called(1);
          expect(result, expected);
        });

        test('must return a cache failure when a cache exception occurs',
            () async {
          when(numberTriviaLocalDataSource.getLastSaved())
              .thenThrow(CacheException());
          final result = await repository.getConcreteNumberTrivia(number);
          final expected = left<Failure, NumberTriviaEntity>(
              CacheFailure(exception: CacheException()));
          verifyZeroInteractions(numberTriviaRemoteDataSource);
          verify(numberTriviaLocalDataSource.getLastSaved()).called(1);
          expect(result, equals(expected));
        });
      });
    });

    group('getRandomNumberTrivia', () {
      test('verify that the internet connection check is being called', () {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        repository.getRandomNumberTrivia();
        verify(networkInfo.isConnected).called(1);
      });

      group('when the device is online', () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('must return a remote trivia number', () async {
          when(numberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          final result = await repository.getRandomNumberTrivia();
          final expected = right(numberTriviaEntity);
          verify(numberTriviaRemoteDataSource.getRandomNumberTrivia())
              .called(1);
          verify(numberTriviaLocalDataSource.saveLocally(numberTriviaModel))
              .called(1);
          expect(result, expected);
        });

        test('must return a network failure when a network exception occurs',
            () async {
          when(numberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(NetworkException());
          final result = await repository.getRandomNumberTrivia();
          final expected = left<Failure, NumberTriviaEntity>(
              NetworkFailure(exception: NetworkException()));
          verify(numberTriviaRemoteDataSource.getRandomNumberTrivia())
              .called(1);
          verifyZeroInteractions(numberTriviaLocalDataSource);
          expect(result, equals(expected));
        });
      });

      group('when the device is offline', () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('must return a local trivia number', () async {
          when(numberTriviaLocalDataSource.getLastSaved())
              .thenAnswer((_) async => numberTriviaModel);
          final result = await repository.getRandomNumberTrivia();
          final expected = right(numberTriviaEntity);
          verifyZeroInteractions(numberTriviaRemoteDataSource);
          verify(numberTriviaLocalDataSource.getLastSaved()).called(1);
          expect(result, expected);
        });

        test('must return a cache failure when a cache exception occurs',
            () async {
          when(numberTriviaLocalDataSource.getLastSaved())
              .thenThrow(CacheException());
          final result = await repository.getRandomNumberTrivia();
          final expected = left<Failure, NumberTriviaEntity>(
              CacheFailure(exception: CacheException()));
          verifyZeroInteractions(numberTriviaRemoteDataSource);
          verify(numberTriviaLocalDataSource.getLastSaved()).called(1);
          expect(result, equals(expected));
        });
      });
    });
  });
}
