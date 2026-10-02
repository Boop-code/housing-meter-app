import 'package:flutter_test/flutter_test.dart';

import 'package:housing_meter_app/main.dart';

void main() {
  testWidgets('Приложение запускается', (WidgetTester tester) async {
    await tester.pumpWidget(const HousingMeterApp());

    expect(find.text('Учёт показаний ЖКХ'), findsOneWidget);
  });
}