import 'package:intl/intl.dart';

final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy hh:mm aaa');
final DateFormat timeFormatter = DateFormat('jms');
const String apikey = "AIzaSyBKMi400PZpYjM2WRF4H1yfcOyPFQHgwmo";

class AppConstant {
  static int androidAppVersion = 2;
  static int iOSAppVersion = 2;
  static String version = "1.0.0";

  static String get appName => 'Dashboard BS Kalteng';
}
