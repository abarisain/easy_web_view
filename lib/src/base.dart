import 'package:flutter/material.dart';

import 'platforms/base.dart';

abstract class EasyWebViewBase extends StatelessWidget {
  const EasyWebViewBase({
    Key? key,
    required this.src,
    required this.width,
    required this.height,
    required this.onLoaded,
    required this.loadingBuilder,
    required this.fallbackBuilder,
    required this.options,
  }) : super(key: key);

  final String src;
  final double? width, height;
  final OnLoaded? onLoaded;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? fallbackBuilder;
  final WebViewOptions options;

  bool canBuild() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (fallbackBuilder != null) {
      return fallbackBuilder!(context);
    } else {
      return Placeholder();
    }
  }
}
