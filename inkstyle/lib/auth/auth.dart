import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _authType = 0;
  final _storage = FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

  void toggleAuthType() {
    setState(() {
      _authType = 1 - _authType;
    });
  }

  bool isValidEmail(input) {
    RegExp validEmailExp = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return validEmailExp.hasMatch(input);
  }

  bool isValidPassword(input) {
    if (input.runtimeType == String) {
      return input.length > 7;
    } else {
      return (input[0].length > 7 &&
          input[1].length > 7 &&
          (input[0].length == input[1].length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _authType == 1
                ? LoginPage(
                    toggleAuthType: toggleAuthType,
                    isValidEmail: isValidEmail,
                    isValidPassword: isValidPassword)
                : RegisterPage(
                    toggleAuthType: toggleAuthType,
                    isValidEmail: isValidEmail,
                    isValidPassword: isValidPassword),
          ),
        )));
    // }
  }
}
