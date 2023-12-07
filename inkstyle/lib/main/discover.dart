import 'package:flutter/cupertino.dart';


class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Discover'),
      ),
      child: Center(
        child: Text('Discover Page'),
      ),
    );
  }
}
