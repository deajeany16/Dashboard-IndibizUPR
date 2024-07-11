import 'package:flutter/material.dart';
import 'package:webui/app_constant.dart';
import 'package:webui/helper/extensions/extensions.dart';
import 'package:webui/helper/theme/admin_theme.dart';
import 'package:webui/helper/widgets/my_button.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';

class CustomDetailDialog extends StatelessWidget {
  const CustomDetailDialog({
    super.key,
    required this.contentTheme,
    required this.title,
    required this.inputan,
  });

  final ContentTheme contentTheme;
  final String title;
  final Map<String, dynamic> inputan;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: MySpacing.xy(50, 50),
      child: SelectionArea(
        child: SizedBox(
          width: 600,
          height: 500,
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
                          Icons.description_outlined,
                          color: contentTheme.primary,
                          size: 16,
                        ),
                        MySpacing.width(12),
                        MyText.titleMedium(
                          "Detail Order".tr(),
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
                    padding: MySpacing.y(24),
                    child: DataTable(
                      dataRowMaxHeight: double.infinity,
                      showBottomBorder: true,
                      headingRowHeight: 0,
                      dataRowMinHeight: 40,
                      columns: const [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("")),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Tanggal Input'),
                            ),
                            DataCell(MyText.bodyMedium(dateTimeFormatter
                                .format(DateTime.parse(inputan['createdAt']))))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Nama Inputer'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['nama']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Nama Sales'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['namasales']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Kode Sales'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['kodesales']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Datel'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['datel']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('STO'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['sto']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Nama Perusahaan'),
                            ),
                            DataCell(
                                MyText.bodyMedium(inputan['namaperusahaan']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Alamat Perusahaan'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['alamat'])),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('ODP'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['odp']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Latitude'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['latitude']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Longitude'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['longitude']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('No HP'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['nohp']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('No HP Alternatif'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['nohp2']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Email'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['email']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('No SC'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['nosc']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Paket'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['paket']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Status SC'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['status']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Keterangan'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['ketstat']))
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              MyText.labelMedium('Keterangan Lain'),
                            ),
                            DataCell(MyText.bodyMedium(inputan['ket']))
                          ],
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: MySpacing.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton.rounded(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 0,
                      padding: MySpacing.xy(20, 16),
                      backgroundColor: contentTheme.secondary,
                      child: MyText.labelMedium(
                        "close".tr(),
                        color: contentTheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
