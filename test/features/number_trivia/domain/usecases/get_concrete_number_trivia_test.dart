import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class NumberTriviaRepositoryMock extends Mock
    implements NumberTriviaRepository {}

main() {
  GetConcreteNumberTrivia usecase;
  NumberTriviaRepositoryMock repository;

  setUp(() {
    repository = NumberTriviaRepositoryMock();
    usecase = GetConcreteNumberTrivia(repository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTriviaEntity(
    text: 'test text',
    number: testNumber,
  );
  test('Must return a valid number trivia entity', () async {
    when(repository.getConcreteNumberTrivia(any)).thenAnswer(
      (_) async => right(testNumberTrivia),
    );

    final result = await usecase(Params(number: testNumber));

    expect(result, right(testNumberTrivia));
    verify(repository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(repository);
  });
}
