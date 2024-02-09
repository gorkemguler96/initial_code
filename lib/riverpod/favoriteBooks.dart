import 'package:flutter/cupertino.dart';

class FavoriteBooks extends ChangeNotifier {
  List<String> _favoriteBooks = [];

  List<String> get favoriteBooks => _favoriteBooks;

  void addFavoriteBook(String book) {
    _favoriteBooks.add(book);
    notifyListeners();
  }

  void removeFavoriteBook(String book) {
    _favoriteBooks.remove(book);
    notifyListeners();
  }
}
