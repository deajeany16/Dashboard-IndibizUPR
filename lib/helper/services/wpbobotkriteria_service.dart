import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class BobotService extends ApiClient {
  Future<Response> getAllBobotsByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "bobotkriteria/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllBobotsBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "bobotkriteria/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllBobotsByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "bobotkriteria/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getBobotByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "bobotkriteria/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addBobotByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "bobotkriteria/admin",
        body,
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> editBobotByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "bobotkriteria/admin/$id",
        body,
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteBobotByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "bobotkriteria/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
