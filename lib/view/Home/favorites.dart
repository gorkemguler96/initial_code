import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inital_code/constant/constant.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.favorites}) : super(key: key);
  final List<Object> favorites;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Map<String, dynamic> groupedFavorites = {};

  @override
  void initState() {
    super.initState();
    _groupFavorites();
  }

  void _groupFavorites() {
    widget.favorites.forEach((favorite) {
      final Map<String, dynamic> favoriteItem = favorite as Map<String, dynamic>;
      final String title = favoriteItem['volumeInfo']['title'] ?? '';

      if (!groupedFavorites.containsKey(title)) {
        groupedFavorites[title] = favoriteItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: groupedFavorites.length,
          itemBuilder: (context, index) {
            final String title = groupedFavorites.keys.elementAt(index);
            final Map<String, dynamic> favoriteItem = groupedFavorites[title];

            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(width: 2, color: Constant.orange),
                  ),
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text(
                        'Authors: ${favoriteItem['volumeInfo']['authors'].join(' ')}'),
                    leading: favoriteItem['volumeInfo']['imageLinks'] != null
                        ? Image.network(
                            favoriteItem['volumeInfo']['imageLinks']
                                ['thumbnail'],
                          )
                        : Placeholder(),
                    subtitleTextStyle:
                    TextStyle(fontSize: 14, color: Constant.dark),
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Constant.black),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
