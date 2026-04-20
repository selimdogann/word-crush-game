import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/data/services/dictionary_service.dart';
import 'package:word_crush_game/data/services/word_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WordValidator validator;

  setUpAll(() async {
    final dict = await DictionaryService.load();
    validator = WordValidator(dict);
  });

  test('Sozlukte bulunan kelime gecerli kabul edilir', () {
    final result = validator.validate('elma');
    expect(result.isValid, isTrue);
    expect(result.word, 'ELMA');
    expect(result.score, greaterThan(0));
  });

  test('3 harften kisa kelime reddedilir', () {
    final result = validator.validate('al');
    expect(result.isValid, isFalse);
    expect(result.reason, contains('3 harf'));
  });

  test('Sozlukte olmayan kelime reddedilir', () {
    final result = validator.validate('xyzqwe');
    expect(result.isValid, isFalse);
    expect(result.reason, contains('Sozlukte'));
  });

  test('Alt kelimeleri bulur', () {
    final subs = validator.findSubWords('KALEM');
    expect(subs, contains('KALE'));
  });
}
