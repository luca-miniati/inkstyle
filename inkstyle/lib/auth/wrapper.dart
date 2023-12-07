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

  bool isValidPassword(input) {
    bool _isValidPassword(input) {
      if (input.length < 8) return false;

      return true;
    }

    if (input.runtimeType == String) {
      return _isValidPassword(input);
    } else {
      return (_isValidPassword(input[0]) && _isValidPassword(input[1])) && (input[0].length == input[1].length);
    }
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
            ? LoginPage(toggleAuthType: toggleAuthType, isValidEmail: isValidEmail, isValidPassword: isValidPassword)
            : RegisterPage(toggleAuthType: toggleAuthType, isValidEmail: isValidEmail, isValidPassword: isValidPassword),
          ),
        )
      )
    );
  }
}

