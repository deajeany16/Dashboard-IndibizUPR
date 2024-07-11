import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webui/app_constant.dart';
import 'package:webui/controller/salesorder_controller.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/app_style.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/utils/my_shadow.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/utils/utils.dart';
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
import 'package:webui/widgets/custom_inputsales_dialog.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late SalesOrderController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.delete<SalesOrderController>();
    controller = Get.put(SalesOrderController());
  }

  @override
  Widget build(BuildContext context) {
    String? hakAkses = LocalStorage.getHakAkses();
    return Layout(
        child: GetBuilder<SalesOrderController>(
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
                          "Inputan Order Sales".tr(),
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                        MyBreadcrumb(
                          children: [
                            MyBreadcrumbItem(
                                name: 'Inputan Sales'.tr(), active: true),
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
                        labelText: "Cari Order (berdasarkan Kode Sales)",
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
                      shadow: MyShadow(
                          elevation: 0.5, position: MyShadowPosition.bottom),
                      margin: MySpacing.x(flexSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MySpacing.width(8),
                                    Icon(
                                      Icons.filter_list_outlined,
                                      color: contentTheme.primary,
                                      size: 24,
                                    ),
                                    MySpacing.width(12),
                                    MyContainer.bordered(
                                      onTap: () {
                                        controller.selectDateRange();
                                      },
                                      borderColor: contentTheme.primary,
                                      padding: MySpacing.xy(8, 4),
                                      child: MediaQuery.of(context)
                                                  .size
                                                  .width <=
                                              576
                                          ? Icon(Icons.calendar_today_outlined,
                                              size: 18,
                                              color: contentTheme.primary)
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: contentTheme.primary,
                                                  size: 18,
                                                ),
                                                MySpacing.width(10),
                                                MyText.labelMedium(
                                                    controller.selectedDateRange !=
                                                            null
                                                        ? "${dateFormatter.format(controller.selectedDateRange!.elementAt(0)!)} - ${dateFormatter.format(controller.selectedDateRange!.elementAt(1)!)}"
                                                        : "Rentang Tanggal"
                                                            .tr()
                                                            .capitalizeWords,
                                                    fontWeight: 600,
                                                    color:
                                                        contentTheme.primary),
                                              ],
                                            ),
                                    ),
                                    MySpacing.width(8),
                                    if (controller.isFiltered)
                                      MyButton.outlined(
                                        onPressed: () {
                                          controller.onResetFilter();
                                        },
                                        elevation: 0,
                                        padding: MySpacing.xy(10, 8),
                                        borderColor: contentTheme.primary,
                                        splashColor: contentTheme.primary
                                            .withOpacity(0.1),
                                        borderRadiusAll: 20,
                                        child: MyText.bodySmall(
                                          'Reset',
                                          color: contentTheme.primary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Tooltip(
                                    message: "Download File Excel",
                                    child: MyButton.small(
                                      onPressed: () => Utils.createExcelFile(
                                          controller.semuaSalesOrder,
                                          tipeInputan: "salesorder"),
                                      padding:
                                          MediaQuery.of(context).size.width <=
                                                  992
                                              ? MySpacing.xy(8, 8)
                                              : MySpacing.xy(16, 16),
                                      backgroundColor: contentTheme.primary,
                                      borderRadiusAll:
                                          AppStyle.buttonRadius.medium,
                                      elevation: 0,
                                      child: Icon(
                                        Icons.download,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width <=
                                                    992
                                                ? 18
                                                : 22,
                                      ),
                                    ),
                                  ),
                                  MySpacing.width(8),
                                  MyButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CustomInputSalesDialog(
                                              title: "Inputan Order Sales",
                                              outlineInputBorder:
                                                  outlineInputBorder,
                                              focusedInputBorder:
                                                  focusedInputBorder,
                                              contentTheme: contentTheme,
                                              validator:
                                                  controller.inputValidator,
                                              submit: () =>
                                                  controller.addSalesOrder(),
                                            )),
                                    elevation: 0,
                                    padding:
                                        MediaQuery.of(context).size.width <= 576
                                            ? MySpacing.xy(8, 8)
                                            : MySpacing.xy(16, 16),
                                    backgroundColor: contentTheme.primary,
                                    borderRadiusAll:
                                        AppStyle.buttonRadius.medium,
                                    child: Icon(
                                      Icons.add_rounded,
                                      size: MediaQuery.of(context).size.width <=
                                              576
                                          ? 18
                                          : 22,
                                      color: contentTheme.onPrimary,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          MySpacing.height(16),
                          MyContainer.none(
                            borderRadiusAll: 4,
                            width: double.infinity,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
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
                                        headingRowColor:
                                            WidgetStatePropertyAll(
                                                contentTheme.primary
                                                    .withAlpha(40)),
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
                                            ),
                                          ),
                                          if (hakAkses == 'admin' ||
                                              hakAkses == 'inputer' ||
                                              hakAkses == 'sales')
                                            DataColumn(
                                                label: Skeleton.keep(
                                              child: MyText.labelMedium(
                                                'Aksi'.tr().capitalizeWords,
                                                color: contentTheme.primary,
                                              ),
                                            )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Tanggal Input'.tr(),
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Kode Sales'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Nama Sales'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Nama Perusahaan'.tr(),
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Alamat Perusahaan'
                                                  .tr()
                                                  .capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'No HP'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Email'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Paket'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Maps'.tr().capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                          DataColumn(
                                              label: Skeleton.keep(
                                            child: MyText.labelMedium(
                                              'Status Input'
                                                  .tr()
                                                  .capitalizeWords,
                                              color: contentTheme.primary,
                                            ),
                                          )),
                                        ],
                                        rows: controller.filteredSalesOrder
                                            .mapIndexed((index, data) =>
                                                DataRow(
                                                    onSelectChanged: (_) {},
                                                    cells: [
                                                      DataCell(MyText.bodySmall(
                                                          '${index + 1}')),
                                                      if (hakAkses == 'admin' ||
                                                          hakAkses ==
                                                              'inputer' ||
                                                          hakAkses == 'sales')
                                                        DataCell(Row(
                                                          children: [
                                                            IconButton(
                                                                splashRadius:
                                                                    20,
                                                                onPressed:
                                                                    () async {
                                                                  await controller
                                                                      .getSalesOrder(
                                                                          data.soid);
                                                                  await controller
                                                                      .onEdit();
                                                                  if (mounted) {
                                                                    await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            CustomInputSalesDialog(
                                                                              title: "Edit Sales Order",
                                                                              outlineInputBorder: outlineInputBorder,
                                                                              focusedInputBorder: focusedInputBorder,
                                                                              contentTheme: contentTheme,
                                                                              validator: controller.editValidator,
                                                                              submit: () => controller.editSalesOrder(),
                                                                            ));
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .edit_document,
                                                                  color: contentTheme
                                                                      .primary,
                                                                )),
                                                            IconButton(
                                                                splashRadius:
                                                                    20,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              CustomAlert(
                                                                                context: context,
                                                                                title: 'Hapus Data?',
                                                                                text: 'Anda Yakin Ingin Menghapus Data?',
                                                                                confirmBtnColor: theme.colorScheme.error,
                                                                                showCancelText: true,
                                                                                onConfirmBtnTap: () => controller.deleteSalesOrder(data.soid),
                                                                              ));
                                                                },
                                                                icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red))
                                                          ],
                                                        )),
                                                      DataCell(MyText.bodySmall(
                                                          dateFormatter.format(
                                                              data.createdAt))),
                                                      DataCell(MyText.bodySmall(
                                                          data.kodesaless)),
                                                      DataCell(MyText.bodySmall(
                                                          data.namasaless)),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.namausaha),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.alamatt),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.cp),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.emaill),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.pakett),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              Utils.launchLink(
                                                                  Uri.parse(data
                                                                      .maps)),
                                                          child:
                                                              MyText.bodySmall(
                                                            data.maps,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(SizedBox(
                                                        width: 200,
                                                        child: MyText.bodySmall(
                                                            data.statusinput),
                                                      )),
                                                    ]))
                                            .toList()),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      )),
                ],
              );
            }));
  }
}
