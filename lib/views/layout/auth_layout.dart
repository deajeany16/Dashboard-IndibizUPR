import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/layout/auth_layout_controller.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/widgets/my_responsiv.dart';
import 'package:webui/helper/widgets/my_spacing.dart';

class AuthLayout extends StatelessWidget {
  final Widget? child;
  ContentTheme get contentTheme => AdminTheme.theme.contentTheme;

  final AuthLayoutController controller = AuthLayoutController();

  AuthLayout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MyResponsive(builder: (BuildContext context, _, screenMT) {
      return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile
                ? mobileScreen(context)
                : largeScreen(context);
          });
    });
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: Container(
        padding: MySpacing.top(MySpacing.safeAreaTop(context) + 20),
        height: MediaQuery.of(context).size.height,
        color: theme.cardTheme.color,
        child: SingleChildScrollView(
          key: controller.scrollKey,
          child: child,
        ),
      ),
    );
  }

  Widget largeScreen(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          key: controller.scrollKey,
          child: Center(
            child: SizedBox(
              width: 500,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
