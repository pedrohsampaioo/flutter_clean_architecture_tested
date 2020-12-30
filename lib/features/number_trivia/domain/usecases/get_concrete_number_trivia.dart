import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository _repository;

  const GetConcreteNumberTrivia(this._repository) : assert(_repository != null);

  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return _repository.getConcreteNumberTrivia(params.number);
  }
}

class Params {
  final int number;
  const Params({@required this.number}) : assert(number != null);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Params && o.number == number;
  }

  @override
  int get hashCode => number.hashCode;

  @override
  String toString() => 'Params(number: $number)';
}
