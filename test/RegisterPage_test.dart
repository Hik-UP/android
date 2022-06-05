import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hik_up/pages/RegisterPage.dart';

void main() {
  testWidgets('Test RegisterPage', (tester) async {
    // --- Build RegisterPage widget ---
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // --- Test TextFields ---

    // Test invalid username input
    await tester.enterText(find.byKey(const Key('usernameKey')), 'Hello');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld.');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld_');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'Hello@World');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), '_HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), '.HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'Hello_.World');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorldHelloWorldHelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test invalid email input
    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'Hello World !');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), '@world.');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), '@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), '@.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test invalid password input
    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test invalid input
        await tester.enterText(find.byKey(const Key('usernameKey')), 'Hello');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test valid input
    await tester.enterText(find.byKey(const Key('usernameKey')), 'HelloWorld');
    await tester.enterText(find.byKey(const Key('emailKey')), 'hello@world.com');
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Hello World !');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Test navigation to LoginPage
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text("Login"), findsWidgets);
  });
}
