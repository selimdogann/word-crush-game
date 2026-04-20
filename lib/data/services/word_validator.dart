import '../../core/constants/app_constants.dart';
import '../../core/constants/turkish_letters.dart';
import '../../core/utils/turkish_case.dart';
import 'dictionary_service.dart';

class WordValidationResult {
  final bool isValid;
  final String reason;
  final int score;
  final String word;

  const WordValidationResult({
    required this.isValid,
    required this.reason,
    required this.score,
    required this.word,
  });
}

class WordValidator {
  WordValidator(this._dictionary);

  final DictionaryService _dictionary;

  WordValidationResult validate(String raw) {
    final word = TurkishCase.normalize(raw);
    if (word.length < AppConstants.minWordLength) {
      return WordValidationResult(
        isValid: false,
        reason: 'En az ${AppConstants.minWordLength} harf gerekli',
        score: 0,
        word: word,
      );
    }
    if (!_dictionary.contains(word)) {
      return WordValidationResult(
        isValid: false,
        reason: 'Sozlukte bulunamadi',
        score: 0,
        word: word,
      );
    }
    return WordValidationResult(
      isValid: true,
      reason: 'Gecerli kelime',
      score: _computeScore(word),
      word: word,
    );
  }

  int _computeScore(String word) {
    var total = 0;
    for (final ch in word.split('')) {
      total += TurkishLetters.pointOf(ch);
    }
    return total;
  }

  List<String> findSubWords(String word) {
    final normalized = TurkishCase.normalize(word);
    final found = <String>{};
    final length = normalized.length;
    for (var i = 0; i < length; i++) {
      for (var j = i + AppConstants.minWordLength; j <= length; j++) {
        if (i == 0 && j == length) continue;
        final sub = normalized.substring(i, j);
        if (_dictionary.contains(sub)) found.add(sub);
      }
    }
    return found.toList();
  }
}
