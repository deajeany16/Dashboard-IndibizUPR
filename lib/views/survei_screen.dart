import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webui/controller/survei_controller.dart';
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
import 'package:webui/widgets/custom_survei_dialog.dart';

class SurveiScreen extends StatefulWidget {
  const SurveiScreen({super.key});

  @override
  State<SurveiScreen> createState() => _SurveiScreenState();
}

class _SurveiScreenState extends State<SurveiScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late SurveiController controller;
  late PageController _pageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Get.delete<SurveiController>();
    controller = Get.put(SurveiController());
    _pageController = PageController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPage(int page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset = (page - 1) * 58.0; 
        _scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? hakAkses = LocalStorage.getHakAkses();
    return Layout(
      child: GetBuilder<SurveiController>(
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
                      "Data Survei".tr(),
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Data Survei", active: true),
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
                    labelText: "Cari Data Survei",
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
              Container(
                margin: EdgeInsets.only(right: 25.0), // Adjust margin as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Items per page: "),
                    DropdownButton<int>(
                      value: controller.itemsPerPage.value,
                      elevation: 16, // Elevation for the dropdown shadow
                      dropdownColor: Colors.white,
                      items: [10, 100, -1]
                          .map((value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value == -1 ? "All" : "$value"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.changeItemsPerPage(value);
                        }
                      },
                    ),
                  ],
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
                            builder: (context) => CustomSurveiDialog(
                                  title: "Tambah Survei",
                                  outlineInputBorder: outlineInputBorder,
                                  focusedInputBorder: focusedInputBorder,
                                  contentTheme: contentTheme,
                                  validator: controller.inputValidator,
                                  submit: () => controller.addSurvei(),
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
                              'Tambah Data'.tr().capitalizeWords,
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
                                      'Nama Usaha'.tr(),
                                      color: contentTheme.primary,
                                    ),
                                  )),
                                  DataColumn(
                                      label: Skeleton.keep(
                                    child: MyText.labelMedium(
                                      'Latitude'.tr(),
                                      color: contentTheme.primary,
                                    ),
                                  )),
                                  DataColumn(
                                      label: Skeleton.keep(
                                    child: MyText.labelMedium(
                                      'Longitude'.tr(),
                                      color: contentTheme.primary,
                                    ),
                                  )),
                                  DataColumn(
                                      label: Skeleton.keep(
                                    child: MyText.labelMedium(
                                      'Alamat Usaha'.tr(),
                                      color: contentTheme.primary,
                                    ),
                                  )),
                                  DataColumn(
                                      label: Skeleton.keep(
                                    child: MyText.labelMedium(
                                      'Jenis Usaha'.tr(),
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
                                rows: controller.paginatedData
                                    .mapIndexed(
                                      (index, data) => DataRow(
                                        onSelectChanged: (_) {},
                                        cells: [
                                          DataCell(MyText.bodySmall(
                                              '${index + 1 + (controller.currentPage.value - 1) * controller.itemsPerPage.value}')),
                                          DataCell(
                                              MyText.bodySmall(data.namausaha)),
                                          DataCell(MyText.bodySmall(data
                                              .latitude
                                              .toStringAsFixed(6))),
                                          DataCell(MyText.bodySmall(data
                                              .longitude
                                              .toStringAsFixed(6))),
                                          DataCell(MyText.bodySmall(
                                              data.alamatusaha)),
                                          DataCell(MyText.bodySmall(
                                              data.jenisusaha)),
                                          if (hakAkses == 'admin')
                                            DataCell(Row(
                                              children: [
                                                IconButton(
                                                  splashRadius: 20,
                                                  onPressed: () async {
                                                    await controller.getSurvei(
                                                        data.idsurvei);
                                                    await controller.onEdit();
                                                    if (mounted) {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CustomSurveiDialog(
                                                          title: "Edit Survei",
                                                          outlineInputBorder:
                                                              outlineInputBorder,
                                                          focusedInputBorder:
                                                              focusedInputBorder,
                                                          contentTheme:
                                                              contentTheme,
                                                          validator: controller
                                                              .editValidator,
                                                          submit: () =>
                                                              controller
                                                                  .editSurvei(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.edit_document,
                                                    color: contentTheme.primary,
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
                                                            .colorScheme.error,
                                                        showCancelText: true,
                                                        onConfirmBtnTap: () =>
                                                            controller
                                                                .deleteSurvei(data
                                                                    .idsurvei),
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
                          ),
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (controller.currentPage.value > 1) {
                              controller
                                  .changePage(controller.currentPage.value - 1);
                              _pageController.animateToPage(
                                controller.currentPage.value - 2,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              _scrollToPage(controller.currentPage.value - 1);
                            }
                          },
                          icon: Icon(Icons.arrow_left),
                        ),
                        Expanded(
                          child: Container(
                            height: 50, // Adjust the height to fit your layout
                            color:
                                Colors.white, // Set background color to white
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: List.generate(controller.totalPages,
                                    (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    height: 50,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor:
                                            controller.currentPage.value ==
                                                    index + 1
                                                ? Colors.blue.shade100
                                                : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.changePage(index + 1);
                                        _pageController.jumpToPage(index);
                                        _scrollToPage(index + 1);
                                      },
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: controller.currentPage.value ==
                                                  index + 1
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.currentPage.value <
                                controller.totalPages) {
                              controller
                                  .changePage(controller.currentPage.value + 1);
                              _pageController.animateToPage(
                                controller.currentPage.value,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              _scrollToPage(controller.currentPage.value);
                            }
                          },
                          icon: Icon(Icons.arrow_right),
                        ),
                      ],
                    )
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
