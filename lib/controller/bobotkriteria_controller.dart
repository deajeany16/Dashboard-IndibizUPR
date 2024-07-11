import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/wpbobotkriteria_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/wpbobotkriteria_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class BobotkriteriaController extends MyController {
  List<Bobot> allBobot = [];
  List<Bobot> filteredBobot = [];
  Map<String, dynamic> bobotkriteria = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  bool isLoading = true;

  @override
  void onInit() {
    filteredBobot = _placeholderData();
    getallBobot();
    super.onInit();
  }

  BobotkriteriaController() {
    _initializeValidators();
  }

  void _initializeValidators() {
    inputValidator.addField(
      'namakriteria',
      label: "Nama kriteria",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'bobot',
      label: "Bobot",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'ketbobot',
      label: "Keterangan Bobot",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'idkriteria',
      label: "idkriteria",
      required: false,
      controller: TextEditingController(),
    );
    _initializeEditValidator();
  }

  void _initializeEditValidator() {
    editValidator.addField(
      'namakriteria',
      label: "Nama Kriteria",
      required: true,
      controller: TextEditingController(text: bobotkriteria['namakriteria']),
    );
    editValidator.addField(
      'bobot',
      label: "bobot",
      required: false,
      controller:
          TextEditingController(text: bobotkriteria['bobot'].toString()),
    );
    editValidator.addField(
      'ketbobot',
      label: "Keterangan Bobot",
      required: false,
      controller:
          TextEditingController(text: bobotkriteria['ketbobot'].toString()),
    );
    editValidator.addField(
      'idkriteria',
      label: "ID Kriteria",
      required: false,
      controller: TextEditingController(text: bobotkriteria['idkriteria']),
    );
  }

  List<Bobot> _placeholderData() {
    return List.generate(
      6,
      (index) => Bobot(0, 'namakriteria', 0, 'ketbobot', 0),
    );
  }

  void onSearch(String query) {
    filteredBobot = allBobot
        .where((bobotkriteria) => bobotkriteria.namakriteria
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    update();
  }

  Future<void> onEdit() async {
    editValidator.setControllerText(
        'namakriteria', bobotkriteria['namakriteria'] ?? '');
    editValidator.setControllerText(
        'bobot', bobotkriteria['bobot']?.toString() ?? '');
    editValidator.setControllerText(
        'ketbobot', bobotkriteria['ketbobot'] ?? '');
    editValidator.setControllerText(
        'idkriteria', bobotkriteria['idkriteria']?.toString() ?? '');
  }

  Future<void> getallBobot() async {
    try {
      update();
      var bobotkriteriaService = Get.put(BobotService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic bobotkriterias;
      switch (hakAkses) {
        case "admin":
          bobotkriterias = await bobotkriteriaService.getAllBobotsByAdmin();
          break;
        case "inputer":
          bobotkriterias = await bobotkriteriaService.getAllBobotsByInputer();
          break;
        case "sales":
          bobotkriterias = await bobotkriteriaService.getAllBobotsBySales();
          break;
      }
      if (bobotkriterias.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        allBobot = Bobot.listFromJSON(bobotkriterias.body);
        filteredBobot = allBobot;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredBobot = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getbobotkriteria(int id) async {
    try {
      update();
      var bobotkriteriaService = Get.put(BobotService());
      dynamic bobotkriteriaData =
          await bobotkriteriaService.getBobotByAdmin(id);
      if (bobotkriteriaData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        bobotkriteria = bobotkriteriaData.body;
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

  Future<void> addbobotkriteria() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var bobotkriteriaService = Get.put(BobotService());
        dynamic bobotkriteriaData = await bobotkriteriaService
            .addBobotByAdmin(_parseData(inputValidator.getData()));
        if (bobotkriteriaData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Bobot Kriteria berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getallBobot();
        } else {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Gagal',
            text: bobotkriteriaData
                .body['message'], // Ubah pesan kesalahan sesuai respons API
            confirmBtnText: 'Okay',
          ));
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

  Future<void> editbobotkriteria() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var bobotkriteriaService = Get.put(BobotService());
        dynamic bobotkriteriaData = await bobotkriteriaService.editBobotByAdmin(
            _parseData(editValidator.getData()),
            bobotkriteria['idbobot']);
        if (bobotkriteriaData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getallBobot();
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

  Future<void> deletebobotkriteria(int id) async {
    try {
      update();
      var bobotkriteriaService = Get.put(BobotService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await bobotkriteriaService.deleteBobotByAdmin(id);
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
        getallBobot();
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

  Map<String, dynamic> _parseData(Map<String, dynamic> data) {
    // Parsing data ke tipe yang sesuai di sini
    data['bobot'] = int.parse(data['bobot']);
    // Lakukan hal serupa untuk tipe data lainnya jika diperlukan
    return data;
  }
}
