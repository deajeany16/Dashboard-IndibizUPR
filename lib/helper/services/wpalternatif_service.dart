import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class AlternatifService extends ApiClient {
  Future<Response> getAllAlternatifsByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "alternatif/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllAlternatifsBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "alternatif/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllAlternatifsByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "alternatif/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAlternatifByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "alternatif/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addAlternatifByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "alternatif/admin",
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

  Future<Response> editAlternatifByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "alternatif/admin/$id",
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

  Future<Response> deleteAlternatifByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "alternatif/admin/$id",
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
