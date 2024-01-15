import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'state.dart';
import 'package:provider/provider.dart';
import 'swiper.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
    @override
      void initState() {
        super.initState();
        Future.delayed(Duration.zero, () {
            Provider.of<AppState>(context, listen: false).fetchImages();
        });
      }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, appState, __) {
        if (appState.loading) {
          return const CupertinoPageScaffold(
            child: CupertinoActivityIndicator(),
            );
        } else if (appState.error != "") {
          return CupertinoPageScaffold(
          child: Text('An unexpected error occurred: ${appState.error}'),
          );
        } else if (appState.observing) {
          // Observation code
          // appState.resetIndex();
          return CupertinoPageScaffold(
              child: TattooCardSwiper(appState: appState),
              );
        } else {
          // Implement Updating screen
          return CupertinoPageScaffold(
          child: const Center(child: Text("Updating Algorithm")),
          );
        }
      },
    );
  }
}
