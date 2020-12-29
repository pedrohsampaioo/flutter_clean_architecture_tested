import 'package:flutter/foundation.dart';

class NumberTriviaEntity {
  final String text;
  final int number;

  const NumberTriviaEntity({
    @required this.text,
    @required this.number,
  })  : assert(text != null),
        assert(number != null);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NumberTriviaEntity && o.text == text && o.number == number;
  }

  @override
  int get hashCode => text.hashCode ^ number.hashCode;

  @override
  String toString() => 'NumberTriviaEntity(text: $text, number: $number)';
}
