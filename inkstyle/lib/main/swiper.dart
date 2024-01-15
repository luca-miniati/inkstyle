import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'widgets.dart';

class TattooCardSwiper extends StatefulWidget {
  final AppState appState;

  TattooCardSwiper({required this.appState});

  @override
  _TattooCardSwiperState createState() => _TattooCardSwiperState();
}

class _TattooCardSwiperState extends State<TattooCardSwiper> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
        children: <Widget>[
          const SizedBox(height: 600),
          Center(
            child: Card(
                elevation: -0.0,
                surfaceTintColor: Colors.white,
                child: Decisions(
                  decisionIndicatorWidth: 25.0,
                  decisionIndicatorBorderRadius: 4.0,
                  spacerWidth: 25.0 * 0.20,
                ),
              ),
          ),
        ],
        ),
        Container(
          height: 600.0,
          child: Consumer<AppState> (
          builder: (_, appState, __) => CardSwiper(
            isLoop: false,
            cardsCount: appState.batchSize,
            numberOfCardsDisplayed: widget.appState.cardsDisplayed,
            backCardOffset: const Offset(0.0, 0.0),
            onSwipe: (oldIndex, currentIndex, direction) {
              bool liked;
              if (direction == CardSwiperDirection.left) {
                liked = false;
              } else if (direction == CardSwiperDirection.right) {
                liked = true;
              } else {
                liked = true;
              }
              appState.setDecision(liked);
              appState.incrementImageIndex();
              return true;
            },
            cardBuilder: (_, index, __, ___) {
              return Column(
                children: <Widget>[
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
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Column(
                          children: <Widget>[
                            const Icon(CupertinoIcons.clear_fill),
                            Text(
                                'An unexpected error ocurred: ${error.toString()}',
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          ),
        ),
      ],
    );
  }
}
