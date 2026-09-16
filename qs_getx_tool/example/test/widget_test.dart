import 'package:flutter_test/flutter_test.dart';
import 'package:qs_getx_tool_example/main.dart';

void main() {
  testWidgets('shows the package example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('qs_getx_tool example'), findsOneWidget);
  });
}
