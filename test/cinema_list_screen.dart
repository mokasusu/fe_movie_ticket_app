import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/screens/cinema/cinema_list_screen.dart';

void main() {
  testWidgets('CinemaSearchBar hiển thị TextField và icon search',
          (WidgetTester tester) async {
        final controller = TextEditingController();
        String value = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CinemaSearchBar(
                controller: controller,
                onChanged: (v) => value = v,
              ),
            ),
          ),
        );

        // Có TextField
        expect(find.byType(TextField), findsOneWidget);

        // Có icon search
        expect(find.byIcon(Icons.search), findsOneWidget);

        // Nhập text
        await tester.enterText(find.byType(TextField), 'CGV');
        expect(value, 'CGV');
      });
}
