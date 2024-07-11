// ignore_for_file: no_wildcard_variable_uses

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webui/helper/localization/app_localization_delegate.dart';
import 'package:webui/helper/localization/language.dart';
import 'package:webui/helper/services/navigation_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/app_notifier.dart';
import 'package:webui/helper/theme/app_style.dart';
import 'package:webui/helper/theme/app_theme.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:webui/views/error_pages/error_404.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  await LocalStorage.init();
  AppStyle.init();
  await ThemeCustomizer.init();
  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (_, notifier, ___) {
        return GetMaterialApp(
          title: "Dashboard BS Kalteng",
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeCustomizer.instance.theme,
          navigatorKey: NavigationService.navigatorKey,
          unknownRoute: GetPage(
              name: '/notfound',
              page: () => (Error404()),
              middlewares: [AuthMiddleware()]),
          initialRoute: "/dashboard",
          getPages: getPageRoute(),
          builder: (_, child) {
            NavigationService.registerContext(_);
            return Directionality(
                textDirection: AppTheme.textDirection,
                child: child ?? Container());
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('id'),
          supportedLocales: Language.getLocales(),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
