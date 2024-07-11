import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:webui/controller/auth/locked_controller.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_responsiv.dart';
import 'package:webui/helper/widgets/my_screen_media_type.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/my_text_style.dart';
import 'package:webui/images.dart';
import 'package:webui/views/layout/auth_layout.dart';

class LockedScreen extends StatefulWidget {
  const LockedScreen({super.key});

  @override
  State<LockedScreen> createState() => _LockedScreenState();
}

class _LockedScreenState extends State<LockedScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late LockedController controller;

  @override
  void initState() {
    controller = Get.put(LockedController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder<LockedController>(
        init: controller,
        builder: (controller) {
          return Form(
            key: controller.basicValidator.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: MySpacing.all(40),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.logoIcon,
                        height: 32,
                        alignment: Alignment.center,
                      ),
                      MyText.bodyLarge(
                        'WEBUI',
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
                    children: [
                      Center(
                        child: MyText.titleLarge(
                          "locked".tr(),
                          fontWeight: 700,
                        ),
                      ),
                      MySpacing.height(8),
                      Center(
                        child: MyText(
                          "hello_den,_enter_your_password_to_unlock_the_screen!"
                              .tr(),
                        ),
                      ),
                      MySpacing.height(16),
                      Center(
                        child: MyContainer.none(
                          borderRadiusAll: 26,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset(
                            Images.avatars[5],
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      MySpacing.height(8),
                      Center(
                        child: MyText(
                          "den".tr(),
                          fontWeight: 700,
                        ),
                      ),
                      MySpacing.height(16),
                      MyText.labelMedium(
                        "password".tr(),
                        fontWeight: 600,
                      ),
                      MySpacing.height(8),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller:
                            controller.basicValidator.getController('password'),
                        validator:
                            controller.basicValidator.getValidation('password'),
                        obscureText: !controller.showPassword,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: controller.onShowPassword,
                              child: Icon(
                                controller.showPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_outline, size: 18),
                            hintText: "Password",
                            hintStyle: MyTextStyle.bodySmall(xMuted: true),
                            border: outlineInputBorder,
                            contentPadding: MySpacing.all(12),
                            isCollapsed: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                      MySpacing.height(16),
                      Center(
                        child: MyButton.block(
                          onPressed: controller.onLock,
                          elevation: 0,
                          backgroundColor: contentTheme.primary,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.loading
                                  ? SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        color: theme.colorScheme.onPrimary,
                                        strokeWidth: 1.2,
                                      ),
                                    )
                                  : Container(),
                              if (controller.loading) MySpacing.width(16),
                              MyText.bodySmall(
                                'unlock'.tr(),
                                color: contentTheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MySpacing.height(16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildImage() {
    return MyResponsive(
      builder: (_, __, type) {
        if (type == MyScreenMediaType.xxl) {
          return buildCard();
        } else {
          if (type == MyScreenMediaType.xl) {
            return buildCard();
          } else {
            return type != MyScreenMediaType.lg ? SizedBox() : buildCard();
          }
        }
      },
    );
  }

  Widget buildCard() {
    return MyContainer(
      borderRadiusAll: 12,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          MyContainer(
            height: 200,
            width: 200,
            color: contentTheme.primary.withAlpha(30),
            paddingAll: 0,
            child: Image.asset(
              Images.shoes[0],
            ),
          ),
          MySpacing.width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      'Nike Adapt BB 2.0',
                      fontWeight: 600,
                    ),
                    Icon(Icons.star_border)
                  ],
                ),
                MyText.bodyMedium('Consistent, customized fit, game-changing.'),
                MySpacing.height(12),
                Row(
                  children: [
                    MyText.bodyMedium(
                      '\$279.97',
                      fontWeight: 600,
                    ),
                    MySpacing.width(12),
                    MyText.bodyMedium(
                      '20% Off',
                      color: contentTheme.primary,
                    ),
                  ],
                ),
                MySpacing.height(12),
                Row(
                  children: [
                    MyContainer.rounded(
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      onTap: () {
                        controller.select(1);
                      },
                      color: controller.selectTime == 1
                          ? contentTheme.primary
                          : contentTheme.onPrimary,
                      child: Center(
                          child: MyText.bodyMedium(
                        'XS',
                        color: controller.selectTime == 1
                            ? contentTheme.onPrimary
                            : contentTheme.primary,
                      )),
                    ),
                    MyContainer.rounded(
                      onTap: () {
                        controller.select(2);
                      },
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: controller.selectTime == 2
                          ? contentTheme.primary
                          : contentTheme.onPrimary,
                      child: Center(
                        child: MyText.bodyMedium(
                          'S',
                          color: controller.selectTime == 2
                              ? contentTheme.onPrimary
                              : contentTheme.primary,
                        ),
                      ),
                    ),
                    MyContainer.rounded(
                      onTap: () {
                        controller.select(3);
                      },
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: controller.selectTime == 3
                          ? contentTheme.primary
                          : contentTheme.onPrimary,
                      child: Center(
                        child: MyText.bodyMedium(
                          'M',
                          color: controller.selectTime == 3
                              ? contentTheme.onPrimary
                              : contentTheme.primary,
                        ),
                      ),
                    ),
                    MyContainer.rounded(
                      onTap: () {
                        controller.select(4);
                      },
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: controller.selectTime == 4
                          ? contentTheme.primary
                          : contentTheme.onPrimary,
                      child: Center(
                        child: MyText.bodyMedium(
                          'L',
                          color: controller.selectTime == 4
                              ? contentTheme.onPrimary
                              : contentTheme.primary,
                        ),
                      ),
                    ),
                    MyContainer.rounded(
                      onTap: () {
                        controller.select(5);
                      },
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: controller.selectTime == 5
                          ? contentTheme.primary
                          : contentTheme.onPrimary,
                      child: Center(
                        child: MyText.bodyMedium(
                          'XL',
                          color: controller.selectTime == 5
                              ? contentTheme.onPrimary
                              : contentTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                MySpacing.height(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyContainer(
                      paddingAll: 0,
                      color: contentTheme.primary,
                      onTap: () {},
                      child: Padding(
                        padding: MySpacing.xy(8, 8),
                        child: MyText.bodyMedium(
                          'Buy Now',
                          color: contentTheme.onPrimary,
                        ),
                      ),
                    ),
                    MySpacing.width(8),
                    MyContainer(
                      paddingAll: 0,
                      color: contentTheme.secondary,
                      onTap: () {},
                      child: Padding(
                        padding: MySpacing.xy(8, 8),
                        child: MyText.bodyMedium(
                          'Add To Bag',
                          color: contentTheme.onPrimary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
