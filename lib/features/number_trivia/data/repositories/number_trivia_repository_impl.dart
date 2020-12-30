import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/exceptions/exception.dart';
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/number_trivia_entity.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetworkInfo _networkInfo;
  final NumberTriviaLocalDataSource _numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource _numberTriviaRemoteDataSource;

  const NumberTriviaRepositoryImpl({
    @required NetworkInfo networkInfo,
    @required NumberTriviaLocalDataSource numberTriviaLocalDataSource,
    @required NumberTriviaRemoteDataSource numberTriviaRemoteDataSource,
  })  : assert(networkInfo != null),
        assert(numberTriviaLocalDataSource != null),
        assert(numberTriviaRemoteDataSource != null),
        _networkInfo = networkInfo,
        _numberTriviaLocalDataSource = numberTriviaLocalDataSource,
        _numberTriviaRemoteDataSource = numberTriviaRemoteDataSource;

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
    int number,
  ) async {
    return _callForwardedGetNumberTrivia(
      () => _numberTriviaRemoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return _callForwardedGetNumberTrivia(
      _numberTriviaRemoteDataSource.getRandomNumberTrivia,
    );
  }

  Future<Either<Failure, NumberTriviaEntity>> _callForwardedGetNumberTrivia(
    Future<NumberTriviaModel> Function() concreteOrRandomCallback,
  ) async {
    try {
      final isConnectedToInternet = await _networkInfo.isConnected;
      if (isConnectedToInternet) {
        final remoteTrivia = await concreteOrRandomCallback();
        await _numberTriviaLocalDataSource.saveLocally(remoteTrivia);
        return right(remoteTrivia);
      }

      final localTrivia = await _numberTriviaLocalDataSource.getLastSaved();
      return right(localTrivia);
    } on NetworkException catch (exception) {
      return left(NetworkFailure(exception: exception));
    } on CacheException catch (exception) {
      return left(CacheFailure(exception: exception));
    }
  }
}
