import '../model/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastSaved();

  Future<void> saveLocally(NumberTriviaModel numberTrivia);
}
