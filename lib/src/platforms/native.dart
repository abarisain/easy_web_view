import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'base.dart';

class NativeWebView extends WebView {
  const NativeWebView({
    required super.key,
    required super.src,
    required super.width,
    required super.height,
    required super.onLoaded,
    required super.loadingBuilder,
    required this.options,
  });

  final WebViewOptions options;

  @override
  State<WebView> createState() => NativeWebViewState();
}

class EasyWebViewControllerWrapper extends EasyWebViewControllerWrapperBase {
  final wv.WebViewController _controller;

  EasyWebViewControllerWrapper._(this._controller);

  @override
  Future<void> evaluateJSMobile(String js) async {
    return await _controller.runJavaScript(js);
  }

  @override
  Future<String> evaluateJSWithResMobile(String js) async {
    final result = _controller.runJavaScriptReturningResult(js);
    return result.toString();
  }

  @override
  Object get nativeWrapper => _controller;

  @override
  void postMessageWeb(dynamic message, String targetOrigin) =>
      throw UnsupportedError("the platform doesn't support this operation");
}

class NativeWebViewState extends WebViewState<NativeWebView> {
  wv.WebViewController controller = wv.WebViewController();
  bool _initialized = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setBackgroundColor();
    reload();
  }

  void _setBackgroundColor() {
    controller.setBackgroundColor(
        widget.options.native.backgroundColor ?? Colors.transparent);
  }

  @override
  void didUpdateWidget(covariant NativeWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      reload();
    }
  }

  Future<void> reload() async {
    if (!_initialized) {
      _initialized = true;
      await controller.setJavaScriptMode(wv.JavaScriptMode.unrestricted);
      await controller.setNavigationDelegate(
        wv.NavigationDelegate(
          onNavigationRequest: (navigationRequest) async {
            if (widget.options.navigationDelegate == null) {
              return wv.NavigationDecision.navigate;
            }
            final navDecision = await widget.options.navigationDelegate!(
              WebNavigationRequest(navigationRequest.url),
            );
            return navDecision == WebNavigationDecision.prevent
                ? wv.NavigationDecision.prevent
                : wv.NavigationDecision.navigate;
          },
          onPageFinished: (value) {
            if (widget.onLoaded != null) {
              widget.onLoaded!(EasyWebViewControllerWrapper._(controller));
            }
            setState(() {
              _loading = false;
            });
          },
        ),
      );
      if (widget.options.crossWindowEvents.isNotEmpty) {
        for (final channel in widget.options.crossWindowEvents) {
          await controller.addJavaScriptChannel(
            channel.name,
            onMessageReceived: (javascriptMessage) {
              channel.eventAction(javascriptMessage.message);
            },
          );
        }
      }
    }
    await controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget builder(BuildContext context, Size size, String contents) {
    if (_loading && widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context);
    }
    return wv.WebViewWidget(
      key: widget.key,
      controller: controller,
    );
  }
}
