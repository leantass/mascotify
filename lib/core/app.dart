import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'navigation/main_navigation_screen.dart';

class MascotifyApp extends StatelessWidget {
  const MascotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mascotify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MainNavigationScreen(),
    );
  }
}
