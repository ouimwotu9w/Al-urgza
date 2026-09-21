import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/screens/root_shell.dart';
import 'package:al_urjuza/theme/app_theme.dart';

/// الجذر: يبني الثيمات ويطبق اللغة العربية وخط حجم النص.
class AlUrjuzaApp extends StatelessWidget {
  const AlUrjuzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'الأرجوزة',
      debugShowCheckedModeBanner: false,
      // هوية ثابتة: الأزرق الملكي الليلي في الوضعين الفاتح والداكن.
      theme: AppTheme.build(brightness: Brightness.light),
      darkTheme: AppTheme.build(brightness: Brightness.dark),
      themeMode: settings.themeMode,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settings.fontScale),
          ),
          child: child!,
        );
      },
      home: const RootShell(),
    );
  }
}
