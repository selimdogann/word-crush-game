import 'package:flutter/services.dart' show rootBundle;
import '../../core/utils/turkish_case.dart';

class DictionaryService {
  DictionaryService._(this._words, this._prefixes);

  final Set<String> _words;
  final Set<String> _prefixes;
  static DictionaryService? _instance;

  static Future<DictionaryService> load({
    String assetPath = 'assets/data/words.txt',
  }) async {
    if (_instance != null) return _instance!;
    final raw = await rootBundle.loadString(assetPath);
    final words = <String>{};
    final prefixes = <String>{};
    for (final line in raw.split('\n')) {
      final normalized = TurkishCase.normalize(line);
      if (normalized.length < 2) continue;
      words.add(normalized);
      for (var i = 1; i <= normalized.length; i++) {
        prefixes.add(normalized.substring(0, i));
      }
    }
    _instance = DictionaryService._(words, prefixes);
    return _instance!;
  }

  bool contains(String word) =>
      _words.contains(TurkishCase.normalize(word));

  bool hasPrefix(String prefix) =>
      _prefixes.contains(TurkishCase.normalize(prefix));

  int get wordCount => _words.length;
}
