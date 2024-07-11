import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class SurveiService extends ApiClient {
  Future<Response> getAllSurveisByAdmin() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "survei/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSurveisBySales() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "survei/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSurveisByInputer() async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "survei/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSurveiByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await get(
        "survei/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addSurveiByAdmin(body) async {
    try {
      var token = LocalStorage.getToken();
      var response = await post(
        "survei/admin",
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

  Future<Response> editSurveiByAdmin(body, id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await put(
        "survei/admin/$id",
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

  Future<Response> deleteSurveiByAdmin(id) async {
    try {
      var token = LocalStorage.getToken();
      var response = await delete(
        "survei/admin/$id",
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
