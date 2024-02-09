import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grock/grock.dart';
import 'package:inital_code/constant/constant.dart';

class CustomAppBar extends StatelessWidget implements  PreferredSizeWidget {
@override
  final Size preferredSize;
  String appbarTitle;

  CustomAppBar({Key? key, this.appbarTitle = "Initial Code Library"}) : preferredSize = const Size.fromHeight(56.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appbarTitle,
        style: TextStyle(
          color: Constant.white,
          fontWeight: FontWeight.bold,
          fontSize: 27,
          fontStyle: FontStyle.italic,
          )
      ),
      actions: [
        GestureDetector(
          onTap: () {
            print("Search button clicked");
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset("assets/icons/search.svg", color: Constant.white, width: 50, height: 50),
          ),
        ),
      ],
      automaticallyImplyLeading: true,
      backgroundColor: Constant.orange,
    );
  }
}
