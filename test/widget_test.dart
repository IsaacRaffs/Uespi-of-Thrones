import 'package:flutter_test/flutter_test.dart';
import 'package:uespi_of_thrones/main.dart';

void main() {
  testWidgets('Aplicativo inicia', (WidgetTester tester) async {
    await tester.pumpWidget(const UespiOfThrones());

    expect(find.text('uespi_of_thrones'), findsOneWidget);
  });
}
