import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/widgets/search/text_search.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'CinemaSearchBar render đúng TextField, icon search và hint mặc định',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CinemaSearchBar(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Tìm tên rạp...'), findsOneWidget);
    },
  );

  testWidgets(
    'CinemaSearchBar hiển thị hint custom khi truyền vào',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CinemaSearchBar(
              controller: controller,
              hint: 'Tìm rạp CGV',
            ),
          ),
        ),
      );

      expect(find.text('Tìm rạp CGV'), findsOneWidget);
    },
  );

  testWidgets(
    'Nhập text → gọi callback onChanged',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      String? query;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CinemaSearchBar(
              controller: controller,
              onChanged: (value) {
                query = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'CGV');
      await tester.pump();

      expect(query, 'CGV');
      expect(controller.text, 'CGV');
    },
  );

  testWidgets(
    'CinemaSearchBar có màu nền và border đúng cấu hình',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CinemaSearchBar(
              controller: controller,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration!;

      expect(decoration.filled, true);
      expect(decoration.prefixIcon, isNotNull);
      expect(decoration.border, isA<OutlineInputBorder>());
    },
  );
}
