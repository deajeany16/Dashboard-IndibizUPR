import 'package:flutter/material.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/my_text_style.dart';

class CustomInputDialog extends StatelessWidget {
  const CustomInputDialog(
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
                              title == "Tambah Order" ? Icons.add : Icons.edit,
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
                          MyText.labelMedium("Nama Inputer"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('nama'),
                            controller: validator.getController('nama'),
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
                          MyText.labelMedium("Nama Sales"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('namasales'),
                            controller: validator.getController('namasales'),
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
                          MyText.labelMedium("Kode Sales"),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('kodesales'),
                            controller: validator.getController('kodesales'),
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
                          MyText.labelMedium(
                            "Datel".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('datel'),
                            controller: validator.getController('datel'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: Palangka Raya",
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
                            validator:
                                validator.getValidation('namaperusahaan'),
                            controller:
                                validator.getController('namaperusahaan'),
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
                            validator: validator.getValidation('alamat'),
                            controller: validator.getController('alamat'),
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
                            "ODP".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('odp'),
                            controller: validator.getController('odp'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: ....",
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
                            "Latitude".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('latitude'),
                            controller: validator.getController('latitude'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: -2.123",
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
                            "Longitude".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('longitude'),
                            controller: validator.getController('longitude'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 113.890",
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
                            "No Hp".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('nohp'),
                            controller: validator.getController('nohp'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 081211223344",
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
                            "No Hp Alternatif".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('nohp2'),
                            controller: validator.getController('nohp2'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: 081211223344",
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
                            validator: validator.getValidation('email'),
                            controller: validator.getController('email'),
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
                            "No SC".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('nosc'),
                            controller: validator.getController('nosc'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: SC-1000224431",
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
                            "Keterangan Lain".tr().capitalizeWords,
                          ),
                          MySpacing.height(8),
                          TextFormField(
                            validator: validator.getValidation('ket'),
                            controller: validator.getController('ket'),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "eg: Cancel/Input Ulang/etc...",
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
                        ],
                      ),
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
