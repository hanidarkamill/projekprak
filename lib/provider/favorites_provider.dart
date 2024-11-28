import 'package:flutter/material.dart';
import 'package:projek3/model/favorite_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteModel> _favorites = [];

  List<FavoriteModel> get favorites => _favorites;

  void addToFavorites(FavoriteModel item) {
    _favorites.add(item);
    notifyListeners();
  }

  void removeFromFavorites(FavoriteModel item) {
    _favorites.remove(item);
    notifyListeners();
  }
}
