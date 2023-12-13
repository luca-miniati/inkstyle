import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';


class DiscoverPage extends StatefulWidget {
    const DiscoverPage({super.key}); 

    @override
        State<DiscoverPage> createState() => _DiscoverPageState();
}


class _DiscoverPageState extends State<DiscoverPage> {
    final SupabaseClient _supabase = Supabase.instance.client;
    int _chunkIdx = 0;
    int _batchIdx = 1;
    final int _batchSize = 10;
    final int _chunkSize = 50;
    final int _chunkThresh = 40;

    Future<List<FileObject>> _getImageFileNames(int chunkSize, int chunkIdx) async {
        List<FileObject> fns = await _supabase.storage
            .from('images')
            .list(
                    path: 'images',
                    searchOptions: SearchOptions(
                        limit: chunkSize,
                        offset: chunkIdx * chunkSize
                        )
                 );
        return fns;
    }

    void _precacheImages(List<FileObject> filenames) {
        for (final filename in filenames) {
            precacheImage(
                    NetworkImage(
                        'https://bnuakobfluardglvfltt.supabase.co'
                        '/storage/v1/object/public/images/images'
                        '/${filename.name}'
                        ),
                    context
                    );
        }
        return;
    }

    Future<List<dynamic>> _getData(int chunkSize, int chunkIdx) async {
        final List<FileObject> filenames = await _getImageFileNames(chunkSize, chunkIdx);
        // Initial precache
        _precacheImages(filenames.sublist(0, _batchSize));
        return filenames;
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                    child: Center(
                            child: FutureBuilder<List<dynamic>>(
                                future: _getData(_chunkSize, _chunkIdx),
                                builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CupertinoActivityIndicator();
                                } else if (snapshot.hasError) {
                                return Column(
                                        children: <Widget>[
                                        const Icon(CupertinoIcons.clear_fill),
                                        Text('An unexpected error ocurred: $snapshot.error'),
                                        ],
                                        );
                                } else {
                                List<FileObject> imageFileNames = snapshot.data as List<FileObject>;

                                return CardSwiper(
                                                cardsCount: imageFileNames.length, 
                                                numberOfCardsDisplayed: _batchSize,
                                                backCardOffset: const Offset(0.0, 0.0),
                                                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
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
                                                            '/${imageFileNames[index].name}',
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => const CupertinoActivityIndicator(),
                                                            errorWidget: (context, url, error) => const Column(
                                                                children: <Widget>[
                                                                Icon(CupertinoIcons.clear_fill),
                                                                Text('An unexpected error ocurred.'),
                                                                ],
                                                                ),
                                                            ),
                                                            )
                                                    )
                                                    ]
                                                    );
                                                },
onSwipe: (oldIndex, currentIndex, swipeDirection) {
             if ((currentIndex! % _batchIdx) == 7) {
                 _precacheImages(imageFileNames.sublist(_batchSize * _batchIdx, _batchSize * (_batchIdx + 1)));
                 _batchIdx += 1;
             }
             if (_batchIdx * _batchSize > _chunkThresh) {
                 _batchIdx = 0;
                 _chunkIdx += 1;
             }
             return true;
         },
         );
                                }
                                },
                                ),
                                ),
                                );
        }
}
