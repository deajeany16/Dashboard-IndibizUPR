import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webui/helper/services/json_decoder.dart';

class ODP {
  final String namaodp;
  final double latitude; // Mengubah tipe data dari String menjadi double
  final double longitude; // Mengubah tipe data dari String menjadi double
  final int kapasitas; // Mengubah tipe data dari String menjadi int
  final int isi; // Mengubah tipe data dari String menjadi int
  final int kosong; // Mengubah tipe data dari String menjadi int
  final int reserved; // Mengubah tipe data dari String menjadi int
  final String kategori;
  final int idodp; // Mengubah tipe data dari String menjadi int

  ODP(this.idodp, this.namaodp, this.latitude, this.longitude, this.kapasitas,
      this.isi, this.kosong, this.reserved, this.kategori);

  static ODP fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String namaodp = decoder.getString('namaodp');
    double latitude = decoder.getDouble('latitude');
    double longitude = decoder.getDouble('longitude');
    int kapasitas = decoder.getInt('kapasitas');
    int isi = decoder.getInt('isi');
    int kosong = decoder.getInt('kosong');
    int reserved = decoder.getInt('reserved');
    String kategori = decoder.getString('kategori');
    int idodp = decoder.getInt('idodp');

    return ODP(idodp, namaodp, latitude, longitude, kapasitas, isi, kosong,
        reserved, kategori);
  }

  static List<ODP> listFromJSON(List<dynamic> list) {
    return list.map((e) => ODP.fromJSON(e)).toList();
  }

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }

  static List<ODP>? _dummyList;

  static Future<List<ODP>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 6);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/ODP.json');
  }
}
