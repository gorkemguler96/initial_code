import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:inital_code/components/custom_appbar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inital_code/constant/constant.dart';
import 'package:inital_code/view/Home/favorites.dart';
import 'package:inital_code/view/Home/library.dart';

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}
class _HomeState extends ConsumerState<Home> {
  int active_page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: active_page != 0 ? Favorites() : Library(),
      ),
      bottomNavigationBar: GNav(
        gap: 20,
        activeColor: Colors.white,
        iconSize: 25,
        tabMargin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        duration: Duration(milliseconds: 800),
        tabBackgroundColor: Constant.orange,
        backgroundColor: Constant.black,
        color: Constant.gray,
        tabs: [
          GButton(
            icon: Icons.book_outlined,
            text: 'Books',
          ),
          GButton(
            icon: Icons.favorite,
            text: 'Favorites',
          ),
        ],
        selectedIndex: active_page,
        onTabChange: (index) {
          print(index);
          setState(() {
            active_page = index;
          });
        },
      ),
    );
  }
}
