import 'package:flutter/cupertino.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          children: [
            CupertinoButton(
              child: const Text("Log in")
            ),
            CupertinoButton(
              child: const Text("Register")
            ),
          ] 
        ) 
      ),
    );
  }
}

