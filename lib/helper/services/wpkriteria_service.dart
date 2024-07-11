import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class KriteriaService extends ApiClient {
  Future<Response> getAllKriteriasByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "kriteria/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllKriteriasBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "kriteria/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllKriteriasByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "kriteria/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getKriteriaByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "kriteria/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addKriteriaByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "kriteria/admin",
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

  Future<Response> editKriteriaByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "kriteria/admin/$id",
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

  Future<Response> deleteKriteriaByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "kriteria/admin/$id",
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
