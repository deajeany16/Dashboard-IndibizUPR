import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_validators.dart';

class LockedController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  bool showPassword = false, loading = false;

  int selectTime = 1;

  @override
  void onInit() {
    super.onInit();

    basicValidator.addField(
      'password',
      required: true,
      label: 'Password',
      validators: [MyLengthValidator(min: 6, max: 10)],
      controller: TextEditingController(),
    );
  }

  void select(int select) {
    selectTime = select;
    update();
  }

  void onShowPassword() {
    showPassword = !showPassword;
    update();
  }

  // Services
  Future<void> onLock() async {
    if (basicValidator.validateForm()) {
      loading = true;
      update();
      await Future.delayed(Duration(seconds: 1));
      Get.toNamed('/dashboard');

      loading = false;
      update();
    }
  }
}
