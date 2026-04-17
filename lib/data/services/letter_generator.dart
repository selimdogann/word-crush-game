import 'dart:math';
import '../../core/constants/turkish_letters.dart';

class LetterGenerator {
  LetterGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  String next() {
    final roll = _random.nextInt(100);
    final weights = TurkishLetters.frequencyWeights;
    if (roll < weights['high']!) {
      return _pickFrom(TurkishLetters.highFrequency);
    }
    if (roll < weights['high']! + weights['mid']!) {
      return _pickFrom(TurkishLetters.midFrequency);
    }
    return _pickFrom(TurkishLetters.lowFrequency);
  }

  String _pickFrom(List<String> list) => list[_random.nextInt(list.length)];

  List<List<String>> generateGrid(int size) {
    return List.generate(
      size,
      (_) => List.generate(size, (_) => next()),
    );
  }
}
