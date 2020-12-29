import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaRepositoryMock extends Mock
    implements NumberTriviaRepository {}

main() {
  GetRandomNumberTrivia usecase;
  NumberTriviaRepositoryMock repository;

  setUp(() {
    repository = NumberTriviaRepositoryMock();
    usecase = GetRandomNumberTrivia(repository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTriviaEntity(
    text: 'test text',
    number: testNumber,
  );
  test('Must return a valid number trivia entity', () async {
    when(repository.getRandomNumberTrivia()).thenAnswer(
      (_) async => right(testNumberTrivia),
    );

    final result = await usecase(NoParams());

    expect(result, right(testNumberTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
