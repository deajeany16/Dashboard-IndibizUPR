import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webui/controller/dashboard_controller.dart';
import 'package:webui/helper/extensions/string.dart';
// import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/utils/my_shadow.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
// import 'package:webui/helper/utils/utils.dart';
import 'package:webui/helper/widgets/my_breadcrumb.dart';
import 'package:webui/helper/widgets/my_breadcrumb_item.dart';
import 'package:webui/helper/widgets/my_card.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_flex.dart';
import 'package:webui/helper/widgets/my_flex_item.dart';
// import 'package:webui/helper/widgets/my_list_extension.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/helper/widgets/responsive.dart';
// import 'package:webui/images.dart';
import 'package:webui/views/layout/layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late DashboardController controller;

  @override
  void initState() {
    Get.delete<DashboardController>();
    controller = Get.put(DashboardController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      "dashboard".tr(),
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'dashboard'.tr(), active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Skeletonizer(
                enabled: controller.isLoading,
                child: Padding(
                  padding: MySpacing.x(flexSpacing / 2),
                  child: MyFlex(
                    children: [
                      MyFlexItem(
                        sizes: 'lg-3',
                        child: buildProjectData(
                          contentTheme.blue,
                          Icons.folder_open,
                          'Semua Order',
                          controller.semuaInputan.toString(),
                        ),
                      ),
                      MyFlexItem(
                        sizes: 'lg-3',
                        child: buildProjectData(
                          contentTheme.blue,
                          Icons.folder_open,
                          'Data RE',
                          controller.dataRE.toString(),
                        ),
                      ),
                      MyFlexItem(
                        sizes: 'lg-3',
                        child: buildProjectData(
                          contentTheme.blue,
                          Icons.folder_open,
                          'Data PI',
                          controller.dataPI.toString(),
                        ),
                      ),
                      MyFlexItem(
                        sizes: 'lg-3',
                        child: buildProjectData(
                          contentTheme.blue,
                          Icons.folder_open,
                          'Data PS',
                          '30',
                        ),
                      ),
                      // MyFlexItem(
                      //   sizes: 'lg-6',
                      //   child: buildSalesForeCast(),
                      // ),
                      // MyFlexItem(
                      //   sizes: 'lg-6',
                      //   child: buildUpComingActivities(),
                      // ),
                      // MyFlexItem(
                      //   sizes: 'lg-6',
                      //   child: buildBalanceOverViewDetail(),
                      // ),
                      // MyFlexItem(
                      //   sizes: 'lg-6',
                      //   child: buildBalanceOverViewData(),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProjectData(
      Color color, IconData icon, String title, String number) {
    return MyCard(
      shadow: MyShadow(elevation: 0.5),
      child: Row(
        children: [
          MyContainer(
            paddingAll: 0,
            height: 50,
            width: 50,
            color: color.withAlpha(39),
            child: Icon(icon, color: color),
          ),
          MySpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyMedium(
                  title,
                  fontWeight: 600,
                ),
                MySpacing.height(4),
                MyText.bodyMedium(number),
              ],
            ),
          ),
        ],
      ),
    );
  }

//   Widget buildBalanceOverViewDetail() {
//     return MyCard(
//       shadow: MyShadow(elevation: 0.5),
//       padding: MySpacing.xy(16, 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MyText.titleMedium(
//                 'BALANCE OVERVIEW',
//                 fontWeight: 600,
//               ),
//               Icon(
//                 LucideIcons.moreVertical,
//                 size: 16,
//               )
//             ],
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(
//                   label: MyText.labelLarge(
//                     'Company',
//                     color: contentTheme.primary,
//                   ),
//                 ),
//                 DataColumn(
//                   label: MyText.labelLarge(
//                     'Sales Rep',
//                     color: contentTheme.primary,
//                   ),
//                 ),
//                 DataColumn(
//                   label: MyText.labelLarge(
//                     'Amount',
//                     color: contentTheme.primary,
//                   ),
//                 ),
//                 DataColumn(
//                   label: MyText.labelLarge(
//                     'Close Date',
//                     color: contentTheme.primary,
//                   ),
//                 ),
//               ],
//               rows: controller.dashboard
//                   .mapIndexed(
//                     (index, data) => DataRow(
//                       cells: [
//                         DataCell(
//                           SizedBox(
//                               width: 140,
//                               child: MyText.bodyMedium(data.companyName)),
//                         ),
//                         DataCell(
//                           MyText.bodyMedium(data.sales),
//                         ),
//                         DataCell(
//                           SizedBox(
//                               width: 100,
//                               child: MyText.bodyMedium("\$${data.amount}.00")),
//                         ),
//                         DataCell(Row(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             MyText.labelLarge(
//                                 '${Utils.getDateStringFromDateTime(data.date, showMonthShort: true)}'),
//                             MySpacing.width(4),
//                             MyText.bodySmall(
//                               '${Utils.getTimeStringFromDateTime(data.date, showSecond: false)}',
//                               muted: true,
//                               fontWeight: 600,
//                             )
//                           ],
//                         )),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildUpComingActivities() {
//     return MyCard(
//       shadow: MyShadow(elevation: 0.5),
//       padding: MySpacing.xy(16, 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MyText.titleMedium(
//                 'UPCOMING ACTIVITIES',
//                 fontWeight: 600,
//               ),
//               Icon(
//                 LucideIcons.moreVertical,
//                 size: 16,
//               )
//             ],
//           ),
//           MySpacing.height(20),
//           buildUpComingData(
//             15,
//             'Mon',
//             '10.00 - 11.00 AM',
//             'Campaign meeting with sales team',
//             [
//               Images.avatars[0],
//               Images.avatars[1],
//               Images.avatars[2],
//               Images.avatars[3],
//             ],
//           ),
//           MySpacing.height(16),
//           buildUpComingData(
//             10,
//             'Thu',
//             '1.00 - 1.30 PM',
//             'Campaign meeting with sales team',
//             [
//               Images.avatars[0],
//               Images.avatars[1],
//               Images.avatars[2],
//               Images.avatars[3],
//             ],
//           ),
//           MySpacing.height(16),
//           buildUpComingData(
//             28,
//             'Wed',
//             '2.00 - 3.00 AM',
//             'Campaign meeting with sales team',
//             [
//               Images.avatars[0],
//               Images.avatars[1],
//               Images.avatars[2],
//               Images.avatars[3],
//             ],
//           ),
//           MySpacing.height(16),
//           buildUpComingData(
//             13,
//             'Sat',
//             '8.00 - 6.00 AM',
//             'Campaign meeting with sales team',
//             [
//               Images.avatars[0],
//               Images.avatars[1],
//               Images.avatars[2],
//               Images.avatars[3],
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildUpComingData(
//     int date,
//     String day,
//     String time,
//     String detail,
//     List<String> images,
//   ) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             MyText.titleLarge(
//               date.toString(),
//               fontWeight: 600,
//             ),
//             MyText.bodyMedium(
//               day,
//               xMuted: true,
//             ),
//           ],
//         ),
//         MySpacing.width(16),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             MyText.titleMedium(
//               time,
//               xMuted: true,
//             ),
//             MyText.bodyMedium(
//               detail,
//               fontWeight: 600,
//             ),
//           ],
//         ),
//         Spacer(),
//         SizedBox(
//           width: 120,
//           height: 40,
//           child: Stack(
//               alignment: Alignment.centerRight,
//               children: images
//                   .mapIndexed((index, image) => Positioned(
//                         left: (18 + (20 * index)).toDouble(),
//                         child: MyContainer.rounded(
//                           paddingAll: 2,
//                           child: MyContainer.rounded(
//                             bordered: true,
//                             paddingAll: 0,
//                             child: Image.asset(
//                               image,
//                               height: 28,
//                               width: 28,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ))
//                   .toList()),
//         ),
//       ],
//     );
//   }

//   Widget buildBalanceOverViewData() {
//     return MyCard(
//       shadow: MyShadow(elevation: 0.5),
//       padding: MySpacing.xy(16, 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MyText.titleMedium(
//                 'BALANCE OVERVIEW',
//                 fontWeight: 600,
//               ),
//               MySpacing.height(20),
//               PopupMenuButton(
//                 onSelected: controller.onSelectedTimeByBalance,
//                 itemBuilder: (BuildContext context) {
//                   return ["Year", "Month", "Week", "Day", "Hours"]
//                       .map((behavior) {
//                     return PopupMenuItem(
//                       value: behavior,
//                       height: 32,
//                       child: MyText.bodySmall(
//                         behavior.toString(),
//                         color: theme.colorScheme.onBackground,
//                         fontWeight: 600,
//                       ),
//                     );
//                   }).toList();
//                 },
//                 color: theme.cardTheme.color,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     MyText.labelMedium(
//                       controller.selectedTimeByBalance.toString(),
//                       color: contentTheme.onBackground,
//                     ),
//                     Icon(
//                       LucideIcons.chevronDown,
//                       size: 22,
//                       color: contentTheme.onBackground,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           MySpacing.height(20),
//           MyFlexItem(
//             sizes: "lg-6 sm-12",
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildBalanceOverView("\$512k", 'Revenue'),
//                 buildBalanceOverView("\$452k", 'Expenses'),
//                 buildBalanceOverView("\$412k", 'Profit Ratio'),
//               ],
//             ),
//           ),
//           MySpacing.height(20),
//           SfCartesianChart(
//             plotAreaBorderWidth: 0,
//             tooltipBehavior: controller.revenue,
//             primaryXAxis: CategoryAxis(
//               majorGridLines: const MajorGridLines(width: 0),
//             ),
//             primaryYAxis: NumericAxis(),
//             series: <ChartSeries>[
//               SplineSeries<ChartSampleData, String>(
//                 color: const Color(0xff727cf5),
//                 dataLabelSettings: const DataLabelSettings(
//                   borderWidth: 100,
//                   showZeroValue: true,
//                 ),
//                 dataSource: controller.revenueChart1,
//                 xValueMapper: (ChartSampleData data, _) => data.x,
//                 yValueMapper: (ChartSampleData data, _) => data.y,
//               ),
//               SplineSeries<ChartSampleData, String>(
//                 color: const Color(0xff0acf97),
//                 dataSource: controller.revenueChart2,
//                 xValueMapper: (ChartSampleData data, _) => data.x,
//                 yValueMapper: (ChartSampleData data, _) => data.y,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildSalesForeCast() {
//     return MyCard(
//       shadow: MyShadow(elevation: 0.5),
//       padding: MySpacing.xy(16, 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MyText.titleMedium(
//                 'SALES FORECAST',
//                 fontWeight: 600,
//               ),
//               PopupMenuButton(
//                 onSelected: controller.onSelectedTimeBySales,
//                 itemBuilder: (BuildContext context) {
//                   return ["Year", "Month", "Week", "Day", "Hours"]
//                       .map((behavior) {
//                     return PopupMenuItem(
//                       value: behavior,
//                       height: 32,
//                       child: MyText.bodySmall(
//                         behavior.toString(),
//                         color: theme.colorScheme.onBackground,
//                         fontWeight: 600,
//                       ),
//                     );
//                   }).toList();
//                 },
//                 color: theme.cardTheme.color,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     MyText.labelMedium(
//                       controller.selectedTimeBySales.toString(),
//                       color: contentTheme.onBackground,
//                     ),
//                     Icon(
//                       LucideIcons.chevronDown,
//                       size: 22,
//                       color: contentTheme.onBackground,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           MySpacing.height(20),
//           SizedBox(
//             height: 264,
//             child: SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               tooltipBehavior: controller.chart,
//               axes: <ChartAxis>[
//                 NumericAxis(
//                     majorGridLines: const MajorGridLines(width: 0),
//                     opposedPosition: true,
//                     name: 'yAxis1',
//                     interval: 1000,
//                     minimum: 0,
//                     maximum: 7000)
//               ],
//               series: <ChartSeries<ChartSampleData, String>>[
//                 ColumnSeries<ChartSampleData, String>(
//                     animationDuration: 2000,
//                     width: 0.4,
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(4),
//                         topRight: Radius.circular(4)),
//                     color: contentTheme.primary,
//                     dataSource: controller.salesChartData,
//                     xValueMapper: (ChartSampleData data, _) => data.x,
//                     yValueMapper: (ChartSampleData data, _) => data.y,
//                     name: 'Unit Sold'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildBalanceOverView(String price, String name) {
//     return Column(
//       children: [
//         MyText.titleLarge(price),
//         MySpacing.height(4),
//         MyText.bodyMedium(
//           name,
//           fontWeight: 600,
//           muted: true,
//         ),
//       ],
//     );
//   }

//   Widget buildCard(
//     Color color,
//     IconData icons,
//     String accountType,
//     String price,
//     IconData trendingIcon,
//     Color trendingIconColor,
//     String percentage,
//   ) {
//     return MyCard(
//       shadow: MyShadow(elevation: 0.5),
//       padding: MySpacing.xy(16, 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: MyText.bodyLarge(
//                   accountType,
//                   fontSize: 16,
//                   fontWeight: 600,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               MyContainer(
//                 height: 70,
//                 width: 70,
//                 paddingAll: 0,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 color: color.withAlpha(30),
//                 child: Icon(
//                   icons,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     MyText.bodyLarge(
//                       price,
//                       fontWeight: 600,
//                       fontSize: 28,
//                     ),
//                     MySpacing.width(8),
//                     Icon(
//                       trendingIcon,
//                       color: trendingIconColor,
//                       size: 16,
//                     ),
//                     MySpacing.width(8),
//                     MyText.bodyMedium(
//                       "$percentage%",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
}
