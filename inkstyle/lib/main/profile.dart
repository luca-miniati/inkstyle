import 'package:flutter/cupertino.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
