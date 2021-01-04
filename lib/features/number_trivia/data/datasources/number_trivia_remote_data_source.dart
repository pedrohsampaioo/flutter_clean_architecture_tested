import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/exceptions/exception.dart';

import '../model/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  const NumberTriviaRemoteDataSourceImpl({
    @required this.httpClient,
  }) : assert(httpClient != null);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return callForwardedToGetNumberTrivia('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return callForwardedToGetNumberTrivia('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> callForwardedToGetNumberTrivia(String url) async {
    final response = await httpClient.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final numberTriviaJson = jsonDecode(response.body);
      final numberTrivia = NumberTriviaModel.fromJson(numberTriviaJson);
      return numberTrivia;
    }
    throw NetworkException();
  }
}
