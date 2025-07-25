import 'dart:io';

import 'package:flutter/material.dart';

import 'platforms/base.dart';
import 'platforms/native.dart';
import 'platforms/windows.dart';
import 'base.dart';

class EasyWebView extends EasyWebViewBase {
  const EasyWebView({
    Key? key,
    required String src,
    double? height,
    double? width,
    OnLoaded? onLoaded,
    WidgetBuilder? loadingBuilder,
    WidgetBuilder? fallbackBuilder,
    WebViewOptions options = const WebViewOptions(),
  }) : super(
          key: key,
          src: src,
          height: height,
          width: width,
          onLoaded: onLoaded,
          loadingBuilder: loadingBuilder,
          fallbackBuilder: fallbackBuilder,
          options: options,
        );

  @override
  Widget build(BuildContext context) {
    if (!canBuild()) {
      if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
        return NativeWebView(
          key: key,
          src: src,
          width: width,
          height: height,
          onLoaded: onLoaded,
          loadingBuilder: loadingBuilder,
          options: options,
        );
      }

      if (Platform.isWindows) {
        return WindowsWebView(
          key: key,
          src: src,
          width: width,
          height: height,
          onLoaded: onLoaded,
          loadingBuilder: loadingBuilder,
          options: options,
        );
      }
    }
    return super.build(context);
  }
}
