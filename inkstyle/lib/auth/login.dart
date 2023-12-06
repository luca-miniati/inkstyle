import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main/main.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback toggleAuthType;

  const LoginPage({Key? key, required this.toggleAuthType}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();  
}


class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  String _email = '';
  List<String> _password = ['', ''];
  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoTextField(
            placeholder: 'Email',
            prefix: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.person_solid),
            ),
            padding: EdgeInsets.all(12.0),
            keyboardType: TextInputType.text,
            autofocus: true,
            onChanged: (input) {
              setState(() {
                _email = input;
              });
              if (widget.isValidEmail(_email)) {
                setState(() {
                  _showEmailError = false;
                });
              }
            },
          ),
          SizedBox(height: 16.0),
          CupertinoTextField(
            placeholder: 'Password',
            prefix: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.lock_fill),
            ),
            padding: EdgeInsets.all(12.0),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (input) {
              setState(() {
                _password = input;
              });
              if (widget.isValidPassword(_password)) {
                setState(() {
                  _showPasswordError = false;
                });
              }
            },
          ),
          SizedBox(height: 24.0),
          CupertinoButton(
            child: Text('Log In', style: TextStyle(color: Colors.black)),
            color: CupertinoColors.lightBackgroundGray,
            onPressed: () async {
              if (!widget.isValidEmail(_email)) {
                setState(() {
                  _showEmailError = true;
                });

                return;
              } else if (!widget.isValidPassword(_password)) {
                setState(() {
                  _showPasswordError = true;
                });

                return;
              }

              try {
                final AuthResponse res = await supabase.auth.signUp(
                  email: _email,
                  password: _password,
                );

                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              } on AuthException catch (e) {
                final AuthResponse res = await supabase.auth.signInWithPassword(
                  email: _email,
                  password: _password,
                );

                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Divider(endIndent: 14.0)
          ),
          Text("Don't have an account?"),
          SizedBox(height: 24.0),
          CupertinoButton.filled(
            child: Text('Register'),
            onPressed: widget.toggleAuthType,
          )
        ],
      ),
    );
  }
}

