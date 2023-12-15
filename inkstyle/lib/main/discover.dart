import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'state.dart';


class DiscoverPage extends StatefulWidget {
    const DiscoverPage({super.key}); 

    @override
        State<DiscoverPage> createState() => _DiscoverPageState();
}


class _DiscoverPageState extends State<DiscoverPage> {

    @override
        Widget build(BuildContext context) {
            return Consumer<AppState>(
                builder: (context, appState, _) {
                    return FutureBuilder(
                        future: appState.fetchImages(),
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text("Snapshot is waiting");
                            } else if (snapshot.hasError) {
                                return Text('An unexpected error occurred: ${snapshot.error.toString()}');
                            } else if (appState.isObserving) {
                                    // Observation code
                                    appState.resetIndex();
                                    print("Building DiscoverPage.");
                                    print("appState.tattoos.length: ${appState.tattoos.length}");
                                    print("appState.imageIndex: ${appState.imageIndex}");
                                    return CupertinoPageScaffold(
                                        child: Center(
                                            child: CardSwiper(
                                                        cardsCount: appState.tattoos.length,
                                                        numberOfCardsDisplayed: appState.tattoos.length,
                                                        backCardOffset: const Offset(0.0, 0.0),
                                                        onSwipe: (oldIndex, currentIndex, direction) {
                                                            appState.setImageIndex(currentIndex);
                                                            return true;
                                                        },
                                                        cardBuilder: (_, index, percentThresholdX, percentThresholdY) {
                                                        return Column(
                                                                children : <Widget>[
                                                                const SizedBox(height: 50.0),
                                                                Container(
                                                                    width: 400,
                                                                    height: 500,
                                                                    child: Card(
                                                                        elevation: 10.0,
                                                                        surfaceTintColor: Colors.white,
                                                                        clipBehavior: Clip.antiAlias,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: 'https://bnuakobfluardglvfltt.supabase.co'
                                                                            '/storage/v1/object/public/images/images'
                                                                            '/${appState.tattoos[index].imageUrl}',
                                                                            fit: BoxFit.cover,
                                                                            placeholder: (context, url) => const CupertinoActivityIndicator(),
                                                                            errorWidget: (context, url, error) => Column(
                                                                                children: <Widget>[
                                                                                const Icon(CupertinoIcons.clear_fill),
                                                                                Text('An unexpected error ocurred: ${error.toString()}'),
                                                                                ],
                                                                                ),
                                                                            ),
                                                                        )
                                                                        )
                                                                        ]
                                                                        );
                                                        }
                                                        ),
                                                            ),
                                                            );
                            } else {
                                // Implement Updating screen 
                                return const Center(child: Text("Updating Algorithm"));
                            }

                },
            );
        }
        );
    }
}
