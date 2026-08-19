import 'package:flutter_test/flutter_test.dart';
import 'package:maalem/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MaalemApp());

    expect(find.text('Get Started'), findsOneWidget);
  });
}
