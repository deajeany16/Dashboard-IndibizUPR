import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_validators.dart';

class ResetPasswordController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  bool showPassword = false;

  bool confirmPassword = false;

  int selectTime = 1;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'password',
      required: true,
      validators: [
        MyLengthValidator(min: 6, max: 10),
      ],
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'confirm_password',
      required: true,
      label: "Confirm password",
      validators: [
        MyLengthValidator(min: 6, max: 10),
      ],
      controller: TextEditingController(),
    );
  }

  // Future<void> onLogin() async {
  //   if (basicValidator.validateForm()) {
  //     var errors = await AuthService.loginUser(basicValidator.getData());
  //     if (errors != null) {
  //       basicValidator.addErrors(errors);
  //       basicValidator.validateForm();
  //       basicValidator.clearErrors();
  //     }
  //     Get.toNamed('/dashboard');
  //     update();
  //   }
  // }

  Future<void> onLogin() async {
    try {
      if (basicValidator.validateForm()) {
        update();
        var auth = Get.put(AuthService());
        var login = await auth.login(basicValidator.getData());
        if (login.statusCode == 401) {
          basicValidator.addErrors({"Auth Failed": "Gagal"});
          basicValidator.validateForm();
          basicValidator.clearErrors();
        } else {
          String nextUrl =
              Uri.parse(ModalRoute.of(Get.context!)?.settings.name ?? "")
                      .queryParameters['next'] ??
                  "/dashboard";
          Get.toNamed(
            nextUrl,
          );
        }
      }
    } catch (e) {
      basicValidator.addErrors({"Auth Failed": "failed"});
      basicValidator.validateForm();
      basicValidator.clearErrors();
    }

    update();
  }

  void select(int select) {
    selectTime = select;
    update();
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }

  void onResetPasswordPassword() {
    confirmPassword = !confirmPassword;
    update();
  }
}
