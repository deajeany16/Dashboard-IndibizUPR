import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/survei_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/survei_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class SurveiController extends MyController {
  List<Survei> allSurvei = [];
  List<Survei> filteredSurvei = [];
  Map<String, dynamic> survei = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  bool isLoading = true;

  @override
  void onInit() {
    filteredSurvei = _placeholderData();
    getAllSurvei();
    super.onInit();
  }

  SurveiController() {
    _initializeValidators();
  }

  void _initializeValidators() {
    inputValidator.addField(
      'namausaha',
      label: "Nama Usaha",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'latitude',
      label: "Latitude",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'longitude',
      label: "Longitude",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'jenisusaha',
      label: "Jenis Usaha",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'alamatusaha',
      label: "Alamat Usaha",
      required: false,
      controller: TextEditingController(),
    );
    _initializeEditValidator();
  }

  void _initializeEditValidator() {
    editValidator.addField(
      'namausaha',
      label: "Nama Usaha",
      required: true,
      controller: TextEditingController(text: survei['namausaha']),
    );
    editValidator.addField(
      'latitude',
      label: "Latitude",
      required: false,
      controller: TextEditingController(text: survei['latitude'].toString()),
    );
    editValidator.addField(
      'longitude',
      label: "Longitude",
      required: false,
      controller: TextEditingController(text: survei['longitude'].toString()),
    );
    editValidator.addField(
      'alamatusaha',
      label: "Alamat Usaha",
      required: false,
      controller: TextEditingController(text: survei['alamatusaha']),
    );
    editValidator.addField(
      'jenisusaha',
      label: "Jenis Usaha",
      required: false,
      controller: TextEditingController(text: survei['jenisusaha']),
    );
  }

  List<Survei> _placeholderData() {
    return List.generate(
      6,
      (index) => Survei(
        0,
        'namausaha',
        0.0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0.0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        'alamatusaha',
        'jenisusaha',
      ),
    );
  }

  // Pagination properties
  var currentPage = 1.obs;
  var itemsPerPage = 10.obs;

  // Method to change items per page
  void changeItemsPerPage(int value) {
    itemsPerPage.value = value;
    currentPage.value = 1; // Reset to the first page
    update();
  }

  // Method to change the current page
  void changePage(int page) {
    currentPage.value = page;
    update();
  }

  // Method to get paginated data
  List get paginatedData {
    int start = (currentPage.value - 1) * itemsPerPage.value;
    int end = start + itemsPerPage.value;
    return filteredSurvei.sublist(
        start, end > filteredSurvei.length ? filteredSurvei.length : end);
  }

  // Method to get total pages
  int get totalPages {
    return (filteredSurvei.length / itemsPerPage.value).ceil();
  }

  void updatePaginatedData() {
    int start = (currentPage.value - 1) * itemsPerPage.value;
    int end = start + itemsPerPage.value;
    if (itemsPerPage.value == -1) {
      paginatedData.assignAll(filteredSurvei);
    } else {
      paginatedData.assignAll(filteredSurvei.sublist(start, end));
    }
  }

  void onSearch(String query) {
    filteredSurvei = allSurvei
        .where((survei) =>
            survei.namausaha.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
    updatePaginatedData();
  }

  Future<void> onEdit() async {
    editValidator.setControllerText('namausaha', survei['namausaha'] ?? '');
    editValidator.setControllerText(
        'latitude', survei['latitude']?.toString() ?? '');
    editValidator.setControllerText(
        'longitude', survei['longitude']?.toString() ?? '');
    editValidator.setControllerText('alamatusaha', survei['alamatusaha'] ?? '');
    editValidator.setControllerText('jenisusaha', survei['jenisusaha'] ?? '');
  }

  Future<void> getAllSurvei() async {
    try {
      update();
      var surveiService = Get.put(SurveiService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic surveis;
      switch (hakAkses) {
        case "admin":
          surveis = await surveiService.getAllSurveisByAdmin();
          break;
        case "inputer":
          surveis = await surveiService.getAllSurveisByInputer();
          break;
        case "sales":
          surveis = await surveiService.getAllSurveisBySales();
          break;
      }
      if (surveis.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        allSurvei = Survei.listFromJSON(surveis.body);
        filteredSurvei = allSurvei;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredSurvei = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getSurvei(int id) async {
    try {
      update();
      var surveiService = Get.put(SurveiService());
      dynamic surveiData = await surveiService.getSurveiByAdmin(id);
      if (surveiData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        survei = surveiData.body;
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

  Future<void> addSurvei() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var surveiService = Get.put(SurveiService());
        dynamic surveiData = await surveiService
            .addSurveiByAdmin(_parseData(inputValidator.getData()));
        if (surveiData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'survei berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllSurvei();
        } else {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Gagal',
            text: surveiData
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

  Future<void> editSurvei() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var surveiService = Get.put(SurveiService());
        dynamic surveiData = await surveiService.editSurveiByAdmin(
            _parseData(editValidator.getData()), survei['idsurvei']);
        if (surveiData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllSurvei();
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

  Future<void> deleteSurvei(int id) async {
    try {
      update();
      var surveiService = Get.put(SurveiService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await surveiService.deleteSurveiByAdmin(id);
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
        getAllSurvei();
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
    data['latitude'] = double.parse(data['latitude']);
    data['longitude'] = double.parse(data['longitude']);
    // Lakukan hal serupa untuk tipe data lainnya jika diperlukan
    return data;
  }
}
