import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';

class Alternatif {
  final String namaalternatif;
  final int idalternatif; // Mengubah tipe data dari String menjadi int

  Alternatif(this.idalternatif, this.namaalternatif);

  static Alternatif fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String namaalternatif = decoder.getString('namaalternatif');
    int idalternatif = decoder.getInt('idalternatif');

    return Alternatif(idalternatif, namaalternatif);
  }

  static List<Alternatif> listFromJSON(List<dynamic> list) {
    return list.map((e) => Alternatif.fromJSON(e)).toList();
  }

  static List<Alternatif>? _dummyList;

  static Future<List<Alternatif>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 2);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/Alternatif.json');
  }
}
