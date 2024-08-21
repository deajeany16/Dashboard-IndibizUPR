import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webui/controller/alternatif_controller.dart';
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
import 'package:webui/models/wpalternatif_data.dart';
import 'package:webui/views/layout/layout.dart';
import 'package:webui/widgets/custom_alert.dart';
import 'package:webui/widgets/custom_alternatif_dialog.dart';

class AlternatifScreen extends StatefulWidget {
  const AlternatifScreen({super.key});

  @override
  State<AlternatifScreen> createState() => _AlternatifScreenState();
}

class _AlternatifScreenState extends State<AlternatifScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  List<Alternatif> altData = [];
  late AlternatifController altController;

  @override
  void initState() {
    super.initState();
    Get.delete<AlternatifController>();
    altController = Get.put(AlternatifController());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadODPData();
    });
  }

  Future<void> loadODPData() async {
    await altController.getallAlternatif();
    setState(() {
      altData = altController.allAlternatif;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? hakAkses = LocalStorage.getHakAkses();
    return Layout(
      child: GetBuilder(
        init: altController,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "WP Alternatif".tr(),
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "WP Alternatif", active: true),
                      ],
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
                            builder: (context) => CustomAlternatifDialog(
                                  title: "Tambah Alternatif",
                                  outlineInputBorder: outlineInputBorder,
                                  focusedInputBorder: focusedInputBorder,
                                  contentTheme: contentTheme,
                                  validator: controller.inputValidator,
                                  submit: () => controller.addAlternatif(),
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
                              'Tambah Alternatif'.tr().capitalizeWords,
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
                                      ),
                                    ),
                                    DataColumn(
                                      label: Skeleton.keep(
                                        child: MyText.labelMedium(
                                          'Kode Alternatif'.tr(),
                                          color: contentTheme.primary,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Skeleton.keep(
                                        child: MyText.labelMedium(
                                          'Nama Alternatif'.tr(),
                                          color: contentTheme.primary,
                                        ),
                                      ),
                                    ),
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
                                  rows: controller.allAlternatif
                                      .mapIndexed(
                                        (index, data) => DataRow(
                                          onSelectChanged: (_) {},
                                          cells: [
                                            DataCell(MyText.bodySmall(
                                                '${index + 1}')),
                                            DataCell(MyText.bodySmall(
                                                data.idalternatif)),
                                            DataCell(MyText.bodySmall(
                                                data.namaalternatif)),
                                            if (hakAkses == 'admin')
                                              DataCell(Row(
                                                children: [
                                                  IconButton(
                                                    splashRadius: 20,
                                                    onPressed: () async {
                                                      await controller
                                                          .getAlternatif(
                                                              int.parse(data
                                                                  .idalternatif));
                                                      await controller.onEdit();
                                                      if (mounted) {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              CustomAlternatifDialog(
                                                            title:
                                                                "Edit Alternatif",
                                                            outlineInputBorder:
                                                                outlineInputBorder,
                                                            focusedInputBorder:
                                                                focusedInputBorder,
                                                            contentTheme:
                                                                contentTheme,
                                                            validator: controller
                                                                .editValidator,
                                                            submit: () => controller
                                                                .editAlternatif(),
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
                                                              controller.deleteAlternatif(
                                                                  int.parse(data
                                                                      .idalternatif)),
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

  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000;
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
