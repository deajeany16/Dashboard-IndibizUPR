import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';

class Bobot {
  final String namakriteria;
  final int bobot;
  final String ketbobot;
  final int idkriteria;
  final int idbobot; // Mengubah tipe data dari String menjadi int

  Bobot(this.idbobot, this.namakriteria, this.bobot, this.ketbobot,
      this.idkriteria);

  static Bobot fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String namakriteria = decoder.getString('namakriteria');
    int bobot = decoder.getInt('bobot');
    String ketbobot = decoder.getString('ketbobot');
    int idkriteria = decoder.getInt('idkriteria');
    int idbobot = decoder.getInt('idbobot');

    return Bobot(idbobot, namakriteria, bobot, ketbobot, idkriteria);
  }

  static List<Bobot> listFromJSON(List<dynamic> list) {
    return list.map((e) => Bobot.fromJSON(e)).toList();
  }

  static List<Bobot>? _dummyList;

  static Future<List<Bobot>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 6);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/BobotKriteria.json');
  }
}
