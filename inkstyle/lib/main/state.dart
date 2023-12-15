import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';


class Tattoo {
    final String imageUrl;

    Tattoo({required this.imageUrl});
}


class TattooProvider extends ChangeNotifier {
    final List<Tattoo> _tattoos = [];
    int _batchIdx = 0;
    final int _batchSize = 10;
    final SupabaseClient _supabase = Supabase.instance.client;

    List<Tattoo> get tattoos => _tattoos;
    int get batchSize => _batchSize;

    void incrementBatchIdx() {
        _batchIdx++;
    }

    Future<void> extendTattoos() async {
        List<FileObject> fileObjects = await _supabase.storage
            .from('images')
            .list(
                    path: 'images',
                    searchOptions: SearchOptions(
                        limit: _batchSize,
                        offset: _batchSize * _batchIdx, 
                        )
                 );
                 
        List<Tattoo> newTattoos = fileObjects
            .map((fileObject) => Tattoo(imageUrl: fileObject.name))
            .toList();
        _tattoos.addAll(newTattoos);
        print("added ${newTattoos.length} images.");
        return; 
    }

    Future<void> loadTattoos() async {
        Completer<void> completer = Completer<void>();
        try {
            // if current page is greater than number of batches loaded
            // e.g. Do we have any images to load?
            if (_batchIdx >= (_tattoos.length ~/ _batchSize)) {
                await extendTattoos();
            }
            completer.complete();
        } catch (e) {
            completer.completeError(e);
        }
        return completer.future;
    }
}


class AppState extends ChangeNotifier {
    int _navbarIndex = 1;
    int get navbarIndex => _navbarIndex;

    int _imageIndex = 0;
    int get imageIndex => _imageIndex;

    incrementImageIndex() {
        _imageIndex++;
    }

    setNavbarIndex(index) {
        _navbarIndex = index;
        notifyListeners();
    }
}
