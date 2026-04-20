import 'package:flutter/services.dart' show rootBundle;
import '../../core/utils/turkish_case.dart';

class DictionaryService {
  DictionaryService._(this._words);

  final Set<String> _words;
  static DictionaryService? _instance;

  static Future<DictionaryService> load({
    String assetPath = 'assets/data/words.txt',
  }) async {
    if (_instance != null) return _instance!;
    final raw = await rootBundle.loadString(assetPath);
    final set = <String>{};
    for (final line in raw.split('\n')) {
      final normalized = TurkishCase.normalize(line);
      if (normalized.length >= 2) set.add(normalized);
    }
    _instance = DictionaryService._(set);
    return _instance!;
  }

  bool contains(String word) =>
      _words.contains(TurkishCase.normalize(word));

  int get wordCount => _words.length;
}
