import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;
import 'auth/wrapper.dart';

Future<void> main() async {
  Map<String, String> envVars = Platform.environment;

  await Supabase.initialize(
    url: envVars['SUPABASE_URL'] ?? '',
    anonKey: envVars['SUPABASE_ANON_KEY'] ?? '',
  );
  
  runApp(const InkstyleApp());
}

class InkstyleApp extends StatelessWidget {
  const InkstyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Inkstyle',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: const AuthWrapper(),
    );
  }
}

