import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_theme.dart';

import 'features/auth/presentation/pages/user_onboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkSphere',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // ThemeMode.system
      home: const UserOnboardPage(),
    );
  }
}

