import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/widgets/appBar/seat_appbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'SeatAppBar hiển thị đúng title và icon back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: SeatAppBar(),
            body: SizedBox(),
          ),
        ),
      );

      expect(find.text('Chọn ghế'), findsOneWidget);
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
                    child: const Text('Go to Seat'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SeatScreenMock(),
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

      // Push sang màn Seat
      await tester.tap(find.text('Go to Seat'));
      await tester.pumpAndSettle();

      // Đang ở SeatScreen
      expect(find.text('Seat Screen'), findsOneWidget);

      // Tap nút back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Quay về màn trước
      expect(find.text('Go to Seat'), findsOneWidget);
    },
  );
}

/// Screen giả để test
class SeatScreenMock extends StatelessWidget {
  const SeatScreenMock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SeatAppBar(),
      body: Center(
        child: Text('Seat Screen'),
      ),
    );
  }
}
