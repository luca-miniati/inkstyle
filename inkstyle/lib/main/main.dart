import 'package:flutter/cupertino.dart';
import 'discover.dart';
import 'home.dart';
import 'profile.dart';


class MainPage extends StatefulWidget {
    const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => const DiscoverPage());
          case 1:
            return CupertinoTabView(builder: (context) => HomePage());
          case 2:
            return CupertinoTabView(builder: (context) => ProfilePage());
          default:
            return CupertinoTabView(builder: (context) => Container());
        }
      },
    );
  }
}
