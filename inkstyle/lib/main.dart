import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  Map<String, String> envVars = Platform.environment;

  await Supabase.initialize(
    url: envVars["SUPABASE_URL"],
    anonKey: envVars["SUPABASE_ANON_KEY"],
  );
  
  runApp(const Inkstyle());
}

class Inkstyle extends StatelessWidget {
  const Inkstyle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: const Text(
          'You have pushed the button this many times:',
        ),
      ),
    );
  }
}
