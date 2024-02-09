import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:inital_code/constant/constant.dart';
import 'package:inital_code/view/Home/home.dart';

class Splash extends StatefulWidget {

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),(){
      Grock.toRemove(Home());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constant.black,
      body: Center(
        child: Image(image: AssetImage('assets/images/img_splash.jpg'))
      ),
    );
  }
}
