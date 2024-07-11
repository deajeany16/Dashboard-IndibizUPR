import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/images.dart';
import 'package:webui/models/identifier_model.dart';

class Discover2 extends IdentifierModel {
  final String name, address, image;

  Discover2(super.id, this.name, this.address, this.image);

  static Discover2 fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String name = decoder.getString('name');
    String address = decoder.getString('address');
    String image = Images.randomImage(Images.avatars);

    return Discover2(decoder.getId, name, address, image);
  }

  static List<Discover2> listFromJSON(List<dynamic> list) {
    return list.map((e) => Discover2.fromJSON(e)).toList();
  }

  static List<Discover2>? _dummyList;

  static Future<List<Discover2>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 10);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/discover_2_data.json');
  }
}
