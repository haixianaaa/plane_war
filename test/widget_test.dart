import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('Plane War App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PlaneWarApp());

    expect(find.text('✈ 飞机大战 ✈'), findsOneWidget);
    expect(find.text('开始游戏'), findsOneWidget);
  });
}
