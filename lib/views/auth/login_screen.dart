import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:webui/controller/auth/login_controller.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/views/layout/auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late LoginController controller;

  @override
  void initState() {
    controller = Get.put(LoginController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder<LoginController>(
        init: controller,
        builder: (controller) {
          return Form(
            key: controller.basicValidator.formKey,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: MySpacing.all(30),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText.bodyLarge(
                            'Dashboard BS Kalteng',
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 24
                                : 30,
                            textAlign: TextAlign.center,
                            fontWeight: 600,
                            maxLines:
                                2, // Tambahkan maxLines agar teks tetap dapat ditampilkan dengan baik
                            overflow: TextOverflow
                                .ellipsis, // Tambahkan overflow agar teks yang melebihi lebar tetap dapat ditampilkan secara jelas
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  AutofillGroup(
                    child: Padding(
                      padding: MySpacing.xy(50, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText.titleLarge(
                            "Welcome",
                            fontWeight: 700,
                            fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                          ),
                          MyText.bodySmall(
                            "Login your account",
                            fontSize: 14,
                            muted: true,
                          ),
                          MySpacing.height(30),
                          MyText.bodyMedium(
                            "Username",
                            fontWeight: 600,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            autofillHints: const [AutofillHints.username],
                            validator: controller.basicValidator
                                .getValidation('username'),
                            controller: controller.basicValidator
                                .getController('username'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: outlineInputBorder,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                                labelText: "Username",
                                contentPadding: MySpacing.all(16),
                                isCollapsed: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                          ),
                          MySpacing.height(20),
                          MyText.bodyMedium(
                            "password".tr(),
                            fontWeight: 600,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
                            validator:
                                controller.basicValidator.getValidation('pass'),
                            controller:
                                controller.basicValidator.getController('pass'),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showPassword,
                            onFieldSubmitted: (_) {
                              TextInput.finishAutofillContext();
                              controller.onLogin();
                            },
                            decoration: InputDecoration(
                                border: outlineInputBorder,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                labelText: "Password",
                                suffixIcon: InkWell(
                                  onTap: controller.onChangeShowPassword,
                                  child: Icon(
                                    controller.showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                ),
                                contentPadding: MySpacing.all(16),
                                isCollapsed: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                          ),
                          MySpacing.height(12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MyButton.text(
                              onPressed: () => controller.goToForgotPassword(),
                              elevation: 0,
                              padding: MySpacing.xy(8, 0),
                              splashColor:
                                  contentTheme.secondary.withOpacity(0.1),
                              child: MyText.labelSmall(
                                'forgot_password?'.tr().capitalizeWords,
                                color: contentTheme.secondary,
                              ),
                            ),
                          ),
                          MySpacing.height(20),
                          Center(
                            child: MyButton.block(
                              onPressed: () {
                                TextInput.finishAutofillContext();
                                controller.onLogin();
                              },
                              elevation: 0,
                              padding: MySpacing.xy(40, 20),
                              backgroundColor: contentTheme.primary,
                              child: MyText.bodyMedium(
                                'login'.tr(),
                                color: contentTheme.onPrimary,
                              ),
                            ),
                          ),
                          MySpacing.height(5),
                          Center(
                            child: MyButton.text(
                                onPressed: controller.gotoRegister,
                                padding: MySpacing.xy(8, 4),
                                child: MyText.bodyMedium(
                                  "Don't have an account",
                                  fontWeight: 600,
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
