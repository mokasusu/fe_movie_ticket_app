import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/main.dart';
import 'package:home/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MovieApp - main.dart', () {
    testWidgets('Ứng dụng khởi chạy và hiển thị LoginScreen',
            (WidgetTester tester) async {

          // Act
          await tester.pumpWidget(const MovieApp());
          await tester.pumpAndSettle();

          // Assert
          expect(find.byType(MaterialApp), findsOneWidget);
          expect(find.byType(LoginScreen), findsOneWidget);
        });

    testWidgets('Hiển thị tiêu đề Đăng nhập',
            (WidgetTester tester) async {

          await tester.pumpWidget(const MovieApp());
          await tester.pumpAndSettle();

          final titleFinder = find.byWidgetPredicate(
                (widget) =>
            widget is Text &&
                widget.data != null &&
                widget.data!.contains(' Đăng nhập'),
          );

          expect(titleFinder, findsOneWidget);
        });


    testWidgets('App sử dụng locale Tiếng Việt',
            (WidgetTester tester) async {

          await tester.pumpWidget(const MovieApp());
          await tester.pumpAndSettle();

          final MaterialApp app =
          tester.widget(find.byType(MaterialApp));

          expect(app.locale, const Locale('vi', 'VN'));
        });
  });
}
