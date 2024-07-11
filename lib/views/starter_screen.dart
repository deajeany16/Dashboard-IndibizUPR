import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/controller/starter_controller.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_breadcrumb.dart';
import 'package:webui/helper/widgets/my_breadcrumb_item.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/responsive.dart';
import 'package:webui/views/layout/layout.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late StarterController controller;

  @override
  void initState() {
    controller = Get.put(StarterController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: GetBuilder<StarterController>(
            init: controller,
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: MySpacing.x(flexSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText.titleMedium(
                          "Starter",
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                        MyBreadcrumb(
                          children: [
                            MyBreadcrumbItem(name: 'Starter', active: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
