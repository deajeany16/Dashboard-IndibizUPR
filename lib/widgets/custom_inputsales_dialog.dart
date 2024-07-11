import 'package:flutter/material.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/my_text_style.dart';

class CustomInputSalesDialog extends StatelessWidget {
  const CustomInputSalesDialog(
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
    String? hakAkses = LocalStorage.getHakAkses();
    return Dialog(
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // titlePadding: MySpacing.xy(16, 12),
        insetPadding: MySpacing.xy(50, 50),
        // actionsAlignment: MainAxisAlignment.end,
        // actionsPadding: MySpacing.xy(250, 16),
        // contentPadding: MySpacing.x(16),
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
                              title == "Tambah Order Sales"
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
                            MyText.labelMedium("Kode Sales"),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('kodesaless'),
                              controller: validator.getController('kodesaless'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "eg: DS1234",
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
                            MyText.labelMedium("Nama Sales"),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('namasaless'),
                              controller: validator.getController('namasaless'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "eg: Ciya",
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
                            MyText.labelMedium(
                              "Nama Perusahaan".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('namausaha'),
                              controller: validator.getController('namausaha'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "eg: Rocket Chicken",
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
                            MyText.labelMedium(
                              "Alamat Perusahaan".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('alamatt'),
                              controller: validator.getController('alamatt'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "eg: JL. Tjilik Riwut",
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
                            MyText.labelMedium(
                              "No HP".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('cp'),
                              controller: validator.getController('cp'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "eg: 081111111111",
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
                            MyText.labelMedium(
                              "Email".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('emaill'),
                              controller: validator.getController('emaill'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "eg: rocky123@gmail.com",
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
                            MyText.labelMedium(
                              "Paket".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('pakett'),
                              controller: validator.getController('pakett'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText:
                                    "eg: 1s 100mbps internet only, PSB diskon 70%",
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
                            MyText.labelMedium(
                              "Link Maps".tr().capitalizeWords,
                            ),
                            MySpacing.height(8),
                            TextFormField(
                              validator: validator.getValidation('maps'),
                              controller: validator.getController('maps'),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText:
                                    "eg: https://maps.app.goo.gl/ABC1234EFJ",
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
                            if (hakAkses == 'admin' || hakAkses == 'inputer')
                              MySpacing.height(25),
                            if (hakAkses == 'admin' || hakAkses == 'inputer')
                              MyText.labelMedium(
                                "Status Input".tr().capitalizeWords,
                              ),
                            MySpacing.height(8),
                            if (hakAkses == 'admin' || hakAkses == 'inputer')
                              TextFormField(
                                validator:
                                    validator.getValidation('statusinput'),
                                controller:
                                    validator.getController('statusinput'),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "eg: done",
                                  labelStyle:
                                      MyTextStyle.bodySmall(xMuted: true),
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
        ));
  }
}
