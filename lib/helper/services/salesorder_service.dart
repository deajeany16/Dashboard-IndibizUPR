import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class SalesOrderService extends ApiClient {
  var token = LocalStorage.getToken();
  Future<Response> getSalesOrderByAdmin(id) async {
    try {
      var response = await get(
        "salesorder/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSalesOrderByInputer(id) async {
    try {
      var response = await get(
        "salesorder/inputer/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSalesOrderBySales(id) async {
    try {
      var response = await get(
        "salesorder/sales/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSalesOrderByAdmin() async {
    try {
      var response = await get(
        "salesorder/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSalesOrderByInputer() async {
    try {
      var response = await get(
        "salesorder/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllSalesOrderBySales() async {
    try {
      var response = await get(
        "salesorder/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addSalesOrderByAdmin(body) async {
    try {
      var response = await post(
        "salesorder/admin",
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

  Future<Response> addSalesOrderByInputer(body) async {
    try {
      var response = await post(
        "salesorder/inputer",
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

  Future<Response> addSalesOrderBySales(body) async {
    try {
      var response = await post(
        "salesorder/sales",
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

  Future<Response> editSalesOrderByAdmin(body, id) async {
    try {
      var response = await put(
        "salesorder/admin/$id",
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

  Future<Response> editSalesOrderByInputer(body, id) async {
    try {
      var response = await put(
        "salesorder/inputer/$id",
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

  Future<Response> editSalesOrderBySales(body, id) async {
    try {
      var response = await put(
        "salesorder/sales/$id",
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

  Future<Response> deleteSalesOrderByAdmin(id) async {
    try {
      var response = await delete(
        "salesorder/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteSalesOrderByInputer(id) async {
    try {
      var response = await delete(
        "salesorder/inputer/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteSalesOrderBySales(id) async {
    try {
      var response = await delete(
        "salesorder/sales/$id",
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
