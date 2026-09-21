import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:al_urjuza/app.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LibraryProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ProgressProvider(prefs)),
      ],
      child: const AlUrjuzaApp(),
    ),
  );
}
