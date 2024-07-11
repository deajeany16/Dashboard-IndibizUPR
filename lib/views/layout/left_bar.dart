// ignore_for_file: no_wildcard_variable_uses

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webui/helper/extensions/string.dart';
import 'package:webui/helper/services/url_service.dart';
import 'package:webui/helper/storage/local_storage.dart';
import 'package:webui/helper/theme/theme_customizer.dart';
import 'package:webui/helper/utils/my_shadow.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_card.dart';
import 'package:webui/helper/widgets/my_container.dart';
import 'package:webui/helper/widgets/my_spacing.dart';
import 'package:webui/helper/widgets/my_text.dart';
import 'package:webui/widgets/custom_pop_menu.dart';

typedef LeftbarMenuFunction = void Function(String key);

class LeftbarObserver {
  static Map<String, LeftbarMenuFunction> observers = {};

  static attachListener(String key, LeftbarMenuFunction fn) {
    observers[key] = fn;
  }

  static detachListener(String key) {
    observers.remove(key);
  }

  static notifyAll(String key) {
    for (var fn in observers.values) {
      fn(key);
    }
  }
}

class LeftBar extends StatefulWidget {
  final bool isCondensed;

  const LeftBar({super.key, this.isCondensed = false});

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar>
    with SingleTickerProviderStateMixin, UIMixin {
  final ThemeCustomizer customizer = ThemeCustomizer.instance;

  bool isCondensed = false;
  String path = UrlService.getCurrentUrl();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? hakAkses = LocalStorage.getHakAkses();
    isCondensed = widget.isCondensed;
    return MyCard(
      paddingAll: 0,
      shadow: MyShadow(position: MyShadowPosition.centerRight, elevation: 0.2),
      child: AnimatedContainer(
        color: leftBarTheme.background,
        width: isCondensed ? 70 : 260,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/dashboard');
                    },
                    child: isCondensed
                        ? Image.asset(
                            'assets/images/logo/logo-indibiz.png',
                            height: 40,
                            alignment: Alignment.center,
                          )
                        : Image.asset(
                            'assets/images/logo/logo.png',
                            height: 40,
                            alignment: Alignment.center,
                          ),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: PageScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavigationItem(
                    iconData: Icons.person,
                    title: "Dashboard".tr(),
                    isCondensed: isCondensed,
                    route: '/dashboard',
                  ),
                  labelWidget('Data Order'),
                  NavigationItem(
                    iconData: Icons.analytics,
                    title: "Semua Data",
                    route: '/data-inputan',
                    isCondensed: isCondensed,
                  ),
                  NavigationItem(
                    iconData: Icons.pie_chart,
                    title: "Data RE".tr(),
                    isCondensed: isCondensed,
                    route: '/data-re',
                  ),
                  NavigationItem(
                    iconData: Icons.signal_cellular_alt,
                    title: "Data PI",
                    route: '/data-pi',
                    isCondensed: isCondensed,
                  ),
                  NavigationItem(
                    iconData: Icons.insights,
                    title: "Data PS",
                    route: '/data-ps',
                    isCondensed: isCondensed,
                  ),
                  labelWidget('Sales Order'),
                  NavigationItem(
                    iconData: Icons.analytics,
                    title: "Inputan Sales",
                    route: '/inputan-sales',
                    isCondensed: isCondensed,
                  ),
                  if (hakAkses == 'admin') labelWidget('User'),
                  if (hakAkses == 'admin')
                    NavigationItem(
                      iconData: Icons.group_outlined,
                      title: "User List".tr(),
                      isCondensed: isCondensed,
                      route: '/user',
                    ),
                  if (hakAkses == 'admin' || hakAkses == 'inputer')
                    labelWidget('Sales'),
                  if (hakAkses == 'admin' || hakAkses == 'inputer')
                    NavigationItem(
                      iconData: Icons.group,
                      title: "Sales List".tr(),
                      isCondensed: isCondensed,
                      route: '/sales',
                    ),
                  labelWidget('ODP'),
                  NavigationItem(
                    iconData: Icons.map,
                    title: "Map ODP".tr(),
                    isCondensed: isCondensed,
                    route: '/mapodp',
                  ),
                  NavigationItem(
                    iconData: Icons.pin_drop,
                    title: "Data ODP".tr(),
                    isCondensed: isCondensed,
                    route: '/odp',
                  ),
                  labelWidget('Bussiness Strategic'),
                  NavigationItem(
                    iconData: Icons.map,
                    title: "Order & Survei Map".tr(),
                    isCondensed: isCondensed,
                    route: '/ordersurveimap',
                  ),
                  NavigationItem(
                    iconData: Icons.work,
                    title: "Data Survei".tr(),
                    isCondensed: isCondensed,
                    route: '/survei',
                  ),
                  NavigationItem(
                    iconData: Icons.data_exploration,
                    title: "Data Alternatif".tr(),
                    isCondensed: isCondensed,
                    route: '/alternatif',
                  ),
                  NavigationItem(
                    iconData: Icons.dataset,
                    title: "Data Kriteria".tr(),
                    isCondensed: isCondensed,
                    route: '/kriteria',
                  ),
                  NavigationItem(
                    iconData: Icons.dataset,
                    title: "Data Bobot Kriteria".tr(),
                    isCondensed: isCondensed,
                    route: '/bobotkriteria',
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return isCondensed
        ? MySpacing.empty()
        : Container(
            padding: MySpacing.xy(24, 8),
            child: MyText.labelSmall(
              label.toUpperCase(),
              color: leftBarTheme.labelColor,
              muted: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              fontWeight: 700,
            ),
          );
  }
}

class MenuWidget extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isCondensed;
  final bool active;
  final List<MenuItem> children;

  const MenuWidget(
      {super.key,
      required this.iconData,
      required this.title,
      this.isCondensed = false,
      this.active = false,
      this.children = const []});

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with UIMixin, SingleTickerProviderStateMixin {
  bool isHover = false;
  bool isActive = false;
  late Animation<double> _iconTurns;
  late AnimationController _controller;
  bool popupShowing = true;
  Function? hideFn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeIn)));
    LeftbarObserver.attachListener(widget.title, onChangeMenuActive);
  }

  void onChangeMenuActive(String key) {
    if (key != widget.title) {
      // onChangeExpansion(false);
    }
  }

  void onChangeExpansion(value) {
    isActive = value;
    if (isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var route = UrlService.getCurrentUrl();
    isActive = widget.children.any((element) => element.route == route);
    onChangeExpansion(isActive);
    if (hideFn != null) {
      hideFn!();
    }
    // popupShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    // var route = Uri.base.fragment;
    // isActive = widget.children.any((element) => element.route == route);

    if (widget.isCondensed) {
      return CustomPopupMenu(
        backdrop: true,
        show: popupShowing,
        hideFn: (_) => hideFn = _,
        onChange: (_) {
          popupShowing = _;
        },
        placement: CustomPopupMenuPlacement.right,
        menu: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHover = false;
            });
          },
          child: MyContainer.transparent(
            margin: MySpacing.fromLTRB(16, 0, 16, 8),
            color: isActive || isHover
                ? leftBarTheme.activeItemBackground
                : Colors.transparent,
            padding: MySpacing.xy(8, 8),
            child: Center(
              child: Icon(
                widget.iconData,
                color: (isHover || isActive)
                    ? leftBarTheme.activeItemColor
                    : leftBarTheme.onBackground,
                size: 20,
              ),
            ),
          ),
        ),
        menuBuilder: (_) => MyContainer.bordered(
          paddingAll: 8,
          width: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer.transparent(
          margin: MySpacing.fromLTRB(24, 0, 16, 0),
          paddingAll: 0,
          child: ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
                tilePadding: MySpacing.zero,
                initiallyExpanded: isActive,
                maintainState: true,
                onExpansionChanged: (_) {
                  LeftbarObserver.notifyAll(widget.title);
                  onChangeExpansion(_);
                },
                trailing: RotationTransition(
                  turns: _iconTurns,
                  child: Icon(
                    Icons.expand_more,
                    size: 18,
                    color: leftBarTheme.onBackground,
                  ),
                ),
                iconColor: leftBarTheme.activeItemColor,
                childrenPadding: MySpacing.x(12),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.iconData,
                      size: 20,
                      color: isHover || isActive
                          ? leftBarTheme.activeItemColor
                          : leftBarTheme.onBackground,
                    ),
                    MySpacing.width(18),
                    Expanded(
                      child: MyText.labelLarge(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        color: isHover || isActive
                            ? leftBarTheme.activeItemColor
                            : leftBarTheme.onBackground,
                      ),
                    ),
                  ],
                ),
                collapsedBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                backgroundColor: Colors.transparent,
                children: widget.children),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    // LeftbarObserver.detachListener(widget.title);
  }
}

class MenuItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const MenuItem({
    super.key,
    this.iconData,
    required this.title,
    this.isCondensed = false,
    this.route,
  });

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          Get.toNamed(widget.route!);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer.transparent(
          margin: MySpacing.fromLTRB(4, 0, 8, 4),
          color: isActive || isHover
              ? leftBarTheme.activeItemBackground
              : Colors.transparent,
          width: MediaQuery.of(context).size.width,
          padding: MySpacing.xy(18, 7),
          child: MyText.bodySmall(
            "${widget.isCondensed ? "" : "- "}  ${widget.title}",
            overflow: TextOverflow.clip,
            maxLines: 1,
            textAlign: TextAlign.left,
            fontSize: 12.5,
            color: isActive || isHover
                ? leftBarTheme.activeItemColor
                : leftBarTheme.onBackground,
            fontWeight: isActive || isHover ? 600 : 500,
          ),
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const NavigationItem(
      {super.key,
      this.iconData,
      required this.title,
      this.isCondensed = false,
      this.route});

  @override
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          Get.toNamed(widget.route!);
        }
      },
      child: SelectionContainer.disabled(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHover = false;
            });
          },
          child: MyContainer.transparent(
            margin: MySpacing.fromLTRB(16, 0, 16, 8),
            color: isActive || isHover
                ? leftBarTheme.activeItemBackground
                : Colors.transparent,
            padding: MySpacing.xy(8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.iconData != null)
                  Center(
                    child: Icon(
                      widget.iconData,
                      color: (isHover || isActive)
                          ? leftBarTheme.activeItemColor
                          : leftBarTheme.onBackground,
                      size: 20,
                    ),
                  ),
                if (!widget.isCondensed)
                  Flexible(
                    fit: FlexFit.loose,
                    child: MySpacing.width(16),
                  ),
                if (!widget.isCondensed)
                  Expanded(
                    flex: 3,
                    child: MyText.labelLarge(
                      widget.title,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      color: isActive || isHover
                          ? leftBarTheme.activeItemColor
                          : leftBarTheme.onBackground,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
