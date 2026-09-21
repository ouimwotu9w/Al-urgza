import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:al_urjuza/app.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';

void main() {
  testWidgets('Al-Urjuza app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
          ChangeNotifierProvider(create: (_) => LibraryProvider(prefs)),
          ChangeNotifierProvider(create: (_) => ProgressProvider(prefs)),
        ],
        child: const AlUrjuzaApp(),
      ),
    );

    await tester.pump();
    expect(find.byType(AlUrjuzaApp), findsOneWidget);
  });
}
