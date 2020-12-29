import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository _repository;

  const GetRandomNumberTrivia(this._repository) : assert(_repository != null);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) {
    return _repository.getRandomNumberTrivia();
  }
}
