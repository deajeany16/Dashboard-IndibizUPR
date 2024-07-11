import 'package:flutter/material.dart';
import 'package:webui/helper/widgets/responsive.dart';

class MyFlexItem extends StatelessWidget {
  final Widget child;
  final String? sizes;
  final String? displays;

  Map<MyScreenMediaType, int> get flex =>
      MyScreenMedia.getFlexedDataFromString(sizes);
  Map<MyScreenMediaType, MyDisplayType> get display =>
      MyScreenMedia.getDisplayDataFromString(displays);

  MyFlexItem({
    super.key,
    required this.child,
    this.sizes,
    this.displays,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
