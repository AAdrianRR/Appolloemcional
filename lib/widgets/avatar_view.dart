import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarView extends StatefulWidget {
  final String message;

  const AvatarView({super.key, required this.message});

  @override
  State<AvatarView> createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          "https://demo.readyplayer.me/avatar/?frameApi",
        ),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _speak(widget.message);
          },
        ),
      );
  }

  // Llama al avatar y le hace hablar
  Future<void> _speak(String text) async {
    await _controller.runJavaScript("""
      window.postMessage({
        target: 'readyplayerme',
        type: 'speak',
        text: "$text"
      }, '*');
    """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebViewWidget(controller: _controller),
    );
  }
}
