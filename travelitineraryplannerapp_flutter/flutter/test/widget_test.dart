// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:travel_intinerary_planner_app/main.dart';

void main() {
  testWidgets('Smoke test for main app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TravelItineraryApp());

    // Verify that our app starts and shows the empty state or home screen title.
    expect(find.text('My Trips'), findsOneWidget);
  });
}
