import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/core/constants/routes/app_route_configuration.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouteConfiguration.route,
    );
  }
}
