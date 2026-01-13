import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:vendor/auth/role_selection_screen.dart';

import 'package:vendor/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
