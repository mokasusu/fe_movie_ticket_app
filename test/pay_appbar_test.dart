import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/widgets/appBar/pay_appbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
                    child: const Text('Go to Pay'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PayScreen(),
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

      // Push sang PayScreen
      await tester.tap(find.text('Go to Pay'));
      await tester.pumpAndSettle();

      // Đang ở PayScreen
      expect(find.text('Pay Screen'), findsOneWidget);

      // Tap nút back trên AppBar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Quay về màn trước
      expect(find.text('Go to Pay'), findsOneWidget);
    },
  );
}

/// Screen giả lập để test
class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PayAppBar(),
      body: Center(
        child: Text('Pay Screen'),
      ),
    );
  }
}
