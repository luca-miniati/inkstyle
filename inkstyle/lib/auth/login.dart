import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main/main.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback toggleAuthType;
  final bool Function(String) isValidEmail;
  final bool Function(dynamic) isValidPassword;

  const LoginPage({
    Key? key,
    required this.toggleAuthType,
    required this.isValidEmail,
    required this.isValidPassword,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();  
}


class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  String _email = '';
  String _password = ''; 
  bool _hidePassword = true;
  bool _emailError = false;
  bool _passwordError = false;

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
                  _emailError = false;
                });
              }
            },
          ),
          if (_emailError)
          Padding(
            child: Text(
              'Please provide a valid email.',
              style: TextStyle(color: Colors.red[500])
            ),
            padding: EdgeInsets.only(top: 6.0)
          ),
          SizedBox(height: 16.0),
          CupertinoTextField(
            placeholder: 'Password',
            prefix: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.lock_fill),
            ),
            suffix: IconButton(
              icon: Icon(
                _hidePassword
                ? CupertinoIcons.eye_slash_fill
                : CupertinoIcons.eye_fill
              ),
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              }
            ),
            padding: EdgeInsets.all(12.0),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _hidePassword,
            onChanged: (input) {
              setState(() {
                _password = input;
              });
              if (widget.isValidPassword(_password)) {
                setState(() {
                  _passwordError = false;
                });
              }
            }
          ),
          if (_passwordError)
          Padding(
            child: Text(
              'Password must be > 8 characters.',
              style: TextStyle(color: Colors.red[500])
            ),
            padding: EdgeInsets.only(top: 6.0)
          ),
          SizedBox(height: 24.0),
          CupertinoButton(
            child: Text('Log In', style: TextStyle(color: Colors.black)),
            color: CupertinoColors.lightBackgroundGray,
            onPressed: () async {
              if (!widget.isValidEmail(_email)) {
                setState(() {
                  _emailError = true;
                });
              }
              if (!widget.isValidPassword(_password)) {
                setState(() {
                  _passwordError = true;
                });
              }
              if (_emailError || _passwordError) {
                return;
              }

              try {
                final AuthResponse res = await supabase.auth.signInWithPassword(
                  email: _email,
                  password: _password,
                );

                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              } on AuthException catch (e) {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Account Error'),
                    content: Text(e.message),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
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

