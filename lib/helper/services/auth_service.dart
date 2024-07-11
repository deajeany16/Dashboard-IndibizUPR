import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';
import 'package:webui/helper/storage/local_storage.dart';

class AuthService extends ApiClient {
  static bool isLoggedIn = false;

  Future<Response> login(dynamic body) async {
    try {
      var response = await post("users/login", body);
      isLoggedIn = true;
      // var resJson = json.decode(response.body);
      if (response.statusCode == 200) {
        String token = response.body["token"];
        String nama = response.body["nama"];
        String hakAkses = response.body["hak_akses"];
        await LocalStorage.setToken(token);
        await LocalStorage.setLoggedInUser(true);
        await LocalStorage.setNama(nama);
        await LocalStorage.setHakAkses(hakAkses);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register(dynamic body) async {
    try {
      var response = await post("users/register", body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
