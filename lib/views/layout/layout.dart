// ignore_for_file: unused_element, no_wildcard_variable_uses, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/layout/layout_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/theme/app_style.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_dashed_divider.dart';
import 'package:webui/helper/widgets/my_responsiv.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/responsive.dart';
import 'package:webui/views/layout/left_bar.dart';
import 'package:webui/views/layout/right_bar.dart';
import 'package:webui/views/layout/top_bar.dart';
import 'package:webui/widgets/custom_pop_menu.dart';

class Layout extends StatelessWidget {
  final Widget? child;
  late Function accountHideFn;

  final LayoutController controller = LayoutController();
  final topBarTheme = AdminTheme.theme.topBarTheme;
  final contentTheme = AdminTheme.theme.contentTheme;

  Layout({super.key, this.child});
  @override
  Widget build(BuildContext context) {
    return MyResponsive(builder: (BuildContext context, _, screenMT) {
      return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile ? mobileScreen() : largeScreen();
          });
    });
  }

  Widget mobileScreen() {
    String? nama = LocalStorage.getNama();
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        actions: [
          CustomPopupMenu(
            backdrop: true,
            onChange: (_) {},
            offsetX: -180,
            menu: Padding(
              padding: MySpacing.xy(8, 8),
              child: Center(
                child: Icon(
                  Icons.notifications,
                  size: 18,
                ),
              ),
            ),
            menuBuilder: (_) => buildNotifications(),
          ),
          MySpacing.width(8),
          CustomPopupMenu(
            backdrop: true,
            onChange: (_) {},
            offsetX: -90,
            offsetY: 4,
            hideFn: (_) => accountHideFn = _,
            menu: Padding(
              padding: MySpacing.xy(8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyContainer.rounded(
                      paddingAll: 0,
                      child: Icon(Icons.account_circle_outlined)),
                  MySpacing.width(8),
                  MyText.labelLarge(nama ?? 'user')
                ],
              ),
            ),
            menuBuilder: (_) => buildAccountMenu(),
          ),
          MySpacing.width(20)
        ],
      ),
      drawer: LeftBar(),
      body: SingleChildScrollView(
        padding: MySpacing.top(16),
        key: controller.scrollKey,
        child: child,
      ),
    );
  }

  Widget largeScreen() {
    return SelectionArea(
      child: Scaffold(
        key: controller.scaffoldKey,
        endDrawer: RightBar(),
        body: Row(
          children: [
            LeftBar(isCondensed: ThemeCustomizer.instance.leftBarCondensed),
            Expanded(
              child: Column(
                children: [
                  TopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding:
                          MySpacing.fromLTRB(0, flexSpacing, 0, flexSpacing),
                      key: controller.scrollKey,
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotifications() {
    Widget buildNotification(String title, String description) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText.labelLarge(title),
          MySpacing.height(4),
          MyText.bodySmall(description)
        ],
      );
    }

    return MyContainer.bordered(
      paddingAll: 0,
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.xy(16, 12),
            child: MyText.titleMedium("Notification", fontWeight: 600),
          ),
          MyDashedDivider(
              height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
          Padding(
            padding: MySpacing.xy(16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // buildNotification("Your order is received",
                //     "Order #1232 is ready to deliver"),
                // MySpacing.height(12),
                // buildNotification("Account Security ",
                //     "Your account password changed 1 hour ago"),
              ],
            ),
          ),
          MyDashedDivider(
              height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
          Padding(
            padding: MySpacing.xy(16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.primary.withAlpha(28),
                  child: MyText.labelSmall(
                    "View All",
                    color: contentTheme.primary,
                  ),
                ),
                MyButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.danger.withAlpha(28),
                  child: MyText.labelSmall(
                    "Clear",
                    color: contentTheme.danger,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAccountMenu() {
    return MyContainer.bordered(
      paddingAll: 0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.xy(8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyButton(
                  elevation: 0,
                  onPressed: () => {},
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  borderRadiusAll: AppStyle.buttonRadius.medium,
                  padding: MySpacing.xy(8, 4),
                  splashColor: theme.colorScheme.onSurface.withAlpha(20),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        size: 14,
                        color: contentTheme.onBackground,
                      ),
                      MySpacing.width(8),
                      MyText.labelMedium(
                        "My Account",
                        fontWeight: 600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                AuthService.isLoggedIn = false;
                LocalStorage.setLoggedInUser(false);
                LocalStorage.setToken('');
                Get.offAllNamed('/auth/login');
                accountHideFn.call();
              },
              borderRadiusAll: AppStyle.buttonRadius.medium,
              padding: MySpacing.xy(8, 4),
              splashColor: contentTheme.danger.withAlpha(28),
              backgroundColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 14,
                    color: contentTheme.danger,
                  ),
                  MySpacing.width(8),
                  MyText.labelMedium(
                    "Log out",
                    fontWeight: 600,
                    color: contentTheme.danger,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
