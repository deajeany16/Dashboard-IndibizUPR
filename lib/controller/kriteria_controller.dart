import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/wpkriteria_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/wpkriteria_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class KriteriaController extends MyController {
  List<Kriteria> allKriteria = [];
  List<Kriteria> filteredKriteria = [];
  Map<String, dynamic> kriteria = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  bool isLoading = true;

  @override
  void onInit() {
    filteredKriteria = _placeholderData();
    getallKriteria();
    super.onInit();
  }

  KriteriaController() {
    _initializeValidators();
  }

  void _initializeValidators() {
    inputValidator.addField(
      'idkriteria',
      label: "Kode Kriteria",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kriteria',
      label: "Kriteria",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'jumlahkriteria',
      label: "Jumlah Kriteria",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'normalisasi',
      label: "Normalisasi",
      required: false,
      controller: TextEditingController(),
    );
    _initializeEditValidator();
  }

  void _initializeEditValidator() {
    editValidator.addField(
      'idkriteria',
      label: "Kode Kriteria",
      required: true,
      controller: TextEditingController(text: kriteria['idkriteria']),
    );
    editValidator.addField(
      'kriteria',
      label: "Kriteria",
      required: true,
      controller: TextEditingController(text: kriteria['kriteria']),
    );
    editValidator.addField(
      'jumlahkriteria',
      label: "Jumlah Kriteria",
      required: false,
      controller:
          TextEditingController(text: kriteria['jumlahkriteria'].toString()),
    );
    editValidator.addField(
      'normalisasi',
      label: "Normalisasi",
      required: false,
      controller:
          TextEditingController(text: kriteria['normalisasi'].toString()),
    );
  }

  List<Kriteria> _placeholderData() {
    return List.generate(
      6,
      (index) => Kriteria(
          'idkriteria',
          'kriteria',
          0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
          0.0),
    );
  }

  void onSearch(String query) {
    filteredKriteria = allKriteria
        .where((kriteria) =>
            kriteria.kriteria.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
  }

  Future<void> onEdit() async {
    editValidator.setControllerText('idkriteria', kriteria['idkriteria'] ?? '');
    editValidator.setControllerText('kriteria', kriteria['kriteria'] ?? '');
    editValidator.setControllerText(
        'jumlahkriteria', kriteria['jumlahkriteria']?.toString() ?? '');
    editValidator.setControllerText(
        'normalisasi', kriteria['normalisasi']?.toString() ?? '');
  }

  Future<void> getallKriteria() async {
    try {
      update();
      var kriteriaService = Get.put(KriteriaService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic kriterias;
      switch (hakAkses) {
        case "admin":
          kriterias = await kriteriaService.getAllKriteriasByAdmin();
          break;
        case "inputer":
          kriterias = await kriteriaService.getAllKriteriasByInputer();
          break;
        case "sales":
          kriterias = await kriteriaService.getAllKriteriasBySales();
          break;
      }
      if (kriterias.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        allKriteria = Kriteria.listFromJSON(kriterias.body);
        filteredKriteria = allKriteria;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredKriteria = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getKriteria(int id) async {
    try {
      update();
      var kriteriaService = Get.put(KriteriaService());
      dynamic kriteriaData = await kriteriaService.getKriteriaByAdmin(id);
      if (kriteriaData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        kriteria = kriteriaData.body;
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

  Future<void> addKriteria() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var kriteriaService = Get.put(KriteriaService());
        dynamic kriteriaData = await kriteriaService
            .addKriteriaByAdmin(_parseData(inputValidator.getData()));
        if (kriteriaData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'survei berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getallKriteria();
        } else {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Gagal',
            text: kriteriaData
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

  Future<void> editKriteria() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var kriteriaService = Get.put(KriteriaService());
        dynamic kriteriaData = await kriteriaService.editKriteriaByAdmin(
            _parseData(editValidator.getData()), kriteria['idkriteria']);
        if (kriteriaData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getallKriteria();
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

  Future<void> deleteKriteria(int id) async {
    try {
      update();
      var kriteriaService = Get.put(KriteriaService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic kriteria;
      switch (hakAkses) {
        case "admin":
          kriteria = await kriteriaService.deleteKriteriaByAdmin(id);
          break;
      }
      if (kriteria.statusCode == 200) {
        Get.back();
        Get.dialog(CustomAlert(
          context: Get.context!,
          title: 'Berhasil',
          text: 'Data Telah Dihapus',
          confirmBtnText: 'Okay',
        ));
        getallKriteria();
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
    data['jumlahkriteria'] = int.parse(data['jumlahkriteria']);
    data['normalisasi'] = double.parse(data['normalisasi']);
    // Lakukan hal serupa untuk tipe data lainnya jika diperlukan
    return data;
  }
}
