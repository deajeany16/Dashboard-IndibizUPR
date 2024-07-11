import 'package:flutter/material.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/my_text_style.dart';

class CustomODPDialog extends StatelessWidget {
  const CustomODPDialog(
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
                            title == "Tambah ODP" ? Icons.add : Icons.edit,
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
                          MyText.labelMedium("Nama ODP"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('namaodp'),
                            controller: validator.getController('namaodp'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: ODP-PKY-1",
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
                          MyText.labelMedium("Latitude"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('latitude'),
                            controller: validator.getController('latitude'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 1.12345",
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
                          MyText.labelMedium("Longitude"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('longitude'),
                            controller: validator.getController('longitude'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 100.12345",
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
                          MyText.labelMedium("Kapasitas"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('kapasitas'),
                            controller: validator.getController('kapasitas'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "1-8",
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
                          MyText.labelMedium("Terisi"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('isi'),
                            controller: validator.getController('isi'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "1-8",
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
                          MyText.labelMedium("Kosong"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('kosong'),
                            controller: validator.getController('kosong'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "1-8",
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
                          MyText.labelMedium("Reserved"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('reserved'),
                            controller: validator.getController('reserved'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "1-8",
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
                          MyText.labelMedium("Kategori"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('kategori'),
                            controller: validator.getController('kategori'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg : Hijau - Kuning - Merah - Hitam",
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
