import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    int _batchIdx = 1;
    final int _batchSize = 10;

    Future<List<FileObject>> _getImageFileNames() async {
        List<FileObject> fns = await _supabase.storage.from('images').list(path: 'images');
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

    Future<List<dynamic>> _getData() async {
        final List<FileObject> filenames = await _getImageFileNames();
        _precacheImages(filenames.sublist(0, _batchSize));
        return filenames;
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                    child: FutureBuilder<List<dynamic>>(
                        future: _getData(),
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
                        final List<FileObject> imageFileNames = snapshot.data as List<FileObject>;

                        return CardSwiper(
                                cardsCount: imageFileNames.length, 
                                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                return Card(
                                        elevation: 10.0,
                                        child: CachedNetworkImage(
                                            imageUrl: 'https://bnuakobfluardglvfltt.supabase.co'
                                            '/storage/v1/object/public/images/images'
                                            '/${imageFileNames[index].name}',
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => const CupertinoActivityIndicator(),
                                            errorWidget: (context, url, error) => const Column(
                                                    children: <Widget>[
                                                    Icon(CupertinoIcons.clear_fill),
                                                    Text('An unexpected error ocurred.'),
                                                    ],
                                                    ),
                                            ),
                                        );
                                },
                                onSwipe: (oldIndex, currentIndex, swipeDirection) {
                                    if ((currentIndex! % _batchSize) == 7) {
                                        _precacheImages(imageFileNames.sublist(_batchSize * _batchIdx, _batchSize * (_batchIdx + 1)));
                                        _batchIdx += 1;
                                    }
                                    return true;
                                },
                                );
                                }
                        },
                            ),
                                );
                        }
        }
