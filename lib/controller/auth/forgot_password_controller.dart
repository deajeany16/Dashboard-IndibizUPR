import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_validators.dart';

class ForgotPasswordController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();
  bool showPassword = false;
  int selectTime = 1;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'email',
      required: true,
      label: "Email",
      validators: [MyEmailValidator()],
      controller: TextEditingController(),
    );
  }

  // Future<void> onLogin() async {
  //   if (basicValidator.validateForm()) {
  //     update();
  //     var errors = await AuthService.login(basicValidator.getData());
  //     if (errors != null) {
  //       basicValidator.validateForm();
  //       basicValidator.clearErrors();
  //     }
  //     Get.toNamed('/auth/reset_password');
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

  void gotoLogIn() {
    Get.toNamed('/auth/login');
  }
}
