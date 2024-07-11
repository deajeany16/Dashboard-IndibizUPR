// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/models/identifier_model.dart';

class Sales extends IdentifierModel {
  final String namaa, kodee, usertele, said;

  Sales(super.id, this.namaa, this.kodee, this.usertele, this.said);

  static Sales fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String namaa = decoder.getString('namaa');
    String kodee = decoder.getString('kodee');
    String usertele = decoder.getString('usertele');
    String said = decoder.getString('said');

    return Sales(decoder.getId, namaa, kodee, usertele, said);
  }

  static List<Sales> listFromJSON(List<dynamic> list) {
    return list.map((e) => Sales.fromJSON(e)).toList();
  }

  static List<Sales>? _dummyList;

  static Future<List<Sales>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 10);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/sales.json');
  }
}
