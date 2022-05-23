import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hik_up/pages/LoginPage.dart';

void main() {
  testWidgets('Test LoginPage', (tester) async {
    // --- Build LoginPage widget ---
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // --- Test TextFields ---

    // Test invalid email input
    await tester.enterText(find.byKey(const Key('emailKey')), 'Hello World !');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), '@world.');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), '@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), '@.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailKey')), 'hello.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test invalid password input
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test invalid input
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test valid input
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
  });
}
