import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:webui/controller/auth/forgot_password_controller.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/views/layout/auth_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late ForgotPasswordController controller;

  @override
  void initState() {
    controller = Get.put(ForgotPasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder<ForgotPasswordController>(
        init: controller,
        builder: (controller) {
          return Form(
              key: controller.basicValidator.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: MySpacing.all(40),
                    child: Row(
                      children: [
                        MyText.bodyLarge(
                          'Dashboard BS Kalteng',
                          fontSize: MediaQuery.of(context).size.width < 600
                                ? 24
                                : 30,
                          textAlign: TextAlign.center,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  MySpacing.height(16),
                  Padding(
                    padding: MySpacing.xy(50, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText.titleLarge(
                          "forgot_password".tr().capitalizeWords,
                          fontWeight: 700,
                        ),
                        MySpacing.height(8),
                        MyText.bodySmall(
                          "Please reset your password.",
                          muted: true,
                        ),
                        MySpacing.height(16),
                        MyText.labelMedium("username".tr().capitalizeWords),
                        MySpacing.height(8),
                        TextFormField(
                          validator:
                              controller.basicValidator.getValidation('email'),
                          controller:
                              controller.basicValidator.getController('email'),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: outlineInputBorder,
                            contentPadding: MySpacing.all(16),
                            isCollapsed: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                        MySpacing.height(16),
                        Center(
                          child: MyButton(
                            onPressed: controller.onLogin,
                            elevation: 0,
                            borderRadiusAll: 4,
                            padding: MySpacing.xy(16, 16),
                            backgroundColor: contentTheme.primary,
                            child: MyText.bodySmall(
                              'forgot_password'.tr().capitalizeWords,
                              color: contentTheme.onPrimary,
                            ),
                          ),
                        ),
                        Center(
                          child: MyButton.text(
                            onPressed: controller.gotoLogIn,
                            elevation: 0,
                            borderColor: contentTheme.primary,
                            splashColor:
                                contentTheme.secondary.withOpacity(0.1),
                            child: MyText.labelMedium(
                              'back_to_log_in'.tr(),
                              color: contentTheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
