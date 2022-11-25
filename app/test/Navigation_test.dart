import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hik_up/main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  testWidgets('Test Navigation', (tester) async {
    // --- Build App widget ---
    await tester.pumpWidget(const MaterialApp(home: MyApp()));

    await tester.ensureVisible(find.byType(GNav));
    await tester.pumpAndSettle();

    // --- Test NavBar ---

    // Test navigation to Social
    await tester.tap(find.byKey(const Key('socialKey')));
    await tester.pumpAndSettle();
    expect(find.text("SocialPage"), findsWidgets);

    // Test navigation to Map
    await tester.tap(find.byKey(const Key('mapKey')));
    await tester.pumpAndSettle();
    expect(find.text("MapPage"), findsWidgets);

    // Test navigation to Profile
    await tester.tap(find.byKey(const Key('profileKey')));
    await tester.pumpAndSettle();
    expect(find.text("ProfilePage"), findsWidgets);

    // Test navigation to Social
    await tester.tap(find.byKey(const Key('socialKey')));
    await tester.pumpAndSettle();
    expect(find.text("SocialPage"), findsWidgets);

    // Test navigation to Profile
    await tester.tap(find.byKey(const Key('profileKey')));
    await tester.pumpAndSettle();
    expect(find.text("ProfilePage"), findsWidgets);

    // Test navigation to Map
    await tester.tap(find.byKey(const Key('mapKey')));
    await tester.pumpAndSettle();
    expect(find.text("MapPage"), findsWidgets);

    // Test navigation to Profile
    await tester.tap(find.byKey(const Key('profileKey')));
    await tester.pumpAndSettle();
    expect(find.text("ProfilePage"), findsWidgets);

    // Test navigation to Map
    await tester.tap(find.byKey(const Key('mapKey')));
    await tester.pumpAndSettle();
    expect(find.text("MapPage"), findsWidgets);

    // Test navigation to Social
    await tester.tap(find.byKey(const Key('socialKey')));
    await tester.pumpAndSettle();
    expect(find.text("SocialPage"), findsWidgets);

    // Test navigation to Profile
    await tester.tap(find.byKey(const Key('profileKey')));
    await tester.pumpAndSettle();
    expect(find.text("ProfilePage"), findsWidgets);
  });
}
