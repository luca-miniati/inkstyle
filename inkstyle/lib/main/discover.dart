import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DiscoverPage extends StatefulWidget {
    const DiscoverPage({super.key}); 

    @override
        State<DiscoverPage> createState() => _DiscoverPageState();
}


class _DiscoverPageState extends State<DiscoverPage> {
    final _supabase = Supabase.instance.client;
    final _imageIdx = 1;

    Future<List<FileObject>> _getImageFileNames() async {
        List<FileObject> fns = await _supabase.storage.from('images').list(path: 'images');
        return fns;
    }

    Future<Uint8List?> downloadImage(String fileName) async {
        try {
            final response = await _supabase.storage
                .from('images')
                .download('images/' + fileName);

            if (response != null) {
                return response;
            } else {
                print('Error downloading image: ${response.toString()}');
                return null;
            }
        } catch (error) {
            print('Error downloading image: $error');
            return null;
        }
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                    child: FutureBuilder<Uint8List?>(
                        future: _getImageFileNames(),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator();
                        } else if (snapshot.hasError) {
                        return Column(
                                children: <Widget>[
                                Icon(CupertinoIcons.clear_fill),
                                Text('An unexpected error ocurred.'),
                                ],
                                );
                        } else {
                        return CachedNetworkImage(
                                imageUrl:'https://bnuakobfluardglvfltt.supabase.co/storage/v1/object/public/images/images/${snapsnot.data![_imageIdx]}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => Column(
                                    children: <Widget>[
                                    Icon(CupertinoIcons.clear_fill),
                                    Text('An unexpected error ocurred.'),
                                    ],
                                    ),
                                );
                        }
                        },
                        ),
                        );
        }
}
