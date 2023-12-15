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
    bool _isObserving = true;
    bool get isObserving => _isObserving;

    int _navbarIndex = 1;
    int get navbarIndex => _navbarIndex;

    // Index of -1 means we haven't yet started swiping
    int _imageIndex = -1;
    int get imageIndex => _imageIndex;

    final int _batchSize = 10;

    final SupabaseClient _supabase = Supabase.instance.client;
    final List<Tattoo> _tattoos = [];
    List<Tattoo> get tattoos => _tattoos;

    toggleIsObserving() {
        _isObserving = !_isObserving;
    }

    setIsObserving() {
        _isObserving = true;
    }

    unsetIsObserving() {
        _isObserving = false;
    }

    setImageIndex(index) {
        _imageIndex = index;
    }

    setNavbarIndex(index) {
        _navbarIndex = index;
        notifyListeners();
    }

    resetIndex() {
        if (_navbarIndex == 0) {
            _imageIndex = 0;
        }
    }

    clearTattoos() {
        _tattoos.clear();
    }


    Future<bool> fetchImages() async {
        print("navbarIndex: $_navbarIndex");
        // check if user is on DiscoverPage
        if (_navbarIndex != 0) {
            return true;
        }

        if (_tattoos.isNotEmpty) {
            List<Tattoo> sublist = _tattoos.sublist(_imageIndex, _tattoos.length);
            _tattoos.clear();
            _tattoos.addAll(sublist);
            return true;
        }

        // TODO: 
        // (1) Only get images user has not seen
        // (2) Random selection
        // (3) 70% Recommendations, 30% random
        List<Tattoo> data = await _supabase.storage
            .from('images')
            .list(
                    path: 'images',
                    searchOptions: SearchOptions(
                            limit: _batchSize,
                            )
                     )
            .then((response) => response.map((fileObject) => Tattoo(imageUrl: fileObject.name)).toList());

        _tattoos.addAll(data);
        return true; 
    }
}
