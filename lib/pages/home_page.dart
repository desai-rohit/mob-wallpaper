import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/widget/my_text_widget.dart';
import 'package:wallpaper_app/provider/internet/no_internet.dart';
import 'package:wallpaper_app/provider/internet/provider_internet.dart';
import 'package:wallpaper_app/provider/wall_provider.dart';

import 'package:wallpaper_app/widget/wallpaper.dart';

String? stringResponse;
Map? mapResponse;
Map? dataResponse;

List listResponse = [];

int pageNumber = 2;

String display = 'abstract';

final controller = ScrollController();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class MyPageItem {
  String itemName;
  String path;
  MyPageItem(this.itemName, this.path);
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  List<MyPageItem> items = [
    MyPageItem("Nature",
        "https://images.pexels.com/photos/2559941/pexels-photo-2559941.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    MyPageItem("Animals",
        "https://images.pexels.com/photos/814898/pexels-photo-814898.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    MyPageItem("Birds",
        "https://images.pexels.com/photos/37833/rainbow-lorikeet-parrots-australia-rainbow-37833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    MyPageItem("Bike",
        "https://images.pexels.com/photos/1119796/pexels-photo-1119796.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    MyPageItem("Car",
        "https://images.pexels.com/photos/3311574/pexels-photo-3311574.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    MyPageItem("Sports",
        "https://images.pexels.com/photos/1604869/pexels-photo-1604869.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  ];

  @override
  void initState() {


    super.initState();
    Provider.of<ProviderInternet>(context, listen: false).startMonitoring();
    WallProvider wallProvider =
        Provider.of<WallProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      wallProvider.apiCallPexel();
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          //apiCallPexelNextPage();
          wallProvider.apiCallPexelNextPage();
        }
      });
    });
    //apiCallPexelNextPage();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderInternet>(
      builder: (context, model, child) {
        return model.isOnline
            ? GestureDetector(
                onTap: (() {
                  FocusScope.of(context).unfocus();
                }),
                child: Scaffold(
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      title: const GradientText(
                        'Mob Wallpaper',
                        style: TextStyle(fontSize: 30),
                        gradient:
                            LinearGradient(colors: [Colors.green, Colors.blue]),
                      ),
                      centerTitle: true,
                    ),
                    body: Column(
                      children: [
                        mySearch(context),
                        myCarouselSlider(),
                        const MyTextWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Wallpaper()
                        // const MyWallpaperListWidget()
                      ],
                    )))
            : const NoInternet();
      },
    );
  }

  Container mySearch(BuildContext context) {
    WallProvider provider = Provider.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          provider.wallcategory(provider.searchTextC.text);
          provider.apiCallPexel();
        },
        controller: provider.searchTextC,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Search Wallpaper",
            suffixIcon: IconButton(
                onPressed: () {
                  provider.wallcategory(provider.searchTextC.text);
                  //display = searchTextC.text;
                  provider.apiCallPexel();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ))),
      ),
    );
  }

  Container myCarouselSlider() {
    return Container(
      child: CarouselSlider(
          items: items
              .map(
                (item) => Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Stack(children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.path,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.5, //200
                          height: MediaQuery.of(context).size.width * 0.4, //100
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          splashColor: Colors.grey.withOpacity(0.5),
                          onTap: () {
                            WallProvider provider = Provider.of<WallProvider>(
                                context,
                                listen: false);
                            provider.wallcategory(item.itemName);
                            provider.apiCallPexel();

                            setState(() {
                              display = item.itemName;
                              provider.apiCallPexel();
                            });
                          }),
                    )
                  ]),
                ),
              )
              .toList(),
          options: CarouselOptions(
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              viewportFraction: 0.5,
              enableInfiniteScroll: true,
              scrollDirection: Axis.horizontal,
              autoPlay: false,
              aspectRatio: 4.0,
              enlargeCenterPage: true)),
    );
  }
}

class CategoryList {
  String title;
  String image;

  CategoryList(this.title, this.image);
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
