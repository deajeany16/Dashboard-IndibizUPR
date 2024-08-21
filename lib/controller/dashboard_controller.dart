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
  

  @override
  void onInit() {
    getAllOrder();
    super.onInit();
  }


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
