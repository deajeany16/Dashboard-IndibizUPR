import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/images.dart';
import 'package:webui/models/identifier_model.dart';

class Discover extends IdentifierModel {
  final String jobTitle, appName, country, name, address, image;
  final int price;
  final double rating;

  Discover(super.id, this.jobTitle, this.appName, this.country, this.price,
      this.rating, this.name, this.address, this.image);

  static Discover fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);
    String jobTitle = decoder.getString('job_title');
    String appName = decoder.getString('app_name');
    String country = decoder.getString('country');
    int price = decoder.getInt('price');
    double rating = decoder.getDouble('rating');
    String name = decoder.getString('name');
    String address = decoder.getString('address');
    String image = Images.randomImage(Images.avatars);

    return Discover(decoder.getId, jobTitle, appName, country, price, rating,
        name, address, image);
  }

  static List<Discover> listFromJSON(List<dynamic> list) {
    return list.map((e) => Discover.fromJSON(e)).toList();
  }

  static List<Discover>? _dummyList;

  static Future<List<Discover>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 16);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/discover.json');
  }
}
