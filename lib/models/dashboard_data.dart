import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/models/identifier_model.dart';

class DashBoardData extends IdentifierModel {
  final String companyName, sales;
  final int amount;
  final DateTime date;

  DashBoardData(super.id, this.companyName, this.sales, this.amount, this.date);

  static DashBoardData fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String companyName = decoder.getString('company_name');
    String sales = decoder.getString('sales');
    int amount = decoder.getInt('amount');
    DateTime date = decoder.getDateTime('date');

    return DashBoardData(decoder.getId, companyName, sales, amount, date);
  }

  static List<DashBoardData> listFromJSON(List<dynamic> list) {
    return list.map((e) => DashBoardData.fromJSON(e)).toList();
  }

  static List<DashBoardData>? _dummyList;

  static Future<List<DashBoardData>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 7);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/dashboard_data.json');
  }
}
