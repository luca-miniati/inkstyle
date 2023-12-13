import 'package:flutter/cupertino.dart';
import 'package:requests/requests.dart';

class Tattoo {
    final String imageUrl;

    Tattoo({required this.imageUrl});
}

class TattooProvider extends ChangeNotifier {
    List<Tattoo> _tattoos = [];
    bool _isLoading = false;
    int _currentPage = 0;
    int _pageSize = 50;

    List<Tattoo> get tattoos => _tattoos;
    bool get isLoading => _isLoading;

    void loadTattoos() async {

