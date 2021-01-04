import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/exceptions/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

main() {
  SharedPreferencesMock sharedPreferences;
  NumberTriviaLocalDataSourceImpl datasource;

  setUp(() {
    sharedPreferences = SharedPreferencesMock();
    datasource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  group('getLastSaved', () {
    final numberTriviaString = fixture('number_trivia_cached.json');
    final numberTriviaJson =
        jsonDecode(numberTriviaString) as Map<String, dynamic>;
    final numberTriviaModel = NumberTriviaModel.fromJson(numberTriviaJson);

    test('obtains the last number trivia model saved locally', () async {
      when(sharedPreferences.getString(any)).thenReturn(numberTriviaString);
      final result = await datasource.getLastSaved();
      final expected = numberTriviaModel;
      verify(sharedPreferences.getString(cachedNumberTrivia)).called(1);
      expect(result, expected);
    });

    test(
        'a cache exception should be thrown'
        ' when there is no number trivia stored locally', () async {
      when(sharedPreferences.getString(any)).thenReturn(null);
      final call = datasource.getLastSaved;
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('saveLocally', () {
    final numberTriviaString = fixture('number_trivia_cached.json');
    final numberTriviaJson =
        jsonDecode(numberTriviaString) as Map<String, dynamic>;
    final numberTriviaModel = NumberTriviaModel.fromJson(numberTriviaJson);
    test('should make a call to store a number of trivia locally', () async {
      await datasource.saveLocally(numberTriviaModel);
      verify(sharedPreferences.setString(
        cachedNumberTrivia,
        jsonEncode(numberTriviaModel.toJson()),
      )).called(1);
    });
  });
}
