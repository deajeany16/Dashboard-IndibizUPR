import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';

class SalesOrderInputan {
  final String soid,
      namasaless,
      kodesaless,
      namausaha,
      alamatt,
      cp,
      emaill,
      pakett,
      maps,
      statusinput;
  final DateTime createdAt;

  SalesOrderInputan(
      this.soid,
      this.namasaless,
      this.kodesaless,
      this.namausaha,
      this.alamatt,
      this.cp,
      this.emaill,
      this.pakett,
      this.maps,
      this.statusinput,
      this.createdAt);

  static SalesOrderInputan fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    // int soid = decoder.getInt('soid');
    String soid = decoder.getString('soid');
    String kodesaless = decoder.getString('kodesaless');
    String namasaless = decoder.getString('namasaless');
    String namausaha = decoder.getString('namausaha');
    String alamatt = decoder.getString('alamatt');
    String cp = decoder.getString('cp');
    String emaill = decoder.getString('emaill');
    String pakett = decoder.getString('pakett');
    String maps = decoder.getString('maps');
    String statusinput = decoder.getString('statusinput');
    DateTime createdAt = decoder.getDateTime('createdAt');

    return SalesOrderInputan(soid, namasaless, kodesaless, namausaha, alamatt,
        cp, emaill, pakett, maps, statusinput, createdAt);
  }

  static List<SalesOrderInputan> listFromJSON(List<dynamic> list) {
    return list.map((e) => SalesOrderInputan.fromJSON(e)).toList();
  }

  //Dummy

  static List<SalesOrderInputan>? _dummyList;

  static Future<List<SalesOrderInputan>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/salesorder.json');
  }
}
