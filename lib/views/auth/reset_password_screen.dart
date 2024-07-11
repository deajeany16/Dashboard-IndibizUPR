import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:webui/controller/auth/reset_password_controller.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/views/layout/auth_layout.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late ResetPasswordController controller;

  @override
  void initState() {
    controller = Get.put(ResetPasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Form(
            key: controller.basicValidator.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: MySpacing.all(40),
                  child: Row(
                    children: [
                      
                      MyText.bodyLarge(
                        'Dashboard BS Kalteng',
                        fontSize: 30,
                        textAlign: TextAlign.center,
                        fontWeight: 600,
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: MySpacing.xy(50, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText.titleLarge(
                        "reset_password".tr().capitalizeWords,
                        fontWeight: 700,
                      ),
                      MySpacing.height(10),
                      MyText.bodySmall(
                        "your_password_will_be_reset".tr(),
                        muted: true,
                      ),
                      MySpacing.height(45),
                      MyText.labelMedium("password".tr()),
                      MySpacing.height(4),
                      TextFormField(
                        validator:
                            controller.basicValidator.getValidation('password'),
                        controller:
                            controller.basicValidator.getController('password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.showPassword,
                        decoration: InputDecoration(
                          border: outlineInputBorder,
                          suffixIcon: InkWell(
                            onTap: controller.onChangeShowPassword,
                            child: Icon(
                              controller.showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                          ),
                          contentPadding: MySpacing.all(16),
                          isCollapsed: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      MySpacing.height(20),
                      MyText.labelMedium(
                          "confirm_password".tr().capitalizeWords),
                      MySpacing.height(4),
                      TextFormField(
                        validator: controller.basicValidator
                            .getValidation('confirm_password'),
                        controller: controller.basicValidator
                            .getController('confirm_password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: controller.confirmPassword,
                        decoration: InputDecoration(
                          border: outlineInputBorder,
                          suffixIcon: InkWell(
                            onTap: controller.onResetPasswordPassword,
                            child: Icon(
                              controller.confirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                          ),
                          contentPadding: MySpacing.all(16),
                          isCollapsed: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      MySpacing.height(25),
                      Center(
                        child: MyButton.block(
                          onPressed: controller.onLogin,
                          elevation: 0,
                          padding: MySpacing.xy(40, 20),
                          backgroundColor: Color(0xff009678),
                          child: MyText.bodySmall(
                            'confirm'.tr(),
                            color: contentTheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
