import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webui/helper/services/json_decoder.dart';

class Survei {
  final String namausaha;
  final double latitude; // Mengubah tipe data dari String menjadi double
  final double longitude;
  final String jenisusaha;
  final String alamatusaha;
  final int idsurvei; // Mengubah tipe data dari String menjadi int

  Survei(this.idsurvei, this.namausaha, this.latitude, this.longitude,
      this.jenisusaha, this.alamatusaha);

  static Survei fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String namausaha = decoder.getString('namausaha');
    double latitude = decoder.getDouble('latitude');
    double longitude = decoder.getDouble('longitude');
    String jenisusaha = decoder.getString('jenisusaha');
    String alamatusaha = decoder.getString('alamatusaha');
    int idsurvei = decoder.getInt('idsurvei');

    return Survei(
        idsurvei, namausaha, latitude, longitude, jenisusaha, alamatusaha);
  }

  static List<Survei> listFromJSON(List<dynamic> list) {
    return list.map((e) => Survei.fromJSON(e)).toList();
  }

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }

  static List<Survei>? _dummyList;

  static Future<List<Survei>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 6);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/survei.json');
  }
}
