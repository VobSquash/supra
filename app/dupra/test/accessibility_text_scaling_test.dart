import 'package:dupra/engine/theme/dupra_theme.dart';
import 'package:dupra/presentation/home/data/home_section_item.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:dupra/presentation/widgets/dupra_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DupraIconRow tolerates large text scale', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.75)),
        child: MaterialApp(
          theme: DupraTheme.dark,
          home: Scaffold(
            body: DupraIconRow(
              icon: Icons.event,
              iconAccentColor: Colors.cyan,
              child: const Text('Title line that may wrap with enlarged system text'),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('DupraSection tolerates large text scale', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.75)),
        child: MaterialApp(
          theme: DupraTheme.dark,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DupraSection(
                title: 'Section',
                items: const [
                  HomeSectionItem(title: 'Item', icon: Icons.star),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
