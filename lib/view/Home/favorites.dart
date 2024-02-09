import 'package:flutter/cupertino.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // appBar: CustomAppBar(),
      child: const Center(
        child: Text("Favorasdasdasites"),
      ),
    );
  }
}
