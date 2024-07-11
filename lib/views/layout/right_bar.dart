import 'package:flutter/material.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/widgets/custom_switch.dart';

class RightBar extends StatefulWidget {
  // final RightBarThemeType rightBarThemeType;
  // final LeftBarThemeType leftBarThemeType;
  // final TopBarThemeType topBarThemeType;
  // final ContentThemeType contentThemeType;
  // final OnLeftBarColorSchemeChange onLeftBarColorSchemeChange;
  // final OnTopBarColorSchemeChange onTopBarColorSchemeChange;
  // final OnRightBarColorSchemeChange onRightBarColorSchemeChange;
  // final OnContentSchemeChange onContentSchemeChange;

  const RightBar({
    super.key, // this.leftBarThemeType,
    // this.topBarThemeType,
    // this.contentThemeType,
    // this.onLeftBarColorSchemeChange,
    // this.onTopBarColorSchemeChange,
    // this.onContentSchemeChange,
    // this.onRightBarColorSchemeChange
  });

  @override
  _RightBarState createState() => _RightBarState();
}

class _RightBarState extends State<RightBar> with SingleTickerProviderStateMixin, UIMixin {
  ThemeCustomizer customizer = ThemeCustomizer.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    customizer = ThemeCustomizer.instance;
    return Container(
      width: 280,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            padding: MySpacing.x(24),
            color: theme.colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyText.labelLarge(
                    "Settings",
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            padding: MySpacing.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.labelMedium("Color Scheme"),
                Divider(),
                MySpacing.height(8),
                Row(
                  children: [
                    CustomSwitch.small(
                      value: customizer.theme == ThemeMode.light,
                      onChanged: (value) {
                        ThemeCustomizer.setTheme(ThemeMode.light);
                      },
                    ),
                    MySpacing.width(12),
                    Text(
                      "Light",
                    )
                  ],
                ),
                MySpacing.height(8),
                Row(
                  children: [
                    CustomSwitch.small(
                      value: customizer.theme == ThemeMode.dark,
                      onChanged: (value) {
                        ThemeCustomizer.setTheme(ThemeMode.dark);
                      },
                    ),
                    MySpacing.width(12),
                    Text(
                      "Dark",
                    )
                  ],
                ),
                Divider(),
                Text("Top Bar"),
                Divider(),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
