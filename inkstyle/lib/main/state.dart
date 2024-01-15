import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class Decision {
  final bool liked;
  final Tattoo tattoo;

  Decision({required this.liked, required this.tattoo});
}

class Tattoo {
  final String imageUrl;

  Tattoo({required this.imageUrl});
}

class AppState extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  String _error = "";
  String get error => _error;

  bool _observing = true;
  bool get observing => _observing;

  int _navbarIndex = 1;
  int get navbarIndex => _navbarIndex;

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;

  final int _batchSize = 10;
  int get batchSize => _batchSize;

  final int _cardsDisplayed = 3;
  int get cardsDisplayed => _cardsDisplayed;

  final SupabaseClient _supabase = Supabase.instance.client;
  final List<Tattoo> _tattoos = [];
  List<Tattoo> get tattoos => _tattoos;

  final List<dynamic> _decisions = List.filled(10, null);
  List<dynamic> get decisions => _decisions;

  incrementImageIndex() {
    _imageIndex += 1;
  }

  setNavbarIndex(index) {
    _navbarIndex = index;
    notifyListeners();
  }

  setDecision(liked) {
    _decisions[_imageIndex] =
        Decision(liked: liked, tattoo: _tattoos[_imageIndex]);

    if (_imageIndex == _batchSize - 1) {
      _observing = false;
    }

    notifyListeners();
  }

  Future<void> fetchImages() async {
    // check if user is on DiscoverPage
    if (_navbarIndex != 0) {
      return;
    }

    if (_tattoos.isNotEmpty) {
      return;
    }

    _loading = true;
    notifyListeners();

    // TODO:
    // (1) Only get images user has not seen
    // (2) Random selection
    // (3) 70% Recommendations, 30% random
    try {
    List<Tattoo> data = await _supabase.storage
        .from('images')
        .list(
            path: 'images',
            searchOptions: SearchOptions(
              limit: _batchSize,
            ))
        .then((response) => response
            .map((fileObject) => Tattoo(imageUrl: fileObject.name))
            .toList());
        _tattoos.addAll(data);
    } catch (e) {
        _error = e.toString();
    }

    _loading = false;
    notifyListeners();

    return;
  }
}
