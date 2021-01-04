import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/exceptions/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/number_trivia_model.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  const NumberTriviaLocalDataSource();
  Future<NumberTriviaModel> getLastSaved();

  Future<void> saveLocally(NumberTriviaModel numberTrivia);
}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NumberTriviaLocalDataSourceImpl({
    @required this.sharedPreferences,
  }) : assert(sharedPreferences != null);

  @override
  Future<NumberTriviaModel> getLastSaved() {
    final numberTriviaString = sharedPreferences.getString(cachedNumberTrivia);
    if (numberTriviaString != null) {
      final numberTriviaJson = jsonDecode(numberTriviaString);
      final numberTrivia = NumberTriviaModel.fromJson(numberTriviaJson);
      return Future.value(numberTrivia);
    }
    throw CacheException();
  }

  @override
  Future<void> saveLocally(NumberTriviaModel numberTrivia) async {
    final numberTriviaString = jsonEncode(numberTrivia.toJson());
    await sharedPreferences.setString(cachedNumberTrivia, numberTriviaString);
  }
}
