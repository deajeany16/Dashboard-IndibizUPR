import 'package:flutter/material.dart';
import 'package:webui/controller/my_controller.dart';

class AuthLayoutController extends MyController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final scrollKey = GlobalKey();

  int selectTime = 1;

  void select(int select) {
    selectTime = select;
    update();
  }

}
