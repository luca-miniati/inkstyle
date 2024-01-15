import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main/main.dart';
import './auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = _supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator());
  }
}
