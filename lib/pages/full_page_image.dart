import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class FullpageImage extends StatefulWidget {
  final String hd;
  final String ultrahd;

  const FullpageImage({Key? key, required this.hd, required this.ultrahd})
      : super(key: key);

  @override
  State<FullpageImage> createState() => _FullpageImageState();
}

class _FullpageImageState extends State<FullpageImage> {
  hdsave() async {
    var status = Permission.photos.request();

    if (await status.isGranted) {
      var response = await Dio().get(widget.hd,
          options: Options(
            responseType: ResponseType.bytes,
          ));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "hdimg");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
     content: Text("image download successfully"),
));
    } else if (await status.isDenied) {
      Permission.photos.request();
    } else if (await status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Setting'),
            content: const Text(
              'Go Permission Setting Allow The Permission To Downlaod Wallpaper',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Setting'),
                onPressed: () {
                  openAppSettings()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          );
        },
      );
    }
  }

  ultraHdsave() async {
    var status = Permission.photos.request();
    if (await status.isGranted) {
      var response = await Dio().get(widget.ultrahd,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "uhdimg");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
     content: Text("image download successfully"),
));
    } else if (await status.isDenied) {
      Permission.photos.request();
    } else if (await status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Setting'),
            content: const Text(
              'Go Permission Setting Allow The Permission To Downlaod Wallpaper',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Setting'),
                onPressed: () {
                  openAppSettings()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              // child: Image.network(
              //   widget.hd,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.hd,
                placeholder: (context, url) => SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      width: 50,
                      height: 100,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ]),
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });

                int location = WallpaperManager.HOME_SCREEN;
                var file = await DefaultCacheManager().getSingleFile(widget.hd);

                bool result = await WallpaperManager.setWallpaperFromFile(
                        file.path, location)
                    .whenComplete(() {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Wallpaper Set"),
                  ));
                });
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.wallpaper,
                color: Colors.black,
              ),
            ),
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                hdsave();
              },
              backgroundColor: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.download,
                      color: Colors.black, size: 15),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "HD",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  ultraHdsave();
                },
                backgroundColor: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.download,
                        color: Colors.black, size: 15),
                    SizedBox(width: 2),
                    Text(
                      "4",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    FaIcon(FontAwesomeIcons.k, color: Colors.black, size: 15),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
