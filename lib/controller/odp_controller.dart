import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/odp_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/odp_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class ODPController extends MyController {
  List<ODP> semuaODP = [];
  List<ODP> filteredODP = [];
  Map<String, dynamic> odp = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  bool isLoading = true;

  @override
  void onInit() {
    filteredODP = _placeholderData();
    getAllODP();
    super.onInit();
  }

  ODPController() {
    _initializeValidators();
  }

  void _initializeValidators() {
    inputValidator.addField(
      'namaodp',
      label: "Nama ODP",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'latitude',
      label: "Latitude",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'longitude',
      label: "Longitude",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kapasitas',
      label: "Kapasitas",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'isi',
      label: "Isi",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kosong',
      label: "Kosong",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'reserved',
      label: "Reserved",
      required: false,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'kategori',
      label: "Kategori",
      required: false,
      controller: TextEditingController(),
    );
    _initializeEditValidator();
  }

  void _initializeEditValidator() {
    editValidator.addField(
      'namaodp',
      label: "Nama ODP",
      required: true,
      controller: TextEditingController(text: odp['namaodp']),
    );
    editValidator.addField(
      'latitude',
      label: "Latitude",
      required: true,
      controller: TextEditingController(text: odp['latitude'].toString()),
    );
    editValidator.addField(
      'longitude',
      label: "Longitude",
      required: false,
      controller: TextEditingController(text: odp['longitude'].toString()),
    );
    editValidator.addField(
      'kapasitas',
      label: "Kapasitas",
      required: false,
      controller: TextEditingController(text: odp['kapasitas'].toString()),
    );
    editValidator.addField(
      'isi',
      label: "Isi",
      required: false,
      controller: TextEditingController(text: odp['isi'].toString()),
    );
    editValidator.addField(
      'kosong',
      label: "Kosong",
      required: false,
      controller: TextEditingController(text: odp['kosong'].toString()),
    );
    editValidator.addField(
      'reserved',
      label: "Reserved",
      required: false,
      controller: TextEditingController(text: odp['reserved'].toString()),
    );
    editValidator.addField(
      'kategori',
      label: "Kategori",
      required: false,
      controller: TextEditingController(text: odp['kategori']),
    );
  }

  List<ODP> _placeholderData() {
    return List.generate(
      10,
      (index) => ODP(
        0,
        'namaodp',
        0.0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0.0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        0, // Ganti nilai dengan default sesuai tipe data yang diinginkan
        'kategori',
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
    return filteredODP.sublist(start, end > filteredODP.length ? filteredODP.length : end);
  }

  // Method to get total pages
  int get totalPages {
    return (filteredODP.length / itemsPerPage.value).ceil();
  }

  void updatePaginatedData() {
    int start = (currentPage.value - 1) * itemsPerPage.value;
    int end = start + itemsPerPage.value;
    if (itemsPerPage.value == -1) {
      paginatedData.assignAll(filteredODP);
    } else {
      paginatedData.assignAll(filteredODP.sublist(start, end));
    }
  }


  void onSearch(String query) {
    filteredODP = semuaODP
        .where((odp) => odp.namaodp.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
    updatePaginatedData();
  }

  Future<void> onEdit() async {
    editValidator.setControllerText('namaodp', odp['namaodp'] ?? '');
    editValidator.setControllerText(
        'latitude', odp['latitude']?.toString() ?? '');
    editValidator.setControllerText(
        'longitude', odp['longitude']?.toString() ?? '');
    editValidator.setControllerText(
        'kapasitas', odp['kapasitas']?.toString() ?? '');
    editValidator.setControllerText('isi', odp['isi']?.toString() ?? '');
    editValidator.setControllerText('kosong', odp['kosong']?.toString() ?? '');
    editValidator.setControllerText(
        'reserved', odp['reserved']?.toString() ?? '');
    editValidator.setControllerText('kategori', odp['kategori'] ?? '');
  }

  Future<void> getAllODP() async {
    try {
      update();
      var odpService = Get.put(ODPService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic odps;
      switch (hakAkses) {
        case "admin":
          odps = await odpService.getAllODPsByAdmin();
          break;
        case "inputer":
          odps = await odpService.getAllODPsByInputer();
          break;
        case "sales":
          odps = await odpService.getAllODPsBySales();
          break;
      }
      if (odps.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        semuaODP = ODP.listFromJSON(odps.body);
        filteredODP = semuaODP;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredODP = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getodp(int id) async {
    try {
      update();
      var odpService = Get.put(ODPService());
      dynamic odpData = await odpService.getODPByAdmin(id);
      if (odpData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        odp = odpData.body;
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

  Future<void> addodp() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var odpService = Get.put(ODPService());
        dynamic odpData = await odpService
            .addODPByAdmin(_parseData(inputValidator.getData()));
        if (odpData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'ODP berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllODP();
        } else {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Gagal',
            text: odpData
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

  Future<void> editODP() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var odpService = Get.put(ODPService());
        dynamic odpData = await odpService.editODPByAdmin(
            _parseData(editValidator.getData()), odp['idodp']);
        if (odpData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllODP();
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

  Future<void> deleteODP(int id) async {
    try {
      update();
      var odpService = Get.put(ODPService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await odpService.deleteODPByAdmin(id);
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
        getAllODP();
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
    data['kapasitas'] = int.parse(data['kapasitas']);
    data['isi'] = int.parse(data['isi']);
    data['kosong'] = int.parse(data['kosong']);
    data['reserved'] = int.parse(data['reserved']);
    // Lakukan hal serupa untuk tipe data lainnya jika diperlukan
    return data;
  }
}
