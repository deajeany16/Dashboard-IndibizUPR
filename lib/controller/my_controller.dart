import 'package:get/get.dart';
import 'package:webui/helper/theme/theme_customizer.dart';

abstract class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    ThemeCustomizer.addListener((old, newVal) {
      if (old.theme != newVal.theme ||
          (old.currentLanguage.languageName != newVal.currentLanguage.languageName)) {
        update();
      }
    });
  }
}
