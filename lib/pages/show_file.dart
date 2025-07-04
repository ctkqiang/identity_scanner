import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShowFile extends StatefulWidget {
  final String name;
  final String documentIdURL;

  const ShowFile(this.name, this.documentIdURL, {super.key});

  @override
  State<ShowFile> createState() => _ShowFileState();
}

class _ShowFileState extends State<ShowFile> {
  InAppWebViewController? webViewController;
  late InAppWebViewSettings settings;

  @override
  void initState() {
    super.initState();
    settings = InAppWebViewSettings(
      javaScriptEnabled: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.documentIdURL)),
        initialSettings: settings,
        onWebViewCreated: (controller) => webViewController = controller,
        onLoadStart: (controller, url) {},
        onLoadStop: (controller, url) {},
        onConsoleMessage: (controller, consoleMessage) {},
      ),
    );
  }
}
