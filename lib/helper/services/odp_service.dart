import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class ODPService extends ApiClient {
  Future<Response> getAllODPsByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "odp/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllODPsBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "odp/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllODPsByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "odp/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getODPByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "odp/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addODPByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "odp/admin",
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

  Future<Response> editODPByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "odp/admin/$id",
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

  Future<Response> deleteODPByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "odp/admin/$id",
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
