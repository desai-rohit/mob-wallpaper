import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/provider/wall_provider.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WallProvider provider = Provider.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          provider.display,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
