import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'base.dart';

class NativeWebView extends WebView {
  const NativeWebView({
    required Key? key,
    required String src,
    required double? width,
    required double? height,
    required OnLoaded? onLoaded,
    required this.options,
  }) : super(
          key: key,
          src: src,
          width: width,
          height: height,
          onLoaded: onLoaded,
        );

  final WebViewOptions options;

  @override
  State<WebView> createState() => NativeWebViewState();
}

class EasyWebViewControllerWrapper extends EasyWebViewControllerWrapperBase {
  final wv.WebViewController _controller;

  EasyWebViewControllerWrapper._(this._controller);

  @override
  Future<void> evaluateJSMobile(String js) {
    return _controller.runJavaScript(js);
  }

  @override
  Future<String> evaluateJSWithResMobile(String js) {
    return _controller.runJavaScriptReturningResult(js) as Future<String>;
  }

  @override
  Object get nativeWrapper => _controller;

  @override
  void postMessageWeb(dynamic message, String targetOrigin) =>
      throw UnsupportedError("the platform doesn't support this operation");
}

class NativeWebViewState extends WebViewState<NativeWebView> {
  late wv.WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = wv.WebViewController();
    controller.loadRequest(Uri.parse(url));
    controller.setNavigationDelegate(
      wv.NavigationDelegate(
        onNavigationRequest: (request) async {
          if (widget.options.navigationDelegate == null) {
            return wv.NavigationDecision.navigate;
          }
          final _navDecision = await widget
              .options.navigationDelegate!(WebNavigationRequest(request.url));
          return _navDecision == WebNavigationDecision.prevent
              ? wv.NavigationDecision.prevent
              : wv.NavigationDecision.navigate;
        },
      ),
    );

    controller.setJavaScriptMode(wv.JavaScriptMode.unrestricted);
    widget.options.crossWindowEvents
        .map((event) => controller.addJavaScriptChannel(
              event.name,
              onMessageReceived: (javascriptMessage) {
                event.eventAction(javascriptMessage.message);
              },
            ))
        .toSet();

    // onWebViewCreated: (value) {
    //   controller = value;
    //   if (widget.onLoaded != null) {
    //     widget.onLoaded!(EasyWebViewControllerWrapper._(value));
    //   }
    // },

    // Enable hybrid composition.
    // if (Platform.isAndroid) wv.WebView.platform = wv.SurfaceAndroidWebView();
  }

  @override
  void didUpdateWidget(covariant NativeWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      reload();
    }
  }

  reload() {
    controller.reload();
  }

  @override
  Widget builder(BuildContext context, Size size, String contents) {
    return wv.WebViewWidget(
      key: widget.key,
      controller: controller,
    );
  }
}
