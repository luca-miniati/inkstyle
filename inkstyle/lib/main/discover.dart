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
    final int _imageIdx = 1;
    final int _precacheOffset = 10;

    Future<List<FileObject>> _getImageFileNames() async {
        List<FileObject> fns = await _supabase.storage.from('images').list(path: 'images');
        return fns;
    }

    void _precacheImages(List<FileObject> filenames) {
        for (final _filename in filenames) {
            precacheImage(
                    NetworkImage(
                        'https://bnuakobfluardglvfltt.supabase.co'
                        '/storage/v1/object/public/images/images'
                        '/${_filename.name}'
                        ),
                    context
                    );
        }
        return;
    }

    Future<List<dynamic>> _getData() async {
        final List<FileObject> _filenames = await _getImageFileNames();
        _precacheImages(_filenames.sublist(0, _precacheOffset));
        return _filenames;
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                    child: FutureBuilder<List<dynamic>>(
                        future: _getData(),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator();
                        } else if (snapshot.hasError) {
                        return Column(
                                children: <Widget>[
                                Icon(CupertinoIcons.clear_fill),
                                Text('An unexpected error ocurred: $snapshot.error'),
                                ],
                                );
                        } else {
                        final List<FileObject> _imageFileNames = snapshot?.data as List<FileObject>;

                        return CardSwiper(
                                cardsCount: _imageFileNames.length, 
                                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                return Card(
                                        child: CachedNetworkImage(
                                            imageUrl: 'https://bnuakobfluardglvfltt.supabase.co'
                                            '/storage/v1/object/public/images/images'
                                            '/${_imageFileNames?[index].name ?? ''}',
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => CupertinoActivityIndicator(),
                                            errorWidget: (context, url, error) => Column(
                                                    children: <Widget>[
                                                    Icon(CupertinoIcons.clear_fill),
                                                    Text('An unexpected error ocurred.'),
                                                    ],
                                                    ),
                                            ),
                                        elevation: 10.0,
                                        );
                                },
                                onSwipe: (oldIndex, currentIndex, swipeDirection) {
                                    if (currentIndex! % 5 == 0) {
                                        _precacheImages(_imageFileNames.sublist(currentIndex! + 5, currentIndex! + _precacheOffset));
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
