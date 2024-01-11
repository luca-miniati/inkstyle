import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main/main.dart';
import './login.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback toggleAuthType;
  final bool Function(String) isValidEmail;
  final bool Function(dynamic) isValidPassword;

  const RegisterPage(
      {Key? key,
      required this.toggleAuthType,
      required this.isValidEmail,
      required this.isValidPassword})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final supabase = Supabase.instance.client;
  String _email = '';
  List<String> _password = ['', ''];
  List<bool> _hidePassword = [true, true];
  bool _emailError = false;
  bool _passwordError = false;
  bool _passwordMatchError = false;

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
                  _emailError = false;
                });
              }
            },
            onEditingComplete: () {
              if (!widget.isValidEmail(_email)) {
                setState(() {
                  _emailError = true;
                });
              }
            },
          ),
          if (_emailError)
            Padding(
                child: Text('Provide a valid email.',
                    style: TextStyle(color: Colors.red[500])),
                padding: EdgeInsets.only(top: 6.0)),
          SizedBox(height: 14.0),
          CupertinoTextField(
              placeholder: 'Password',
              prefix: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.lock_fill)),
              suffix: IconButton(
                  icon: Icon(_hidePassword[0]
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill),
                  onPressed: () {
                    setState(() {
                      _hidePassword[0] = !_hidePassword[0];
                    });
                  }),
              padding: EdgeInsets.all(12.0),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _hidePassword[0],
              onChanged: (input) {
                setState(() {
                  _password[0] = input;
                });
                if (widget.isValidPassword(_password)) {
                  setState(() {
                    _passwordError = false;
                  });
                }
                if (_password[0] == _password[1]) {
                  setState(() {
                    _passwordMatchError = false;
                  });
                }
              }),
          SizedBox(height: 14.0),
          CupertinoTextField(
              placeholder: 'Confirm Password',
              prefix: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.lock_fill),
              ),
              suffix: IconButton(
                  icon: Icon(_hidePassword[1]
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill),
                  onPressed: () {
                    setState(() {
                      _hidePassword[1] = !_hidePassword[1];
                    });
                  }),
              padding: EdgeInsets.all(12.0),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _hidePassword[1],
              onChanged: (input) {
                setState(() {
                  _password[1] = input;
                });
                if (widget.isValidPassword(_password)) {
                  setState(() {
                    _passwordError = false;
                  });
                }
                if (_password[0] == _password[1]) {
                  setState(() {
                    _passwordMatchError = false;
                  });
                }
              }),
          if (_passwordError)
            Padding(
                child: Text('Password must be > 8 characters.',
                    style: TextStyle(color: Colors.red[500])),
                padding: EdgeInsets.only(top: 6.0)),
          if (_passwordMatchError)
            Padding(
                child: Text('Passwords must match.',
                    style: TextStyle(color: Colors.red[500])),
                padding: EdgeInsets.only(top: 6.0)),
          SizedBox(height: 24.0),
          CupertinoButton.filled(
            child: Text('Register'),
            onPressed: () async {
              if (!widget.isValidEmail(_email)) {
                setState(() {
                  _emailError = true;
                });
              }
              if (!widget.isValidPassword(_password[0])) {
                setState(() {
                  _passwordError = true;
                });
              }
              if (_password[0] != _password[1]) {
                setState(() {
                  _passwordMatchError = true;
                });
              }
              if (_emailError || _passwordError || _passwordMatchError) {
                return;
              }

              try {
                final AuthResponse res = await supabase.auth.signUp(
                  email: _email,
                  password: _password[0],
                );

                // if (res.session != null) {
                //     if (accessToken == null || refreshToken == null || expiresAt == null) {
                //         final storage = new FlutterSecureStorage();
                //
                //         await storage.write(key: 'accessToken', value: res.session?.accessToken);
                //         await storage.write(key: 'refreshToken', value: res.session?.refreshToken);
                //         await storage.write(key: 'expiresAt', value: res.session?.expiresAt);
                //
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
                //     }
                // }
              } on AuthException catch (e) {
                if (e.message == 'User already registered') {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Account Error'),
                      content: const Text(
                          'Account with this email already exists. Sign in?'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          child: const Text('Sign in'),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.toggleAuthType();
                          },
                        ),
                      ],
                    ),
                  );
                } else {
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
              }
            },
          ),
          Padding(
              padding: EdgeInsets.all(14.0), child: Divider(endIndent: 14.0)),
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
