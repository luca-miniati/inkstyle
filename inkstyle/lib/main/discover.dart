import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class DiscoverPage extends StatelessWidget {
    final supabase = Supabase.instance.client;
    Future<List<FileObject>> _listFiles() async {
        final response = await supabase.storage.from('images').list();
        return response ?? [];
    }

    Future<Uint8List> _downloadFile(String fileName) async {
        final response = await supabase.storage.from('images').download(fileName);
        return response;
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                        middle: Text('Discover'),
                        ),
                    child: FutureBuilder<List<FileObject>>(
                        future: _listFiles(),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator();
                        } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No images found.');
                        } else {
                        return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                final fileObject = snapshot.data![index];
                                return ListTile(
                                        title: FutureBuilder<Uint8List>(
                                            future: _downloadFile(fileObject.name),
                                            builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CupertinoActivityIndicator();
                                            } else if (snapshot.hasError) {
                                            return Text('Error downloading file: ${snapshot.error}');
                                            } else {
                                            return Image.memory(snapshot.data!);
                                            }
                                            },
                                            ),
                                        );
                                },
                                );
                        }
                        }
            )
            );
        }
}
