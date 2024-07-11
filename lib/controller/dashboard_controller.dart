import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/helper/services/order_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/models/inputan_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class DashboardController extends GetxController {
  int semuaInputan = 0;
  int dataRE = 0;
  int dataPI = 0;
  int dataPS = 0;
  bool isLoading = true;
  // String selectedTimeBySales = "Year";
  // String selectedTimeByBalance = "Year";
  // List<DashBoardData> dashboard = [];

  // final List<ChartSampleData> salesChartData = [
  //   ChartSampleData(x: 'Sun', y: 10),
  //   ChartSampleData(x: 'Mon', y: 20),
  //   ChartSampleData(x: 'Tue', y: 15),
  //   ChartSampleData(x: 'Wed', y: 20),
  //   ChartSampleData(x: 'The', y: 30),
  //   ChartSampleData(x: 'Fri', y: 20),
  //   ChartSampleData(x: 'Sat', y: 40),
  // ];
  // final TooltipBehavior chart = TooltipBehavior(
  //   enable: true,
  //   format: 'point.x : point.y',
  // );

  // final List<ChartSampleData> balanceChart = [
  //   ChartSampleData(x: 2010, y: 35),
  //   ChartSampleData(x: 2011, y: 13),
  //   ChartSampleData(x: 2012, y: 34),
  //   ChartSampleData(x: 2013, y: 27),
  //   ChartSampleData(x: 2014, y: 40)
  // ];

  // final List<ChartSampleData> revenueChart1 = <ChartSampleData>[
  //   ChartSampleData(x: 'Mon', y: 20),
  //   ChartSampleData(x: 'Tue', y: 15),
  //   ChartSampleData(x: 'Wed', y: 35),
  //   ChartSampleData(x: 'The', y: 30),
  //   ChartSampleData(x: 'Fri', y: 45),
  //   ChartSampleData(x: 'Sat', y: 20),
  //   ChartSampleData(x: 'Sun', y: 40)
  // ];
  // final List<ChartSampleData> revenueChart2 = <ChartSampleData>[
  //   ChartSampleData(x: 'Mon', y: 5),
  //   ChartSampleData(x: 'Tue', y: 20),
  //   ChartSampleData(x: 'Wed', y: 40),
  //   ChartSampleData(x: 'The', y: 30),
  //   ChartSampleData(x: 'Fri', y: 15),
  //   ChartSampleData(x: 'Sat', y: 50),
  //   ChartSampleData(x: 'Sun', y: 15)
  // ];
  // final TooltipBehavior revenue = TooltipBehavior(
  //   enable: true,
  //   tooltipPosition: TooltipPosition.pointer,
  //   format: 'point.x : point.y',
  // );

  @override
  void onInit() {
    getAllOrder();
    super.onInit();
  }

  // void onSelectedTimeBySales(String time) {
  //   selectedTimeBySales = time;
  //   update();
  // }

  // void onSelectedTimeByBalance(String time) {
  //   selectedTimeByBalance = time;
  //   update();
  // }

  Future<void> getAllOrder() async {
    try {
      var orderService = Get.put(OrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic orders;
      switch (hakAkses) {
        case "admin":
          orders = await orderService.getAllOrderByAdmin();
          break;
        case "inputer":
          orders = await orderService.getAllOrderByInputer();
          break;
        case "sales":
          orders = await orderService.getAllOrderBySales();
          break;
      }
      if (orders.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        var semuaOrder = Inputan.listFromJSON(orders.body);
        for (var inputan in semuaOrder) {
          if (DateUtils.isSameMonth(inputan.createdAt, DateTime.now())) {
            semuaInputan++;
            if (inputan.ketstat == "RE") {
              dataRE++;
            } else if (inputan.ketstat == "PI") {
              dataPI++;
            } else if (inputan.ketstat == "PS") {
              dataPS++;
            }
          }
        }
        isLoading = false;
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    } finally {
      isLoading = false;
      update();
    }
  }
}

// class ChartSampleData {
//   ChartSampleData(
//       {this.x,
//       this.y,
//       this.xValue,
//       this.yValue,
//       this.secondSeriesYValue,
//       this.thirdSeriesYValue,
//       this.pointColor,
//       this.size,
//       this.text,
//       this.open,
//       this.close,
//       this.low,
//       this.high,
//       this.volume});

//   final dynamic x;
//   final num? y;
//   final dynamic xValue;
//   final num? yValue;
//   final num? secondSeriesYValue;
//   final num? thirdSeriesYValue;
//   final Color? pointColor;
//   final num? size;
//   final String? text;
//   final num? open;
//   final num? close;
//   final num? low;
//   final num? high;
//   final num? volume;
// }
