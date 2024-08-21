import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webui/controller/kriteria_controller.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/app_style.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/utils/my_shadow.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_breadcrumb.dart';
import 'package:webui/helper/widgets/my_breadcrumb_item.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_card.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_list_extension.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/responsive.dart';
import 'package:webui/views/layout/layout.dart';
import 'package:webui/widgets/custom_alert.dart';
import 'package:webui/widgets/custom_kriteria_dialog.dart';

class KriteriaScreen extends StatefulWidget {
  const KriteriaScreen({super.key});

  @override
  State<KriteriaScreen> createState() => _KriteriaScreenState();
}

class _KriteriaScreenState extends State<KriteriaScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late KriteriaController controller;

  @override
  void initState() {
    super.initState();
    Get.delete<KriteriaController>();
    controller = Get.put(KriteriaController());
  }

  @override
  Widget build(BuildContext context) {
    String? hakAkses = LocalStorage.getHakAkses();
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "Data Kriteria".tr(),
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Data Kriteria", active: true),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: MySpacing.xy(24, 16),
                child: TextField(
                  onSubmitted: (value) => controller.onSearch(value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    hoverColor: theme.cardTheme.color,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                    ),
                    isDense: true,
                    labelText: "Cari Kriteria",
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: focusedInputBorder,
                    contentPadding: MySpacing.horizontal(20),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              MyCard(
                shadow:
                    MyShadow(elevation: 0.5, position: MyShadowPosition.bottom),
                margin: MySpacing.x(flexSpacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hakAkses == 'admin')
                      MyButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => CustomKriteriaDialog(
                                  title: "Tambah Kriteria",
                                  outlineInputBorder: outlineInputBorder,
                                  focusedInputBorder: focusedInputBorder,
                                  contentTheme: contentTheme,
                                  validator: controller.inputValidator,
                                  submit: () => controller.addKriteria(),
                                )),
                        elevation: 0,
                        padding: MySpacing.xy(20, 16),
                        backgroundColor: contentTheme.primary,
                        borderRadiusAll: AppStyle.buttonRadius.medium,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_outlined,
                              size: 20,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.labelSmall(
                              'Tambah Kriteria'.tr().capitalizeWords,
                              color: contentTheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    MySpacing.height(14),
                    MyContainer.none(
                      borderRadiusAll: 4,
                      width: double.infinity,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: LayoutBuilder(builder: (
                        context,
                        constraints,
                      ) {
                        return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Skeletonizer(
                              enabled: controller.isLoading,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.minWidth,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  sortAscending: true,
                                  onSelectAll: (_) => {},
                                  headingRowColor: WidgetStatePropertyAll(
                                      contentTheme.primary.withAlpha(40)),
                                  dataRowMaxHeight: 40,
                                  dataRowMinHeight: 20,
                                  headingRowHeight: 45,
                                  columnSpacing: 20,
                                  showBottomBorder: false,
                                  columns: [
                                    DataColumn(
                                        label: Skeleton.keep(
                                      child: MyText.labelMedium(
                                        'No'.tr(),
                                        color: contentTheme.primary,
                                      ),
                                    )),
                                    DataColumn(
                                        label: Skeleton.keep(
                                      child: MyText.labelMedium(
                                        'Kriteria'.tr(),
                                        color: contentTheme.primary,
                                      ),
                                    )),
                                    DataColumn(
                                        label: Skeleton.keep(
                                      child: MyText.labelMedium(
                                        'Jumlah Kriteria'.tr(),
                                        color: contentTheme.primary,
                                      ),
                                    )),
                                    DataColumn(
                                        label: Skeleton.keep(
                                      child: MyText.labelMedium(
                                        'Normalisasi'.tr(),
                                        color: contentTheme.primary,
                                      ),
                                    )),
                                    if (hakAkses == 'admin')
                                      DataColumn(
                                        label: Skeleton.keep(
                                          child: MyText.labelMedium(
                                            'Aksi'.tr().capitalizeWords,
                                            color: contentTheme.primary,
                                          ),
                                        ),
                                      ),
                                  ],
                                  // Bagian Tabel Isi (Tabel Body)
                                  rows: controller.filteredKriteria
                                      .mapIndexed(
                                        (index, data) => DataRow(
                                          onSelectChanged: (_) {},
                                          cells: [
                                            DataCell(MyText.bodySmall(
                                                '${index + 1}')),
                                            DataCell(MyText.bodySmall(
                                                data.kriteria)),
                                            DataCell(MyText.bodySmall(data
                                                .bobot
                                                .toStringAsFixed(2))),
                                            DataCell(MyText.bodySmall(data
                                                .normalisasi
                                                .toStringAsFixed(4))),
                                            if (hakAkses == 'admin')
                                              DataCell(Row(
                                                children: [
                                                  IconButton(
                                                    splashRadius: 20,
                                                    onPressed: () async {
                                                      await controller
                                                          .getKriteria(
                                                              int.parse(data
                                                                  .idkriteria));
                                                      await controller.onEdit();
                                                      if (mounted) {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              CustomKriteriaDialog(
                                                            title:
                                                                "Edit Kriteria",
                                                            outlineInputBorder:
                                                                outlineInputBorder,
                                                            focusedInputBorder:
                                                                focusedInputBorder,
                                                            contentTheme:
                                                                contentTheme,
                                                            validator: controller
                                                                .editValidator,
                                                            submit: () => controller
                                                                .editKriteria(),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.edit_document,
                                                      color:
                                                          contentTheme.primary,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    splashRadius: 20,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CustomAlert(
                                                          context: context,
                                                          title: 'Hapus Data?',
                                                          text:
                                                              'Anda Yakin Ingin Menghapus Data?',
                                                          confirmBtnColor: theme
                                                              .colorScheme
                                                              .error,
                                                          showCancelText: true,
                                                          onConfirmBtnTap: () =>
                                                              controller.deleteKriteria(
                                                                  int.parse(data
                                                                      .idkriteria)),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                  )
                                                ],
                                              )),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ));
                      }),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ), 
    );
  }
}
