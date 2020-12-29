import 'package:dartz/dartz.dart';

import '../failures/failure.dart';

abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
