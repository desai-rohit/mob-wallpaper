import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  children: [
                    Center(
                        child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        "assets/logo.png",
                      ),
                    )),
                    SizedBox(
                      height: 198,
                      width: 198,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 0, 60, 255)),
                        strokeWidth: 0.9,
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Mob Wallpaper",
            style: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
