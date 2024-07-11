import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/wpalternatif_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/wpalternatif_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class AlternatifController extends MyController {
  List<Alternatif> allAlternatif = [];
  Map<String, dynamic> alternatif = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  bool isLoading = true;

  @override
  void onInit() {
    getallAlternatif();
    super.onInit();
  }

  AlternatifController() {
    _initializeValidators();
  }

  void _initializeValidators() {
    inputValidator.addField(
      'namaalternatif',
      label: "Nama Alternatif",
      required: true,
      controller: TextEditingController(),
    );
    _initializeEditValidator();
  }

  void _initializeEditValidator() {
    editValidator.addField(
      'namaalternatif',
      label: "Nama Alternatif",
      required: true,
      controller: TextEditingController(text: alternatif['namaalternatif']),
    );
  }

  // ignore: unused_element
  List<Alternatif> _placeholderData() {
    return List.generate(
      2,
      (index) => Alternatif(
        0,
        'namaalternatif',
      ),
    );
  }

  Future<void> onEdit() async {
    editValidator.setControllerText(
        'namaalternatif', alternatif['namaalternatif'] ?? '');
  }

  Future<void> getallAlternatif() async {
    try {
      update();
      var alternatifService = Get.put(AlternatifService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic surveis;
      switch (hakAkses) {
        case "admin":
          surveis = await alternatifService.getAllAlternatifsByAdmin();
          break;
        case "inputer":
          surveis = await alternatifService.getAllAlternatifsByInputer();
          break;
        case "sales":
          surveis = await alternatifService.getAllAlternatifsBySales();
          break;
      }
      if (surveis.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        allAlternatif = Alternatif.listFromJSON(surveis.body);
        update();
        isLoading = false;
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

  Future<void> getAlternatif(int id) async {
    try {
      update();
      var alternatifService = Get.put(AlternatifService());
      dynamic alternatifData = await alternatifService.getAlternatifByAdmin(id);
      if (alternatifData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        alternatif = alternatifData.body;
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

  Future<void> addAlternatif() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var alternatifService = Get.put(AlternatifService());
        dynamic alternatifData = await alternatifService
            .addAlternatifByAdmin((inputValidator.getData()));
        if (alternatifData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Alternatif berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getallAlternatif();
        } else {
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Gagal',
            text: alternatifData
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

  Future<void> editAlternatif() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var alternatifService = Get.put(AlternatifService());
        dynamic alternatifData = await alternatifService.editAlternatifByAdmin(
            (editValidator.getData()), alternatif['idalternatif']);
        if (alternatifData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getallAlternatif();
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

  Future<void> deleteAlternatif(int id) async {
    try {
      update();
      var alternatifService = Get.put(AlternatifService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic order;
      switch (hakAkses) {
        case "admin":
          order = await alternatifService.deleteAlternatifByAdmin(id);
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
        getallAlternatif();
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
