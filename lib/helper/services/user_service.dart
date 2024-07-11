import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class UserService extends ApiClient {
  Future<Response> getAllUsersByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "users/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllUsersBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "users/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllUsersByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "users/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "users/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> editUserByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "users/admin/edit/$id",
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

  Future<Response> deleteUserByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "users/admin/hapus/$id",
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
