// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nighttrack_home/app/nighttrack_app.dart';

void main() {
  testWidgets('Landing hero renders', (WidgetTester tester) async {
    await tester.pumpWidget(const NightTrackApp());
    await tester.pumpAndSettle();

    expect(find.text('NightTrack'), findsWidgets);
    expect(find.text('Ready to Own'), findsOneWidget);
    expect(find.text('the After Hours.'), findsOneWidget);
    expect(find.text('Create Organization'), findsOneWidget);
  });
}
