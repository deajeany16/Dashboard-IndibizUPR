import 'package:flutter/material.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/my_text_style.dart';

class CustomBobotKriteriaDialog extends StatelessWidget {
  const CustomBobotKriteriaDialog(
      {super.key,
      required this.outlineInputBorder,
      required this.focusedInputBorder,
      required this.contentTheme,
      required this.title,
      required this.validator,
      required this.submit});

  final OutlineInputBorder outlineInputBorder;
  final OutlineInputBorder focusedInputBorder;
  final ContentTheme contentTheme;
  final String title;
  final MyFormValidator validator;
  final Future Function() submit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: MySpacing.xy(50, 50),
      child: SelectionArea(
        child: SizedBox(
          width: 500,
          height: 500,
          child: Form(
            key: validator.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: contentTheme.primary.withOpacity(0.08),
                  padding: MySpacing.xy(16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            title == "Tambah Bobot Kriteria"
                                ? Icons.add
                                : Icons.edit,
                            color: contentTheme.primary,
                            size: 16,
                          ),
                          MySpacing.width(12),
                          MyText.titleMedium(
                            title.tr(),
                            fontWeight: 600,
                            color: contentTheme.primary,
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close_outlined,
                            size: 20,
                            color: contentTheme.onBackground.withOpacity(0.5),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: MySpacing.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText.labelMedium("Nama Kriteria"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('namakriteria'),
                            controller: validator.getController('namakriteria'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedInputBorder,
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                          MySpacing.height(25),
                          MyText.labelMedium("Bobot"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('bobot'),
                            controller: validator.getController('bobot'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 1",
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedInputBorder,
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                          MySpacing.height(25),
                          MyText.labelMedium("Keterangan Bobot"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('ketbobot'),
                            controller: validator.getController('ketbobot'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 1.1",
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedInputBorder,
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                          MySpacing.height(25),
                          MyText.labelMedium("ID Kriteria"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('idkriteria'),
                            controller: validator.getController('idkriteria'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 1.1",
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedInputBorder,
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: MySpacing.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: MySpacing.xy(20, 16),
                        splashColor: contentTheme.secondary.withOpacity(0.1),
                        child: MyText.labelMedium(
                          'cancel'.tr(),
                        ),
                      ),
                      MySpacing.width(16),
                      MyButton.rounded(
                        onPressed: () async {
                          submit();
                        },
                        elevation: 0,
                        padding: MySpacing.xy(20, 16),
                        backgroundColor: contentTheme.primary,
                        child: MyText.labelMedium(
                          "save".tr(),
                          color: contentTheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
