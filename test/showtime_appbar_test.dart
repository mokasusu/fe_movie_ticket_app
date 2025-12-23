import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/widgets/appBar/showtime_appbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'ShowtimeAppBar hiển thị đúng title và icon back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: ShowtimeAppBar(),
            body: SizedBox(),
          ),
        ),
      );

      expect(find.text('Suất chiếu'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    },
  );

  testWidgets(
    'Nhấn nút back → Navigator.pop() quay về màn trước',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    child: const Text('Go to Showtime'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShowtimeScreenMock(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Push sang màn Showtime
      await tester.tap(find.text('Go to Showtime'));
      await tester.pumpAndSettle();

      // Đang ở ShowtimeScreen
      expect(find.text('Showtime Screen'), findsOneWidget);

      // Tap nút back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Quay về màn trước
      expect(find.text('Go to Showtime'), findsOneWidget);
    },
  );
}

/// Screen giả để test
class ShowtimeScreenMock extends StatelessWidget {
  const ShowtimeScreenMock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ShowtimeAppBar(),
      body: Center(
        child: Text('Showtime Screen'),
      ),
    );
  }
}
