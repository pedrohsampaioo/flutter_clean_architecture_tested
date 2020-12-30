import 'package:flutter/foundation.dart';

import '../../domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({
    @required int number,
    @required String text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    final number = (json['number'] as num).toInt();
    final text = json['text'] ?? '$number is an unremarkable number.';
    return NumberTriviaModel(number: number, text: text);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'number': number, 'text': text};
  }
}
