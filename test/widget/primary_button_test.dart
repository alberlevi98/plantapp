import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantapp/core/theme/app_theme.dart';
import 'package:plantapp/core/utils/responsive.dart';
import 'package:plantapp/shared/widgets/primary_button.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
        theme: AppTheme.light,
        home: Responsive.builder(child: Scaffold(body: child)),
      );

  testWidgets('renders the label and reports taps', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(PrimaryButton(label: 'Get Started', onPressed: () => taps++)),
    );

    expect(find.text('Get Started'), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton));
    expect(taps, 1);
  });

  testWidgets('shows a spinner and blocks taps while loading',
      (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(PrimaryButton(label: 'Continue', isLoading: true, onPressed: () => taps++)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton));
    expect(taps, 0);
  });
}
