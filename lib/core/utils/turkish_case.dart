class TurkishCase {
  TurkishCase._();

  static const Map<String, String> _toUpper = {
    'a': 'A', 'b': 'B', 'c': 'C', 'ç': 'Ç', 'd': 'D',
    'e': 'E', 'f': 'F', 'g': 'G', 'ğ': 'Ğ', 'h': 'H',
    'ı': 'I', 'i': 'İ', 'j': 'J', 'k': 'K', 'l': 'L',
    'm': 'M', 'n': 'N', 'o': 'O', 'ö': 'Ö', 'p': 'P',
    'r': 'R', 's': 'S', 'ş': 'Ş', 't': 'T', 'u': 'U',
    'ü': 'Ü', 'v': 'V', 'y': 'Y', 'z': 'Z',
  };

  static String toUpperTr(String input) {
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      buffer.write(_toUpper[ch] ?? ch.toUpperCase());
    }
    return buffer.toString();
  }

  static String normalize(String input) =>
      toUpperTr(input.trim()).replaceAll(RegExp(r'[^A-ZÇĞİIÖŞÜ]'), '');
}
