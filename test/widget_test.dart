import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/app.dart';

void main() {
  testWidgets('Uygulama acildiginda MaterialApp render edilir',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WordCrushApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
