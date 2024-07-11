import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:webui/app_constant.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/salesorder_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/salesorder_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class SalesOrderController extends MyController {
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();
  GlobalKey<FormFieldState> filterDateKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> filterSTOKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> filterDatelKey = GlobalKey<FormFieldState>();
  TextEditingController dateController = TextEditingController();
  bool isLoading = true;
  bool isFiltered = false;

  List semuaSalesOrder = [];
  List filteredSalesOrder = [];
  Map<String, dynamic> salesorderinputan = {};

  List<DateTime?>? selectedDateRange;
  bool isDatePickerUsed = false;

  @override
  void onInit() {
    filteredSalesOrder = _placeholderData();
    getAllSalesOrder();
    super.onInit();
  }

  SalesOrderController() {
    inputValidator.addField(
      'namasaless',
      label: "Nama Sales",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kodesaless',
      label: "Kode Sales",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'namausaha',
      label: "Nama Perusahaan",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'alamatt',
      label: "Alamat Perusahaan",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'cp',
      label: "noHp",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'emaill',
      label: "Email",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'pakett',
      label: "Paket",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'maps',
      label: "Link Maps",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'statusinput',
      label: "Status Input",
      required: false,
      controller: TextEditingController(text: salesorderinputan['statusinput']),
    );
    editValidator.addField(
      'namasaless',
      label: "Nama Sales",
      required: true,
      controller: TextEditingController(text: salesorderinputan['namasaless']),
    );
    editValidator.addField(
      'kodesaless',
      label: "Kode Sales",
      required: true,
      controller: TextEditingController(text: salesorderinputan['kodesaless']),
    );
    editValidator.addField(
      'namausaha',
      label: "Nama Perusahaan",
      required: true,
      controller: TextEditingController(text: salesorderinputan['namausaha']),
    );
    editValidator.addField(
      'alamatt',
      label: "Alamat Perusahaan",
      required: false,
      controller: TextEditingController(text: salesorderinputan['alamatt']),
    );
    editValidator.addField(
      'cp',
      label: "noHp",
      required: false,
      controller: TextEditingController(text: salesorderinputan['cp']),
    );
    editValidator.addField(
      'emaill',
      label: "Email",
      required: false,
      controller: TextEditingController(text: salesorderinputan['emaill']),
    );
    editValidator.addField(
      'pakett',
      label: "Email",
      required: false,
      controller: TextEditingController(text: salesorderinputan['pakett']),
    );
    editValidator.addField(
      'maps',
      label: "Link Maps",
      required: false,
      controller: TextEditingController(text: salesorderinputan['maps']),
    );
    editValidator.addField(
      'statusinput',
      label: "Status Input",
      required: false,
      controller: TextEditingController(text: salesorderinputan['statusinput']),
    );
  }

  Future<void> onEdit() async {
    editValidator.setControllerText(
        'namasaless', salesorderinputan['namasaless']);
    editValidator.setControllerText(
        'kodesaless', salesorderinputan['kodesaless']);
    editValidator.setControllerText(
        'namausaha', salesorderinputan['namausaha']);
    editValidator.setControllerText('alamatt', salesorderinputan['alamatt']);
    editValidator.setControllerText('cp', salesorderinputan['cp']);
    editValidator.setControllerText('emaill', salesorderinputan['emaill']);
    editValidator.setControllerText('pakett', salesorderinputan['pakett']);
    editValidator.setControllerText('maps', salesorderinputan['maps']);
    editValidator.setControllerText(
        'statusinput', salesorderinputan['statusinput']);
  }

  List<SalesOrderInputan> _placeholderData() {
    return List.generate(
        10,
        (index) => SalesOrderInputan(
            '0',
            'namasaless',
            'kodesaless',
            'namausaha',
            'alamatt',
            'cp',
            'emaill',
            'pakett',
            'maps',
            'statusinput',
            DateTime.now()));
  }

  Future<void> selectDateRange() async {
    final List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
        context: Get.context!,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          dayTextStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          selectedDayTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          weekdayLabelTextStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          controlsTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          centerAlignModePicker: true,
          selectedYearTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          yearTextStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        dialogSize: const Size(325, 400),
        value: selectedDateRange ??
            [
              DateTime.now(),
            ],
        borderRadius: BorderRadius.circular(15),
        dialogBackgroundColor: Colors.white);

    if (picked != null && picked != selectedDateRange) {
      selectedDateRange = picked;
      dateController.text = selectedDateRange.toString();
      isDatePickerUsed = true;
      onFilter();
    }
  }

  void onFilter() {
    filteredSalesOrder = semuaSalesOrder;
    isFiltered = true;

    if (isDatePickerUsed) {
      onDateFilter();
    }
    update();
  }

  void onDateFilter() {
    filteredSalesOrder = filteredSalesOrder.where((inputan) {
      var startDate = selectedDateRange!.elementAt(0);
      var endDate = DateFormat("dd/MM/yyyy hh:mm").parse(
          '${dateFormatter.format(selectedDateRange!.elementAt(1)!)} 23:59');
      return inputan.createdAt != null &&
          inputan.createdAt.compareTo(startDate) >= 0 &&
          inputan.createdAt.compareTo(endDate) <= 0;
    }).toList();
  }

  // void onSTOFilter() {
  //   filteredSalesOrder =
  //       filteredSalesOrder.where((salesorderinputan) => salesorderinputan.sto == selectedSTO).toList();
  // }

  // void onDatelFilter() {
  //   filteredSalesOrder = filteredSalesOrder
  //       .where((salesorderinputan) => salesorderinputan.datel == selectedDatel)
  //       .toList();
  // }

  void onResetFilter() {
    isLoading = true;
    isFiltered = false;
    filteredSalesOrder = semuaSalesOrder;
    selectedDateRange = null;
    isLoading = false;
    update();
  }

  void onSearch(query) {
    filteredSalesOrder = semuaSalesOrder;
    onFilter();
    isFiltered = false;
    filteredSalesOrder = filteredSalesOrder
        .where((inputan) => inputan.kodesaless
            .toString()
            .toLowerCase()
            .contains(query.toString().toLowerCase()))
        .toList();
    update();
  }

  Future<void> getAllSalesOrder() async {
    try {
      var salesorderService = Get.put(SalesOrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic salesorders;
      switch (hakAkses) {
        case "admin":
          salesorders = await salesorderService.getAllSalesOrderByAdmin();
          break;
        case "inputer":
          salesorders = await salesorderService.getAllSalesOrderByInputer();
          break;
        case "sales":
          salesorders = await salesorderService.getAllSalesOrderBySales();
          break;
      }
      if (salesorders.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        semuaSalesOrder = SalesOrderInputan.listFromJSON(salesorders.body);
        // if (semuaSalesOrder.isNotEmpty) {
        //   stoList = semuaSalesOrder.map((item) => item.sto).toSet().toList();
        //   datelList = semuaSalesOrder.map((item) => item.datel).toSet().toList();
        // }
        filteredSalesOrder = semuaSalesOrder;
      }
    } catch (e) {
      filteredSalesOrder = [];
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

  Future<void> getSalesOrder(id) async {
    try {
      update();
      var salesorderService = Get.put(SalesOrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic salesorder;
      switch (hakAkses) {
        case "admin":
          salesorder = await salesorderService.getSalesOrderByAdmin(id);
          break;
        case "inputer":
          salesorder = await salesorderService.getSalesOrderByInputer(id);
          break;
        case "sales":
          salesorder = await salesorderService.getSalesOrderBySales(id);
          break;
      }
      if (salesorder.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        salesorderinputan = salesorder.body;
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

  Future<void> addSalesOrder() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var salesorderService = Get.put(SalesOrderService());
        String? hakAkses = LocalStorage.getHakAkses();
        late dynamic salesorder;
        switch (hakAkses) {
          case "admin":
            salesorder = await salesorderService
                .addSalesOrderByAdmin(inputValidator.getData());
            break;
          case "inputer":
            salesorder = await salesorderService
                .addSalesOrderByInputer(inputValidator.getData());
            break;
          case "sales":
            salesorder = await salesorderService
                .addSalesOrderBySales(inputValidator.getData());
            break;
        }
        if (salesorder.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diinput',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllSalesOrder();
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

  Future<void> editSalesOrder() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var salesorderService = Get.put(SalesOrderService());
        String? hakAkses = LocalStorage.getHakAkses();
        late dynamic salesorder;
        switch (hakAkses) {
          case "admin":
            salesorder = await salesorderService.editSalesOrderByAdmin(
                editValidator.getData(), salesorderinputan['soid']);
            break;
          case "inputer":
            salesorder = await salesorderService.editSalesOrderByInputer(
                editValidator.getData(), salesorderinputan['soid']);
            break;
          case "sales":
            salesorder = await salesorderService.editSalesOrderBySales(
                editValidator.getData(), salesorderinputan['soid']);
            break;
        }
        if (salesorder.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllSalesOrder();
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

  Future<void> deleteSalesOrder(id) async {
    try {
      update();
      var salesorderService = Get.put(SalesOrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic salesorder;
      switch (hakAkses) {
        case "admin":
          salesorder = await salesorderService.deleteSalesOrderByAdmin(id);
          break;
        case "inputer":
          salesorder = await salesorderService.deleteSalesOrderByInputer(id);
          break;
        case "sales":
          salesorder = await salesorderService.deleteSalesOrderBySales(id);
          break;
      }
      if (salesorder.statusCode == 200) {
        Get.back();
        Get.dialog(CustomAlert(
          context: Get.context!,
          title: 'Berhasil',
          text: 'Data Telah Dihapus',
          confirmBtnText: 'Okay',
        ));
        getAllSalesOrder();
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
