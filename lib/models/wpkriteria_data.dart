import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';

class Kriteria {
  final String kriteria;
  final int bobot;
  final double normalisasi;
  final String idkriteria; // Mengubah tipe data dari String menjadi int

  Kriteria(this.idkriteria, this.kriteria, this.bobot, this.normalisasi);

  static Kriteria fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String kriteria = decoder.getString('kriteria');
    int bobot = decoder.getInt('bobot');
    double normalisasi = decoder.getDouble('normalisasi');
    String idkriteria = decoder.getString('idkriteria');

    return Kriteria(idkriteria, kriteria, bobot, normalisasi);
  }

  static List<Kriteria> listFromJSON(List<dynamic> list) {
    return list.map((e) => Kriteria.fromJSON(e)).toList();
  }

  static List<Kriteria>? _dummyList;

  static Future<List<Kriteria>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 6);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/Kriteria.json');
  }
}
