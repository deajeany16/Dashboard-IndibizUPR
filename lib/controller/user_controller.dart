import 'package:flutter/widgets.dart';
import 'package:webui/controller/my_controller.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/services/user_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:get/get.dart';
import 'package:webui/helper/widgets/my_form_validator.dart';
import 'package:webui/models/user_data.dart';
import 'package:webui/widgets/custom_alert.dart';

class UserController extends MyController {
  List<User> semuaUser = [];
  List<User> filteredUser = [];
  Map<String, dynamic> user = {};
  MyFormValidator inputValidator = MyFormValidator();
  MyFormValidator editValidator = MyFormValidator();

  // MyFormValidator basicValidator = MyFormValidator();
  bool isLoading = true;

  @override
  void onInit() {
    filteredUser = _placeholderData();
    getAllUser();
    super.onInit();
  }

  UserController() {
    inputValidator.addField(
      'nama',
      label: "Nama",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'username',
      label: "Username",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'pass',
      label: "Password",
      required: true,
      controller: TextEditingController(),
    );
    inputValidator.addField(
      'hak_akses',
      label: "Hak Akses",
      required: false,
      controller: TextEditingController(),
    );
    editValidator.addField(
      'nama',
      label: "Nama",
      required: true,
      controller: TextEditingController(text: user['nama']),
    );
    editValidator.addField(
      'username',
      label: "Username",
      required: true,
      controller: TextEditingController(text: user['username']),
    );
    editValidator.addField(
      'pass',
      label: "Password",
      required: true,
      controller: TextEditingController(text: user['pass']),
    );
    editValidator.addField(
      'hak_akses',
      label: "Hak Akses",
      required: false,
      controller: TextEditingController(text: user['hak_akses']),
    );
  }

  List<User> _placeholderData() {
    return List.generate(
        5,
        (index) => User(
              0,
              'nama',
              'username',
              'hak_akses',
              'usid',
            ));
  }

  void onSearch(query) {
    filteredUser = semuaUser;
    filteredUser = filteredUser
        .where((user) => user.nama
            .toString()
            .toLowerCase()
            .contains(query.toString().toLowerCase()))
        .toList();
    update();
  }

  Future<void> getAllUser() async {
    try {
      update();
      var userService = Get.put(UserService());
      String? hakAkses = LocalStorage.getHakAkses();
      late dynamic users;
      switch (hakAkses) {
        case "admin":
          users = await userService.getAllUsersByAdmin();
          break;
        case "inputer":
          users = await userService.getAllUsersByInputer();
          break;
        case "sales":
          users = await userService.getAllUsersBySales();
          break;
      }
      if (users.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        semuaUser = User.listFromJSON(users.body);
        filteredUser = semuaUser;
        update();
        isLoading = false;
      }
    } catch (e) {
      filteredUser = [];
      Get.dialog(CustomAlert(
        context: Get.context!,
        title: 'Error',
        text: e.toString(),
        confirmBtnText: 'Okay',
      ));
    }
  }

  Future<void> getUser(id) async {
    try {
      update();
      var userService = Get.put(UserService());
      dynamic userData = await userService.getUserByAdmin(id);
      if (userData.statusCode == 401) {
        LocalStorage.setLoggedInUser(false);
        Get.offAllNamed('/auth/login');
        update();
      } else {
        user = userData.body;
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

  Future<void> addUser() async {
    try {
      if (inputValidator.validateForm()) {
        update();
        var authService = Get.put(AuthService());
        dynamic userData = await authService.register(inputValidator.getData());
        if (userData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'User berhasil dibuat',
            confirmBtnText: 'Okay',
          ));
          inputValidator.resetForm();
          getAllUser();
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
    editValidator.setControllerText('nama', user['nama']);
    editValidator.setControllerText('username', user['username']);
    editValidator.setControllerText('hak_akses', user['hak_akses']);
  }

  Future<void> editOrder() async {
    try {
      if (editValidator.validateForm()) {
        update();
        var userService = Get.put(UserService());
        dynamic userData = await userService.editUserByAdmin(
            editValidator.getData(), user['usid']);
        if (userData.statusCode == 200) {
          Get.back();
          Get.dialog(CustomAlert(
            context: Get.context!,
            title: 'Berhasil',
            text: 'Data Berhasil Diedit',
            confirmBtnText: 'Okay',
          ));
          editValidator.resetForm();
          getAllUser();
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
      var userService = Get.put(UserService());
      dynamic userData = await userService.deleteUserByAdmin(id);

      if (userData.statusCode == 200) {
        Get.back();
        Get.dialog(CustomAlert(
          context: Get.context!,
          title: 'Berhasil',
          text: 'Data Telah Dihapus',
          confirmBtnText: 'Okay',
        ));
        getAllUser();
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
