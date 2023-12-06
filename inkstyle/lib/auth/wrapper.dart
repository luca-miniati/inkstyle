import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'register.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState(); 
}


class _AuthPageState extends State<AuthPage> {
  int _authType = 0;

  void toggleAuthType() {
    setState(() {
      _authType = 1 - _authType;
    });
  }

  bool isValidEmail(input) {
    RegExp validEmailExp = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return validEmailExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Inkstyle'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _authType == 1
            ? LoginPage(toggleAuthType: toggleAuthType)
            : RegisterPage(toggleAuthType: toggleAuthType, isValidEmail: isValidEmail),
          ),
        )
      )
    );
  }
}

