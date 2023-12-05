import 'package:flutter/cupertino.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();  
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Register'),
      ),
      child: SafeArea(
        child: Padding(
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
              ),
              SizedBox(height: 24.0),
              CupertinoButton.filled(
                child: Text('Register'),
                onPressed: () {
                  // Add your registration logic here
                  // For demonstration purposes, navigate to a new page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

