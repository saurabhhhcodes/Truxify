import 'package:flutter_test/flutter_test.dart';

import 'package:freightfair/app.dart';

void main() {
  testWidgets('shows the FreightFair splash screen', (tester) async {
    await tester.pumpWidget(const FreightFairApp());

    expect(find.text('FreightFair'), findsOneWidget);
    expect(find.text('Freight without middlemen'), findsOneWidget);
  });
}
