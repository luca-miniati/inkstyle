import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main/main.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback toggleAuthType;
  final bool Function(String) isValidEmail;

  const RegisterPage(
    {Key? key, required this.toggleAuthType, required this.isValidEmail}
  ) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();  
}


class _RegisterPageState extends State<RegisterPage> {
  final supabase = Supabase.instance.client;
  String _email = '';
  List<String> _password = ['', ''];
  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
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
            onEditingComplete: () {
              if (!widget.isValidEmail(_email)) {
                setState(() {
                  _showEmailError = true;
                });
              }
            },
          ),
          SizedBox(height: 14.0),
          if (_showEmailError)
          Column(
            children: [
              Container(
                child: Text("Provide a valid email. Or don't; I don't really care."),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
              ),
              SizedBox(height: 14.0),
            ]
          ),
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
                _password[0] = input;
              });
              if (widget.isValidPassword(_password)) {
                setState(() {
                  _showPasswordError = false;
                });
              }
            }
          ),
          SizedBox(height: 14.0),
          CupertinoTextField(
            placeholder: 'Confirm Password',
            prefix: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.lock_fill),
            ),
            padding: EdgeInsets.all(12.0),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (input) {
              setState(() {
                _password[1] = input;
              });
              if (widget.isValidPassword(_password)) {
                setState(() {
                  _showPasswordError = false;
                });
              }
            }
          ),
          SizedBox(height: 24.0),
          CupertinoButton.filled(
            child: Text('Register'),
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
                  password: _password[0],
                );

                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              } on AuthException catch (e) {
                final AuthResponse res = await supabase.auth.signInWithPassword(
                  email: _email,
                  password: _password[0],
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
            padding: EdgeInsets.all(14.0),
            child: Divider(endIndent: 14.0)
          ),
          Text('Already have an account?'),
          SizedBox(height: 24.0),
          CupertinoButton(
            color: CupertinoColors.lightBackgroundGray,
            child: Text('Log in', style: TextStyle(color: Colors.black)),
            onPressed: widget.toggleAuthType,
          )
        ],
      ),
    );
  }
}

