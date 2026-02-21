import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gol/main.dart';

void main() {
  testWidgets('splash, navigation, and game controls work', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Game of Life'), findsOneWidget);
    expect(find.text('Start'), findsNothing);

    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Start'), findsOneWidget);
    expect(find.byIcon(Icons.sports_esports_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Usual Patterns'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Dark Mode'), findsWidgets);
    expect(find.text('Old Green Geek'), findsOneWidget);

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(switchFinder);
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.widget<Switch>(switchFinder).value, isFalse);

    await tester.ensureVisible(find.text('Old Green Geek'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('Old Green Geek'));
    await tester.pump(const Duration(milliseconds: 250));

    await tester.tap(find.byIcon(Icons.sports_esports_rounded));
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
