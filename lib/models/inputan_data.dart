import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webui/helper/services/json_decoder.dart';
// ignore: unused_import
import 'package:webui/models/identifier_model.dart';

class Inputan {
  final String orderid,
      nama,
      namasales,
      kodesales,
      datel,
      sto,
      namaperusahaan,
      alamat,
      odp,
      nohp,
      nohp2,
      email,
      paket,
      nosc,
      status,
      ketstat,
      ket;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Inputan(
      this.orderid,
      this.nama,
      this.namasales,
      this.kodesales,
      this.datel,
      this.sto,
      this.namaperusahaan,
      this.alamat,
      this.latitude,
      this.longitude,
      this.odp,
      this.nohp,
      this.nohp2,
      this.email,
      this.paket,
      this.nosc,
      this.status,
      this.ketstat,
      this.ket,
      this.createdAt);

  static Inputan fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String orderid = decoder.getString('orderid');
    String nama = decoder.getString('nama');
    String namasales = decoder.getString('namasales');
    String kodesales = decoder.getString('kodesales');
    String datel = decoder.getString('datel');
    String sto = decoder.getString('sto');
    String namaperusahaan = decoder.getString('namaperusahaan');
    String alamat = decoder.getString('alamat');
    double latitude = decoder.getDouble('latitude');
    double longitude = decoder.getDouble('longitude');
    String odp = decoder.getString('odp');
    String nohp = decoder.getString('nohp');
    String nohp2 = decoder.getString('nohp2');
    String email = decoder.getString('email');
    String paket = decoder.getString('paket');
    String nosc = decoder.getString('nosc');
    String status = decoder.getString('status');
    String ketstat = decoder.getString('ketstat');
    String ket = decoder.getString('ket');
    DateTime createdAt = decoder.getDateTime('createdAt');

    return Inputan(
        orderid,
        nama,
        namasales,
        kodesales,
        datel,
        sto,
        namaperusahaan,
        alamat,
        latitude,
        longitude,
        odp,
        nohp,
        nohp2,
        email,
        paket,
        nosc,
        status,
        ketstat,
        ket,
        createdAt);
  }

  static List<Inputan> listFromJSON(List<dynamic> list) {
    return list.map((e) => Inputan.fromJSON(e)).toList();
  }

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }

  static List<Inputan>? _dummyList;

  static Future<List<Inputan>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/inputan.json');
  }
}
