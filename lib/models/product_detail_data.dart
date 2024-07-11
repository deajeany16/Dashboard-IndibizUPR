import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/models/identifier_model.dart';

class ProductDetailData extends IdentifierModel {
  final String productName;
  final double rating;
  final int price;

  ProductDetailData(super.id, this.productName, this.rating, this.price);

  static ProductDetailData fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String productName = decoder.getString('product_name');
    double rating = decoder.getDouble('rating');

    int price = decoder.getInt('price');

    return ProductDetailData(decoder.getId, productName, rating, price);
  }

  static List<ProductDetailData> listFromJSON(List<dynamic> list) {
    return list.map((e) => ProductDetailData.fromJSON(e)).toList();
  }

  //Dummy

  static List<ProductDetailData>? _dummyList;

  static Future<List<ProductDetailData>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 10);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/product_detail.json');
  }
}
