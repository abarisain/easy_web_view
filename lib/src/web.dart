import 'package:flutter/material.dart';

import 'platforms/base.dart';
import 'platforms/web.dart';
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
      return BrowserWebView(
        key: key,
        src: src,
        width: width,
        height: height,
        onLoaded: onLoaded,
        loadingBuilder: loadingBuilder,
        options: options,
      );
    }
    return super.build(context);
  }
}
