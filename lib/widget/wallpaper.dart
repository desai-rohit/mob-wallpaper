import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/pages/full_page_image.dart';
import 'package:wallpaper_app/pages/home_page.dart';
import 'package:wallpaper_app/provider/wall_provider.dart';

class Wallpaper extends StatelessWidget {
  const Wallpaper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WallProvider provider = Provider.of(context);

    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: controller,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: provider.listResponse.isEmpty
              ? 0
              : provider.listResponse.length + 9,
          itemBuilder: (context, index) {
            if (index < provider.listResponse.length) {
              final item = provider.listResponse[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullpageImage(
                                hd: item["src"]["large2x"],
                                ultrahd: item["src"]["original"],
                              )));
                },
                child: provider.isloading == true
                    ? SizedBox(
                        width: 50.0,
                        height: 100.0,
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
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item["src"]["medium"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              );
            }
            return SizedBox(
              width: 50.0,
              height: 100.0,
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
            );
          }),
    ));
  }
}
