import 'package:flutter/material.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';

class CustomAlert extends StatelessWidget {
  CustomAlert(
      {super.key,
      required this.context,
      this.text,
      this.title,
      this.confirmBtnText = 'Confirm',
      this.cancelBtnText = 'Cancel',
      this.showConfirmText = true,
      this.showCancelText = false,
      this.confirmBtnColor,
      this.cancelBtnColor,
      this.onConfirmBtnTap});

  final BuildContext context;
  final String? text;
  final String? title;
  final String? confirmBtnText;
  final Color? confirmBtnColor;
  final String? cancelBtnText;
  final Color? cancelBtnColor;
  final bool? showConfirmText;
  final bool? showCancelText;
  final Future Function()? onConfirmBtnTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MyText.labelLarge(title!.tr()),
      content: MyText.bodySmall(text!.tr()),
      actions: [
        showCancelText == true
            ? MyButton.rounded(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 0,
                padding: MySpacing.xy(20, 16),
                backgroundColor: theme.colorScheme.onSecondary,
                child: MyText.labelMedium(
                  cancelBtnText!.tr(),
                  color: theme.colorScheme.secondary,
                ),
              )
            : SizedBox(height: 0),
        showConfirmText == true
            ? MyButton.rounded(
                onPressed: onConfirmBtnTap ??
                    () {
                      Navigator.pop(context);
                    },
                elevation: 0,
                padding: MySpacing.xy(20, 16),
                backgroundColor: confirmBtnColor ?? theme.colorScheme.primary,
                child: MyText.labelMedium(
                  confirmBtnText!.tr(),
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : SizedBox(height: 0),
      ],
    );
  }
}
