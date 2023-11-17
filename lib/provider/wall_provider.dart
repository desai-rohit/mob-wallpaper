import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallProvider extends ChangeNotifier {
  bool isloading = false;
  List listResponse = [];
  String display = 'abstract';
  int pageNumber = 2;
  TextEditingController searchTextC = TextEditingController();

  wallcategory(String name) {
    display = name;
    notifyListeners();
  }

  Future apiCallPexel() async {
    isloading = true;
    // display = 'abstract';
    notifyListeners();
    String url =
        "https://api.pexels.com/v1/search?query=$display&per_page=78&orientation=portrait";
    notifyListeners();
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "563492ad6f917000010000013624ff24883a40709c15dd6a0ec313fc"
    });

    if (response.statusCode == 200) {
      isloading = false;
      notifyListeners();
      var data = json.decode(response.body);
      return listResponse = data["photos"];
    } else {
      throw Exception("failed");
    }
  }

  Future apiCallPexelNextPage() async {
    notifyListeners();
    String url =
        "https://api.pexels.com/v1/search?query=$display&per_page=78&orientation=portrait&page=${pageNumber.toString()}";
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "563492ad6f917000010000013624ff24883a40709c15dd6a0ec313fc"
    });

    if (response.statusCode == 200) {
      pageNumber++;
      notifyListeners();
      var data = json.decode(response.body);
      return listResponse.addAll(data!["photos"]);
    } else {
      throw Exception("failed");
    }
  }
}
