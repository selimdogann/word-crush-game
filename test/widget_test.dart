import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_crush_game/app.dart';
import 'package:word_crush_game/data/repositories/user_repository.dart';
import 'package:word_crush_game/data/services/dictionary_service.dart';
import 'package:word_crush_game/data/services/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Kullanici adi yoksa username ekrani acilir',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.getInstance();
    final repo = UserRepository(prefs);
    final dict = await DictionaryService.load();

    await tester.pumpWidget(WordCrushApp(
      userRepository: repo,
      dictionary: dict,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Oyuna Basla'), findsOneWidget);
  });
}
