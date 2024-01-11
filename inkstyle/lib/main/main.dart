import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'discover.dart';
import 'home.dart';
import 'profile.dart';
import 'state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (_, appState, __) => CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            currentIndex: appState.navbarIndex,
            onTap: (index) {
              if (index != appState.navbarIndex) {
                appState.setNavbarIndex(index);
              }
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
                return CupertinoTabView(builder: (context) => DiscoverPage());
              case 1:
                return CupertinoTabView(builder: (context) => HomePage());
              case 2:
                return CupertinoTabView(builder: (context) => ProfilePage());
              default:
                return CupertinoTabView(builder: (context) => Container());
            }
          },
        ),
      ),
    );
  }
}
