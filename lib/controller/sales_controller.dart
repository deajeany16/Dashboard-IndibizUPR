import 'package:flutter/widgets.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/sales_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:get/get.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/sales_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class SalesController extends MyController {
  List<Sales> semuaSales = [];
  List<Sales> filteredSales = [];
  Map<String, dynamic> sales = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  // MyFormValidator basicValidator = MyFormValidator();
  bool isLoading = true;

  @override
  void onInit() {
    filteredSales = _placeholderData();
    getAllSales();
    super.onInit();
  }

  SalesController() {
    inputValidator.addField(
      'namaa',
      label: "Nama Sales",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kodee',
      label: "Kode Sales",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'usertele',
      label: "Username Tele",
      required: false,
      controller: TextEditingController(),
    );
    editValidator.addField(
      'namaa',
      label: "Nama Sales",
      required: false,
      controller: TextEditingController(text: sales['namaa']),
    );
    editValidator.addField(
      'kodee',
      label: "Kode Sales",
      required: false,
      controller: TextEditingController(text: sales['kodee']),
    );
    editValidator.addField(
      'usertele',
      label: "Username Tele",
      required: false,
      controller: TextEditingController(text: sales['usertele']),
    );
  }

  List<Sales> _placeholderData() {
    return List.generate(
        5,
        (index) => Sales(
              0,
              'namaa',
              'kodee',
              'usertele',
              'said',
            ));
  }

  void onSearch(query) {
    filteredSales = semuaSales;
    filteredSales = filteredSales
        .where((user) => user.namaa
            .toString()
            .toLowerCase()
            .contains(query.toString().toLowerCase()))
        .toList();
    update();
  }

  Future<void> getAllSales() async {
    try {
      update();
      var salesService = Get.put(SalesService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic sales;
      switch (hakAkses) {
        case "admin":
          sales = await salesService.getAllSalesByAdmin();
        break;
        case "inputer":
          sales = await salesService.getAllSalesByInputer();
        break;
      }
      if (sales.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
      } else {
        semuaSales = Sales.listFromJSON(sales.body);
        filteredSales = semuaSales;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredSales = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getSales(id) async {
    try {
      update();
      var salesService = Get.put(SalesService());
      dynamic salesData = await salesService.getSalesByAdmin(id);
      if (salesData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        update();
      } else {
        sales = salesData.body;
        // isLoading = false;
        update();
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> addSales() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var salesService = Get.put(SalesService());
        dynamic salesData =
            await salesService.addSalesByAdmin(inputValidator.getData());
        if (salesData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Sales berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllSales();
        }
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }

    update();
  }

  Future<void> onEdit() async {
    editValidator.setControllerText('namaa', sales['namaa']);
    editValidator.setControllerText('kodee', sales['kodee']);
    editValidator.setControllerText('usertele', sales['usertele']);
  }

  Future<void> editSales() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var salesService = Get.put(SalesService());
        dynamic salesData = await salesService.editSalesByAdmin(
            editValidator.getData(), sales['said']);
        if (salesData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllSales();
        }
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }

    update();
  }

  Future<void> deleteSales(id) async {
    try {
      update();
      var salesService = Get.put(SalesService());
      dynamic salesData = await salesService.deleteSalesByAdmin(id);

      if (salesData.statusCode == 200) {
        Get.back();
        Get.dialog(CustomAlert(
          context: Get.context!,
          title: 'Berhasil',
          text: 'Data Telah Dihapus',
          confirmBtnText: 'Okay',
        ));
        getAllSales();
      }
    } catch (e) {
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }

    update();
  }

}
