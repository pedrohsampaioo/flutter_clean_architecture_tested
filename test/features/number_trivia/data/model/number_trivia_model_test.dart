import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final testNumber = 1;
  final testText = 'Test text';
  final numberTriviaModelTest = NumberTriviaModel(
    number: testNumber,
    text: testText,
  );

  test('check if number trivia model is subclass of number trivia entity', () {
    expect(numberTriviaModelTest, isA<NumberTriviaEntity>());
  });

  group('fromJson', () {
    test('when the number comes as an integer', () {
      final jsonMap = json.decode(fixture('number_trivia_integer.json'))
          as Map<String, dynamic>;
      final result = NumberTriviaModel.fromJson(jsonMap);
      final expected = numberTriviaModelTest;
      expect(result, expected);
    });
    test('when the number comes as an double', () {
      final jsonMap = json.decode(fixture('number_trivia_double.json'))
          as Map<String, dynamic>;
      final result = NumberTriviaModel.fromJson(jsonMap);
      final expected = numberTriviaModelTest;
      expect(result, expected);
    });
    test('when when the text comes null', () {
      final jsonMap = json.decode(fixture('number_trivia_text_null.json'))
          as Map<String, dynamic>;
      final result = NumberTriviaModel.fromJson(jsonMap);
      final expected = NumberTriviaModel(
        text: '$testNumber is an unremarkable number.',
        number: testNumber,
      );
      expect(result, expected);
    });
  });

  test('toJson', () {
    final jsonMap = numberTriviaModelTest.toJson();
    final expected = <String, dynamic>{
      'number': testNumber,
      'text': testText,
    };
    expect(jsonMap, expected);
  });
}
