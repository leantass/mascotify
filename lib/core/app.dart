import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/auth_placeholder_screen.dart';
import '../theme/app_theme.dart';

class MascotifyApp extends StatelessWidget {
  const MascotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mascotify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthPlaceholderScreen(),
    );
  }
}
