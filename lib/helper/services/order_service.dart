import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class OrderService extends ApiClient {
  var token = LocalStorage.getToken();
  Future<Response> getOrderByAdmin(id) async {
    try {
      var response = await get(
        "order/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOrderByInputer(id) async {
    try {
      var response = await get(
        "order/inputer/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOrderBySales(id) async {
    try {
      var response = await get(
        "order/sales/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllOrderByAdmin() async {
    try {
      var response = await get(
        "order/admin",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPIOrderByAdmin() async {
    try {
      var response = await get(
        "order/admin/pi",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPSOrderByAdmin() async {
    try {
      var response = await get(
        "order/admin/ps",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getREOrderByAdmin() async {
    try {
      var response = await get(
        "order/admin/re",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllOrderByInputer() async {
    try {
      var response = await get(
        "order/inputer",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPIOrderByInputer() async {
    try {
      var response = await get(
        "order/inputer/pi",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPSOrderByInputer() async {
    try {
      var response = await get(
        "order/inputer/ps",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getREOrderByInputer() async {
    try {
      var response = await get(
        "order/inputer/re",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllOrderBySales() async {
    try {
      var response = await get(
        "order/sales",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPIOrderBySales() async {
    try {
      var response = await get(
        "order/sales/pi",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPSOrderBySales() async {
    try {
      var response = await get(
        "order/sales/ps",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getREOrderBySales() async {
    try {
      var response = await get(
        "order/sales/re",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addOrderByAdmin(body) async {
    try {
      var response = await post(
        "order/admin",
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

  Future<Response> addOrderByInputer(body) async {
    try {
      var response = await post(
        "order/inputer",
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

  Future<Response> editOrderByAdmin(body, id) async {
    try {
      var response = await put(
        "order/admin/$id",
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

  Future<Response> editOrderByInputer(body, id) async {
    try {
      var response = await put(
        "order/inputer/$id",
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

  Future<Response> deleteOrderByAdmin(id) async {
    try {
      var response = await delete(
        "order/admin/$id",
        headers: {
          'Authorization': 'Bearer $token', //carrier
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteOrderByInputer(id) async {
    try {
      var response = await delete(
        "order/inputer/$id",
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
