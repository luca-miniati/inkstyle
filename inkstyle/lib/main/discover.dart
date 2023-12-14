import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'tattoo_provider.dart';
import 'dart:math';


class DiscoverPage extends StatefulWidget {
    const DiscoverPage({super.key}); 

    @override
        State<DiscoverPage> createState() => _DiscoverPageState();
}


class _DiscoverPageState extends State<DiscoverPage> {
    @override
        Widget build(BuildContext context) {
            return FutureBuilder(
                    future: Provider.of<TattooProvider>(context, listen: false).loadTattoos(),
                    builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                    } else if (snapshot.hasError) {
                    return const Text('An unexpected error occurred.');
                    } else {
                    return CupertinoPageScaffold(
                            child: Center(
                                child: Consumer<TattooProvider>(
                                    builder: (context, tattooProvider, child) {
                                    return CardSwiper(
                                            cardsCount: tattooProvider.tattoos.length,
                                            numberOfCardsDisplayed: min(tattooProvider.batchSize, tattooProvider.tattoos.length),
                                            backCardOffset: const Offset(0.0, 0.0),
                                            onSwipe: (oldIndex, currentIndex, direction) {
                                                if ((currentIndex ?? 0) % 10 == 7) {
                                                    tattooProvider.incrementBatchIdx();
                                                    tattooProvider.loadTattoos();
                                                }
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
                                                                '/${tattooProvider.tattoos[index].imageUrl}',
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
                                    );
                                    },
                        ),
                        ),
                        );
                    }
                    },
                    );
        }
}
