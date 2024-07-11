import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class SalesService extends ApiClient {
  Future<Response> getAllSalesByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "sales/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSalesByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "sales/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSalesByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "sales/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addSalesByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "sales/admin",
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

  Future<Response> editSalesByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "sales/admin/$id",
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

  Future<Response> deleteSalesByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "sales/admin/$id",
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
