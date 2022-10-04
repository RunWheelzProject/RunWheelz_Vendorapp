// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/screens/login_page_screen.dart';


void main() {

  Widget createWidgetForTesting({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }
  
  group("LogInPage:", () {
    testWidgets("on page load proceed button inactive", (widgetTester) async {
      await widgetTester.pumpWidget(
          ChangeNotifierProvider(
            child: createWidgetForTesting(child: const LoginScreen()),
              create: (context) => LogInManager()
            )
      );

      expect(!widgetTester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Proceed')).enabled, isTrue);
      await widgetTester.enterText(find.byType(TextField), "7013298534");

      expect(widgetTester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Proceed')).enabled, isFalse);

    });
  });
}
