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
                    // https://bnuakobfluardglvfltt.supabase.co/storage/v1/object/public/images/images/<fn>
                        future: downloadImage('_freddyleo_10.png'),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator();
                        } else if (snapshot.hasError || snapshot.data == null) {
                        return Icon(CupertinoIcons.book);
                        } else {
                        return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                );
                        }
                        },
                        ),
                    );
        }
}
