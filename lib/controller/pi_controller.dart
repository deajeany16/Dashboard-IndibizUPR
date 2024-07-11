import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webui/app_constant.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/order_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/inputan_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class PIScreenController extends MyController {
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();
  GlobalKey<FormFieldState> filterDateKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> filterSTOKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> filterDatelKey = GlobalKey<FormFieldState>();
  TextEditingController dateController = TextEditingController();
  bool isLoading = true;
  bool isFiltered = false;

  List semuaPI = [];
  List filteredPI = [];
  Map<String, dynamic> inputan = {};

  List<DateTime?>? selectedDateRange;
  bool isDatePickerUsed = false;
  String selectedSTO = 'STO';
  String selectedDatel = 'Datel';
  List stoList = ['PLK', 'PBU', 'SAI'];
  List datelList = ['Palangka Raya'];

  @override
  void onInit() {
    filteredPI = _placeholderData();
    getAllOrder();
    super.onInit();
  }

  PIScreenController() {
    inputValidator.addField(
      'nama',
      label: "Nama Inputer",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'namasales',
      label: "Nama Sales",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kodesales',
      label: "Kode Sales",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'datel',
      label: "datel",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'sto',
      label: "sto",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'namaperusahaan',
      label: "Nama Perusahaan",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'alamat',
      label: "alamatPerusahaan",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'odp',
      label: "odp",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'latitude',
      label: "latitude",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'longitude',
      label: "longitude",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'nohp',
      label: "noHp",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'nohp2',
      label: "noHp2",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'email',
      label: "email",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'paket',
      label: "paket",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'nosc',
      label: "nosc",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'ket',
      label: "Keterangan Lain",
      required: false,
      controller: TextEditingController(),
    );
    editValidator.addField(
      'nama',
      label: "Nama Inputer",
      required: true,
      controller: TextEditingController(text: inputan['nama']),
    );
    editValidator.addField(
      'namasales',
      label: "Nama Sales",
      required: true,
      controller: TextEditingController(text: inputan['namasales']),
    );
    editValidator.addField(
      'kodesales',
      label: "Kode Sales",
      required: true,
      controller: TextEditingController(text: inputan['kodesales']),
    );
    editValidator.addField(
      'datel',
      label: "datel",
      required: false,
      controller: TextEditingController(text: inputan['datel']),
    );
    editValidator.addField(
      'sto',
      label: "sto",
      required: false,
      controller: TextEditingController(text: inputan['sto']),
    );
    editValidator.addField(
      'namaperusahaan',
      label: "Nama Perusahaan",
      required: true,
      controller: TextEditingController(text: inputan['namaperusahaan']),
    );
    editValidator.addField(
      'alamat',
      label: "alamatPerusahaan",
      required: false,
      controller: TextEditingController(text: inputan['alamat']),
    );
    editValidator.addField(
      'odp',
      label: "odp",
      required: false,
      controller: TextEditingController(text: inputan['odp']),
    );
    editValidator.addField(
      'latitude',
      label: "latitude",
      required: false,
      controller: TextEditingController(text: inputan['latitude']),
    );
    editValidator.addField(
      'longitude',
      label: "longitude",
      required: false,
      controller: TextEditingController(text: inputan['longitude']),
    );
    editValidator.addField(
      'nohp',
      label: "noHp",
      required: false,
      controller: TextEditingController(text: inputan['nohp']),
    );
    editValidator.addField(
      'nohp2',
      label: "noHp2",
      required: false,
      controller: TextEditingController(text: inputan['nohp2']),
    );
    editValidator.addField(
      'email',
      label: "email",
      required: false,
      controller: TextEditingController(text: inputan['email']),
    );
    editValidator.addField(
      'paket',
      label: "paket",
      required: true,
      controller: TextEditingController(text: inputan['paket']),
    );
    editValidator.addField(
      'nosc',
      label: "nosc",
      required: true,
      controller: TextEditingController(text: inputan['nosc']),
    );
    editValidator.addField(
      'ket',
      label: "Keterangan Lain",
      required: false,
      controller: TextEditingController(text: inputan['ket']),
    );
  }

  Future<void> onEdit() async {
    editValidator.setControllerText('nama', inputan['nama']);
    editValidator.setControllerText('namasales', inputan['namasales']);
    editValidator.setControllerText('kodesales', inputan['kodesales']);
    editValidator.setControllerText('datel', inputan['datel']);
    editValidator.setControllerText('sto', inputan['sto']);
    editValidator.setControllerText(
        'namaperusahaan', inputan['namaperusahaan']);
    editValidator.setControllerText('alamat', inputan['alamat']);
    editValidator.setControllerText('kodesales', inputan['kodesales']);
    editValidator.setControllerText('odp', inputan['odp']);
    editValidator.setControllerText('latitude', inputan['latitude']);
    editValidator.setControllerText('longitude', inputan['longitude']);
    editValidator.setControllerText('nohp', inputan['nohp']);
    editValidator.setControllerText('nohp2', inputan['nohp2']);
    editValidator.setControllerText('email', inputan['email']);
    editValidator.setControllerText('paket', inputan['paket']);
    editValidator.setControllerText('nosc', inputan['nosc']);
    editValidator.setControllerText('ket', inputan['ket']);
  }

  List<Inputan> _placeholderData() {
    return List.generate(
        6,
        (index) => Inputan(
            '0',
            'nama',
            'nama sales',
            'kode',
            'datel inputan',
            'sto',
            'nama perusahaan inputan',
            'alamat',
            0.0,
            0.0,
            'odp',
            'nohp',
            'nohp2',
            'email',
            'paket',
            'nosc',
            'status',
            'ketstat',
            'ket',
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
    filteredPI = semuaPI;
    isFiltered = true;

    if (isDatePickerUsed) {
      onDateFilter();
    }
    if (selectedSTO != "STO" && selectedSTO.isNotEmpty) {
      onSTOFilter();
    } else {
      selectedSTO = "STO";
    }
    if (selectedDatel != "Datel" && selectedDatel.isNotEmpty) {
      onDatelFilter();
    } else {
      selectedDatel = "Datel";
    }
    update();
  }

  void onDateFilter() {
    filteredPI = filteredPI.where((inputan) {
      var startDate = selectedDateRange!.elementAt(0);
      var endDate = DateFormat("dd/MM/yyyy hh:mm").parse(
          '${dateFormatter.format(selectedDateRange!.elementAt(1)!)} 23:59');
      return inputan.createdAt != null &&
          inputan.createdAt.compareTo(startDate) >= 0 &&
          inputan.createdAt.compareTo(endDate) <= 0;
    }).toList();
  }

  void onSTOFilter() {
    filteredPI =
        filteredPI.where((inputan) => inputan.sto == selectedSTO).toList();
  }

  void onDatelFilter() {
    filteredPI =
        filteredPI.where((inputan) => inputan.datel == selectedDatel).toList();
  }

  void onResetFilter() {
    isLoading = true;
    isFiltered = false;
    filteredPI = semuaPI;
    selectedDateRange = null;
    selectedSTO = "STO";
    selectedDatel = "Datel";
    isLoading = false;
    update();
  }

  void onSearch(query) {
    filteredPI = semuaPI;
    onFilter();
    isFiltered = false;
    filteredPI = filteredPI
        .where((inputan) => inputan.nosc
            .toString()
            .toLowerCase()
            .contains(query.toString().toLowerCase()))
        .toList();
    update();
  }

  Future<void> getAllOrder() async {
    try {
      update();
      var orderService = Get.put(OrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic orders;
      switch (hakAkses) {
        case "admin":
          orders = await orderService.getPIOrderByAdmin();
          break;
        case "inputer":
          orders = await orderService.getPIOrderByInputer();
          break;
        case "sales":
          orders = await orderService.getPIOrderBySales();
          break;
      }
      if (orders.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        semuaPI = Inputan.listFromJSON(orders.body);
        if (semuaPI.isNotEmpty) {
          stoList = semuaPI.map((item) => item.sto).toSet().toList();
          datelList = semuaPI.map((item) => item.datel).toSet().toList();
        }
        filteredPI = semuaPI;
      }
    } catch (e) {
      filteredPI = [];
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

  Future<void> getOrder(id) async {
    try {
      update();
      var orderService = Get.put(OrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await orderService.getOrderByAdmin(id);
          break;
        case "inputer":
          order = await orderService.getOrderByInputer(id);
          break;
        case "sales":
          order = await orderService.getOrderBySales(id);
          break;
      }
      if (order.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        inputan = order.body;
        isLoading = false;
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

  Future<void> addOrder() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var orderService = Get.put(OrderService());
        String? hakAkses = LocalStorage.getHakAkses();
        late dynamic order;
        switch (hakAkses) {
          case "admin":
            order =
                await orderService.addOrderByAdmin(inputValidator.getData());
            break;
          case "inputer":
            order =
                await orderService.addOrderByInputer(inputValidator.getData());
            break;
        }
        if (order.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diinput',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllOrder();
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

  Future<void> editOrder() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var orderService = Get.put(OrderService());
        String? hakAkses = LocalStorage.getHakAkses();
        late dynamic order;
        switch (hakAkses) {
          case "admin":
            order = await orderService.editOrderByAdmin(
                editValidator.getData(), inputan['orderid']);
            break;
          case "inputer":
            order = await orderService.editOrderByInputer(
                editValidator.getData(), inputan['orderid']);
            break;
        }
        if (order.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllOrder();
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

  Future<void> deleteOrder(id) async {
    try {
      update();
      var orderService = Get.put(OrderService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await orderService.deleteOrderByAdmin(id);
          break;
        case "inputer":
          order = await orderService.deleteOrderByInputer(id);
          break;
      }
      if (order.statusCode == 200) {
        Get.back();
        Get.dialog(CustomAlert(
          context: Get.context!,
          title: 'Berhasil',
          text: 'Data Telah Dihapus',
          confirmBtnText: 'Okay',
        ));
        getAllOrder();
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
