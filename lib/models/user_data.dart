// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webui/helper/services/json_decoder.dart';
import 'package:webui/models/identifier_model.dart';

class User extends IdentifierModel {
  final String nama, username, hak_akses, usid;

  User(super.id, this.nama, this.username, this.hak_akses, this.usid);

  static User fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String nama = decoder.getString('nama');
    String username = decoder.getString('username');
    String hak_akses = decoder.getString('hak_akses');
    String usid = decoder.getString('usid');

    return User(decoder.getId, nama, username, hak_akses, usid);
  }

  static List<User> listFromJSON(List<dynamic> list) {
    return list.map((e) => User.fromJSON(e)).toList();
  }

  static List<User>? _dummyList;

  static Future<List<User>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 6);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/user.json');
  }
}
