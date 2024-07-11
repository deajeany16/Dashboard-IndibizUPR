import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_validators.dart';
import 'package:webui/widgets/custom_alert.dart';

class SignUpController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();
  bool isChecked = false;
  int selectTime = 1;

  void onChangeCheckBox(bool? value) {
    isChecked = value ?? isChecked;
    update();
  }

  void select(int select) {
    selectTime = select;
    update();
  }

  bool showPassword = false, loading = false;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'username',
      required: true,
      label: "Username",
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'nama',
      required: true,
      label: 'Nama',
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'pass',
      required: true,
      label: "Password",
      validators: [MyLengthValidator(min: 6, max: 20)],
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'hak_akses',
      required: true,
      label: 'Hak Akses',
      controller: TextEditingController(),
    );
  }

  // Future<void> onLogin() async {
  //   if (basicValidator.validateForm()) {
  //     loading = true;
  //     update();
  //     var errors = await AuthService.loginUser(basicValidator.getData());
  //     if (errors != null) {
  //       basicValidator.addErrors(errors);
  //       basicValidator.validateForm();
  //       basicValidator.clearErrors();
  //     }
  //     Get.toNamed('/starter');

  //     loading = false;
  //     update();
  //   }
  // }

  Future<void> onSignUp() async {
    try {
      if (basicValidator.validateForm()) {
        update();
        var authService = Get.put(AuthService());
        dynamic userData = await authService.register(basicValidator.getData());
        if (userData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'User berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          basicValidator.resetForm();
          Future.delayed(Duration(seconds: 2), () {
            gotoLogin();
          });
        } else if (userData.statusCode == 400) {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Pendaftaran Gagal',
            text: 'Pengguna sudah terdaftar',
            confirmBtnText: 'Okay',
          ));
        }
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }

    update();
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }

  void gotoLogin() {
    Get.toNamed('/auth/login');
  }
}
